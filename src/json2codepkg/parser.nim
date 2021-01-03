## .. code-block:: nim
##
##  import json
##
##  let s = """{"strVal":"hello","intVal":1,"floatVal":1.2,"boolVal":true}"""
##  echo s.parseJson.parse

import tables
import types, util

proc parse*(self: JsonNode, nodeId: var int, objName: string): seq[Node] =
  case self.kind
  of JObject, JArray:
    result.add(Node(id: nodeId, name: objName, node: self))

    case self.kind
    of JObject:
      inc(nodeId)
      for k, v in self.getFields:
        result.add(v.parse(nodeId, objName = k.headUpper))
    of JArray:
      if 0 < self.elems.len():
        let child = self.elems[0]
        inc(nodeId)
        result.add(child.parse(nodeId, objName = objName))
    else: discard
  else: discard

proc parse*(self: JsonNode, objName = "Object"): seq[Node] =
  var nodeId: int
  return self.parse(nodeId, objName = objName)
