# Known limitations

zap.nim is a complete Nim implementation of the ZAP serialization scheme; the
RPC layer is useful but does not cover the whole protocol. The serialization
layer is production ready. The items below are the parts of the upstream wire
and code generator that are intentionally not yet implemented. They are scoped
here precisely (with source anchors) rather than left as inline placeholders.

## Toolchain

This port targets the **Nim 0.18.x** compiler era. `build.sh`/`nimenv.cfg`
originally pinned Nim 0.15.2 with exact 2017 dependency commits; the closest
toolchain that is still buildable and runnable on current CI is Nim 0.18.0,
against which CI and `nimble test` are verified green.

The serialization layer (and the `zapc` code generator) builds against
`collections == 0.3.4` and needs nothing else. `zap.nimble` pins that version
by git ref (the 0.18 nimble predates `==` version ranges) and `nimble test`
runs the round-trip suite plus a `zapc` compile. CI runs inside the official
`nimlang/nim:0.18.0` image so the environment is deterministic.

Newer Nim breaks the dependency closure, not this repository's code:

- Nim >= 2.0 rejects `collections/iface.nim` — `object {.inheritable.}`
  (the pragma-after-`object` form was removed in Nim 2.0).
- Nim >= 0.19 rejects `collections/iface.nim` — `newIdentNode(!"…")`
  (`!`/`toNimIdent` was removed in Nim 0.19).

These are upstream dependency limitations (zielmicha/collections,
zielmicha/reactor), not ZAP serialization defects.

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
- The RPC layer is **not covered by CI** and is not built by `nimble test`.
  It depends on `zielmicha/reactor` (a libuv async engine), which is caught
  in a version vise against the Nim 0.18.x toolchain:
  - reactor's Future/Result compat shim that `caprpc/common.nim:41`
    (`proc(x: R): Future[T] = catchError(castAs(x, T))`) relies on lives in
    the 2017 reactor commit the original `build.sh` pinned (`b1875cd`), but
    that commit's `reactor/ipaddress.nim` no longer compiles on Nim 0.18
    (an `Ip4Address` array-type change).
  - The reactor 0.4.x tags that do compile on Nim 0.18 changed
    `catchError` to return `Result[T]` without the implicit `Future[T]`
    conversion, so `caprpc/common.nim:41` fails to type-check.
  Restoring RPC CI requires either a reactor build that satisfies both
  constraints on a runnable Nim, or porting the `caprpc/` async glue to a
  modern reactor. Scoped here rather than shipped as a red CI badge.

The ZAP schema text front-end (brace and whitespace-significant `.zap` syntax)
is not part of this repository: `zap/zapc` is a code-generation backend that
reads a binary `CodeGeneratorRequest` on stdin (`zap/zapc.nim`) emitted by the
shared ZAP schema compiler. Whitespace/brace handling and desugaring live in
that compiler, not here.
