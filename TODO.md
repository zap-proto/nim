# Known limitations

zap.nim is a complete Nim implementation of the ZAP serialization scheme; the
RPC layer is useful but does not cover the whole protocol. The serialization
layer is production ready. The items below are the parts of the upstream wire
and code generator that are intentionally not yet implemented. They are scoped
here precisely (with source anchors) rather than left as inline placeholders.

## Serialization (`zap/`)

- Two-word (intersegment / far) pointers are not decoded.
  `zap/unpack.nim` raises `ZapFormatError "two-word pointers not implemented"`
  on encounter, and `getPointerField` raises on an intersegment target.
  Single-segment messages — the form produced by this library's packer — are
  fully supported; cross-segment far pointers from other encoders are rejected
  explicitly rather than misread.

## Code generator (`zap/compiler.nim`)

- Unions nested inside a group are not emitted.
- Named unions are not emitted.

## RPC (`caprpc/`)

- Interface inheritance (superclasses) is not generated; `compiler.nim`
  walks methods of the declared interface only.

The ZAP schema text front-end (brace and whitespace-significant `.zap` syntax)
is not part of this repository: `zap/zapc` is a code-generation backend that
reads a binary `CodeGeneratorRequest` on stdin (`zap/zapc.nim`) emitted by the
shared ZAP schema compiler. Whitespace/brace handling and desugaring live in
that compiler, not here.
