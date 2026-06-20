import zap/util, zap/unpack, zap/pack, zap/gensupport
type
  BoolStore* = ref object
    v*: bool
    w*: bool



makeStructCoders(BoolStore, [], [], [
  (v, 0, true, true),
  (w, 1, true, true)
  ])


