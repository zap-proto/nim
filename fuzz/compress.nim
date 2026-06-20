import zap

let data = stdin.readAll
let v = decompressZap(data)
let compressed = compressZap(v)
let v1 = decompressZap(compressed)
doAssert(v == v1)
