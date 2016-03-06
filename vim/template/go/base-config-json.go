package main

import (
	"encoding/json"
	"fmt"
	"log"
	"os"
)

type config struct {
	Hoge string `json:"hoge"`
	Fuga string `json:"fuga"`
}

func main() {
	f, err := os.Open(os.ExpandEnv("$HOME/.config/foobar/config.json"))
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()
	var cfg config
	err = json.NewDecoder(f).Decode(&cfg)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println(cfg.Hoge)
	fmt.Println(cfg.Fuga)
}
