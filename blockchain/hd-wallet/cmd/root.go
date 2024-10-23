package cmd

import (
	"log"

	"github.com/spf13/cobra"
)

var rootCmd = &cobra.Command{
	Use:   "hd-wallet",
	Short: "hd-wallet is used monitor api urls",
	Long:  `hd-wallet is used monitor api urls and some more detail stuff along with it`,
}

func init() {
	rootCmd.AddCommand(checkStatusCmd)
}

func Execute() {
	if err := rootCmd.Execute(); err != nil {
		log.Fatal(err)
	}
}
