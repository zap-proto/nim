#!/bin/bash
set -e
nim c zap/zapc
zap compile -onim caprpc/rpc.zap > caprpc/rpcschema.nim
zap compile -onim caprpc/rpc-twoparty.zap > caprpc/twopartyschema.nim
zap compile -onim examples/calculator.zap > examples/calculator_schema.nim
zap compile -onim examples/simplerpc.zap > examples/simplerpc_schema.nim
zap compile -onim examples/nested.zap > examples/nested_schema.nim
zap compile -onim examples/person.zap > examples/persondef.nim
