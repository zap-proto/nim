import zap, zap/gensupport, collections/iface

# file: examples/nested.zap
from examples/calculator_schema import nil

type
  CalculatorHolder* = ref object
    item*: calculator_schema.Calculator



makeStructCoders(CalculatorHolder, [], [
  (item, 0, PointerFlag.none, true)
  ], [])


