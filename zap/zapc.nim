import zap, zap/compiler, zap/schema

when isMainModule:
  let data = readAll(stdin)
  let req = newUnpacker(data).unpackPointer(0, CodeGeneratorRequest)

  generateCode(req)
