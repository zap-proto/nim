# Package

version       = "0.0.3"
author        = "Michał Zieliński <michal@zielinscy.org.pl>"
description   = "ZAP bindings for Nim"
license       = "MIT"
bin           = @["zap/zapc"]

# Dependencies
#
# The serialization layer (and the `zapc` code generator) builds against
# collections 0.3.4 on Nim 0.18.x — the toolchain era this port targets.
# The git-ref pin is used because the Nim 0.18 nimble predates `==` ranges.
# See TODO.md for the full toolchain matrix and the RPC-layer reactor gap.

requires "nim >= 0.18.0"
requires "https://github.com/zielmicha/collections.nim#v0.3.4"

# `nimble test` verifies the production-ready serialization layer:
# pack/unpack round-trips, single-segment copying, AnyPointer, and the
# zapc compiler binary. These need only `collections`. The RPC tests
# (caprpc/, reactor-backed) are out of scope here — see TODO.md.
task test, "Run the serialization test suite":
  exec "nim c --hints:off --path:. -r tests/test_simple"
  exec "nim c --hints:off --path:. -r tests/test_compress"
  exec "nim c --hints:off --path:. -r tests/test_anypointer"
  exec "nim c --hints:off --path:. -r tests/test_copying"
  exec "nim c --hints:off --path:. zap/zapc"
