#!/bin/env bash
#https://github.com/Jigsaw-Code/outline-sdk

port_8080() {
# port=8080
go run github.com/Jigsaw-Code/outline-sdk/x/examples/http2transport@latest -transport "${outline_key}" -localAddr localhost:8080
}

port_1080() {
# port=1080
go run github.com/Jigsaw-Code/outline-sdk/x/examples/http2transport@latest -transport "${outline_key}"
}

transport() {
# port=1080
./http2transport -transport "${outline_key}"
}

cd ~/my_programs/outline-sdk
source outline.key
transport &

