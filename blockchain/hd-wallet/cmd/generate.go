package cmd

import (
	"fmt"

	"github.com/quankori/go-hd-wallet/internals/bip39"
	"github.com/quankori/go-hd-wallet/pkg/accounts"
	log "github.com/sirupsen/logrus"
	"github.com/spf13/cobra"
)

var checkStatusCmd = &cobra.Command{
	Use:   "generate-wallet",
	Short: "generate-wallet for mnemonic key",
	Long:  `generate-wallet for mnemonic key`,
	Run: func(cmd *cobra.Command, args []string) {
		entropy, err := bip39.NewEntropy(128)
		if err != nil {
			log.Fatal(err)
		}
		mnemonic, err := accounts.NewMnemonic(entropy)
		if err != nil {
			log.Fatal(err)
		}
		fmt.Println("Mnemonic: ", mnemonic)
		accounts.GenKeyETHByMnemonic(mnemonic)
	},
}
