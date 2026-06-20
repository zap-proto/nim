import booldef, zap/pack, zap/unpack

let p = new(BoolStore)
p.v = true
p.w = true

let packed = packStruct(p)
echo packed.repr

writeFile("bool.bin", packed)
