package constants

const (
	// the mnemonic entropy bit size, 128 means a 12 words mnemonic
	MnemonicEntropySize int = 128
	// private key size
	PrivKeySize int = 32
	// public key size
	PubKeySize int = 33
	// uses the Bitcoin secp256k1 ECDSA algorithm for the key signing
	KeyAlgorithm string = "secp256k1"
	// the default bip44 path
	DefaultHdPath string = "44'/60'/0'/0/0"
)
