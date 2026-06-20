# zap.nim

> **Docs:** [ZAP Nim SDK](https://zap-proto.dev/docs/sdks) · part of the [ZAP Protocol](https://zap-proto.io)

ZAP bindings for Nim

**WARNING: the project is not actively maintained**

zap.nim is a Nim implementation of ZAP serialization scheme and RPC protocol.

The serialization layer is production ready. The RPC layers is also fairly well tested, enough to be useful, but not the whole protocol is implemented.

The main user of this library is [MetaContainer](https://github.com/zielmicha/metac).

## Installing

Use [nimble](https://github.com/nim-lang/nimble) to install `zap.nim`:

```
nimble install zap
```

Create symlink to `zapc` binary result (zap compiler expects `zapc-nim` binary,
but Nimble is unable to produce binary name that contains `-`):

```
ln -s ~/.nimble/bin/zapc ~/.nimble/bin/zapc-nim
```

## Generating wrapping code

zap.nim can generate Nim types (with some metadata) from `.zap` file. The resulting objects use native Nim datatypes like seq or strings (this means that this implementation, unlike C++ one, doesn't have O(1) deserialization time). 

```
zap compile -onim your-protocol-file.zap > you-output-file.nim
```

## Using the library 

```
import persondef, zap
# unpack the raw serialized data
let p: Person = newUnpackerFlat(packed).unpackStruct(0, Person)
# and pack again
let packed2 = packStruct(p)
```

### Debugging options

Define the following symbols during compilation (e.g `-d:caprpcTraceMessages`):

  * `caprpcTraceMessages` - print all messages sent by RPC system
  * `caprpcTraceLifetime` - print info about `release` messages, useful while debugging cross-machine leaks
  * `caprpcPrintExceptions` - print exceptions raised inside called methods (server)