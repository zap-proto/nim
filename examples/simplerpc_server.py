import zap
import simplerpc_zap

class Obj(simplerpc_zap.SimpleRpc.Server):
    def identity(self, a, _context):
        print('identity', a)
        return a

server = zap.TwoPartyServer('127.0.0.1:6789', bootstrap=Obj())
server.run_forever()
