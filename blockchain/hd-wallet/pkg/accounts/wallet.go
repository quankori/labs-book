package accounts

import (
	"crypto/sha256"
	"encoding/binary"
	"errors"
	"fmt"
	"math/big"
	"strings"

	secp256k1 "github.com/btcsuite/btcd/btcec"
	"github.com/btcsuite/btcutil"
	"github.com/btcsuite/btcutil/bech32"
	"github.com/quankori/go-hd-wallet/internals/bip39"
	"github.com/quankori/go-hd-wallet/internals/hd"
	"github.com/quankori/go-hd-wallet/pkg/constants"
)

// Some bitwise operands for working with big.Ints
var (
	Last11BitsMask          = big.NewInt(2047)
	RightShift11BitsDivider = big.NewInt(2048)
	BigOne                  = big.NewInt(1)
	BigTwo                  = big.NewInt(2)
)

// NewMnemonic will return a string consisting of the mnemonic words for
// the given entropy.
// If the provide entropy is invalid, an error will be returned.
func NewMnemonic(entropy []byte) (string, error) {
	// Compute some lengths for convenience
	entropyBitLength := len(entropy) * 8
	checksumBitLength := entropyBitLength / 32
	sentenceLength := (entropyBitLength + checksumBitLength) / 11

	err := validateEntropyBitSize(entropyBitLength)
	if err != nil {
		return "", err
	}

	// Add checksum to entropy
	entropy = addChecksum(entropy)

	// Break entropy up into sentenceLength chunks of 11 bits
	// For each word AND mask the rightmost 11 bits and find the word at that index
	// Then bitshift entropy 11 bits right and repeat
	// Add to the last empty slot so we can work with LSBs instead of MSB

	// Entropy as an int so we can bitmask without worrying about bytes slices
	entropyInt := new(big.Int).SetBytes(entropy)

	// Slice to hold words in
	words := make([]string, sentenceLength)

	// Throw away big int for AND masking
	word := big.NewInt(0)

	for i := sentenceLength - 1; i >= 0; i-- {
		// Get 11 right most bits and bitshift 11 to the right for next time
		word.And(entropyInt, Last11BitsMask)
		entropyInt.Div(entropyInt, RightShift11BitsDivider)

		// Get the bytes representing the 11 bits as a 2 byte slice
		wordBytes := padByteSlice(word.Bytes(), 2)

		// Convert bytes to an index and add that word to the list
		words[i] = bip39.WordList[binary.BigEndian.Uint16(wordBytes)]
	}

	return strings.Join(words, " "), nil
}

// Appends to data the first (len(data) / 32)bits of the result of sha256(data)
// Currently only supports data up to 32 bytes
func addChecksum(data []byte) []byte {
	// Get first byte of sha256
	hasher := sha256.New()
	hasher.Write(data)
	hash := hasher.Sum(nil)
	firstChecksumByte := hash[0]

	// len() is in bytes so we divide by 4
	checksumBitLength := uint(len(data) / 4)

	// For each bit of check sum we want we shift the data one the left
	// and then set the (new) right most bit equal to checksum bit at that index
	// staring from the left
	dataBigInt := new(big.Int).SetBytes(data)
	for i := uint(0); i < checksumBitLength; i++ {
		// Bitshift 1 left
		dataBigInt.Mul(dataBigInt, BigTwo)

		// Set rightmost bit if leftmost checksum bit is set
		if uint8(firstChecksumByte&(1<<(7-i))) > 0 {
			dataBigInt.Or(dataBigInt, BigOne)
		}
	}

	return dataBigInt.Bytes()
}

func padByteSlice(slice []byte, length int) []byte {
	newSlice := make([]byte, length-len(slice))
	return append(newSlice, slice...)
}

func validateEntropyBitSize(bitSize int) error {
	if (bitSize%32) != 0 || bitSize < 128 || bitSize > 256 {
		return errors.New("Entropy length must be [128, 256] and a multiple of 32")
	}
	return nil
}

func GenKeyETHByMnemonic(mnemonic string) {
	if !bip39.IsMnemonicValid(mnemonic) {
		panic("invalid mnemonic")
	}
	privkey, err := derive(mnemonic, "", constants.DefaultHdPath)
	if err != nil {
		panic(err)
	}
	privkeyHex := fmt.Sprintf("%x", privkey)
	fmt.Println("Private key: ", privkeyHex)

	_, pubkeyObject := secp256k1.PrivKeyFromBytes(secp256k1.S256(), privkey)
	pubkey := pubkeyObject.SerializeCompressed()
	if err != nil {
		panic(err)
	}
	fmt.Println("Wallet address: ", pubkey)
}

func GenKeyCosmosByMnemonic(mnemonic, hrp string) {
	if !bip39.IsMnemonicValid(mnemonic) {
		panic("invalid mnemonic")
	}
	privkey, err := derive(mnemonic, "", constants.DefaultHdPath)
	if err != nil {
		panic(err)
	}
	privkeyHex := fmt.Sprintf("%x", privkey)
	fmt.Println("Private key: ", privkeyHex)
	_, pubkeyObject := secp256k1.PrivKeyFromBytes(secp256k1.S256(), privkey)
	pubkey := pubkeyObject.SerializeCompressed()
	bech32Addr, err := bech32Encode(hrp, btcutil.Hash160(pubkey))
	if err != nil {
		panic(err)
	}
	fmt.Println("Wallet address: ", bech32Addr)
}

func derive(mnemonic, bip39Passphrase, hdPath string) ([]byte, error) {
	seed, err := bip39.NewSeedWithErrorChecking(mnemonic, bip39Passphrase)
	if err != nil {
		return nil, err
	}

	masterPriv, chainCode := hd.ComputeMastersFromSeed(seed)
	if len(hdPath) == 0 {
		panic("invalid hdpath")
	}

	derivedKey, err := hd.DerivePrivateKeyForPath(masterPriv, chainCode, hdPath)
	return derivedKey, err
}

// bech32Encode converts from a base64 encoded byte string to base32 encoded byte string and then to bech32.
func bech32Encode(hrp string, data []byte) (string, error) {
	converted, err := bech32.ConvertBits(data, 8, 5, true)
	if err != nil {
		return "", fmt.Errorf("encoding bech32 failed: %w", err)
	}

	return bech32.Encode(hrp, converted)
}
