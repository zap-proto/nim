import zap, collections
import zap, caprpc/rpcschema, posix, fuzzlib, collections

proc main() =
  let data = stdin.readAll
  if data.len mod 8 != 0:
    quit 0

  let compressed = compressZap(data)
  let v1 = decompressZap(compressed)
  when not defined(fuzz):
    echo compressed.encodeHex
  doAssert(data == v1)

runFuzz()
