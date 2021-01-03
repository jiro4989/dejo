## .. code-block:: nim
##
##  import json
##
##  let s = """{"strVal":"hello","intVal":1,"floatVal":1.2,"boolVal":true}"""
##  echo s.parseJson.parse

import tables, sets
import types, util

proc parse*(self: JsonNode, nodeId: var int, typeNames: var HashSet[string], objName: string): seq[Node] =
  case self.kind
  of JObject, JArray:
    # Set suffix when same name type has been defined.
    var objName = objName
    if typeNames.contains(objName):
      # TODO: increments suffix number
      objName = objName & "_1"

    typeNames.incl(objName)
    result.add(Node(id: nodeId, name: objName, node: self))

    case self.kind
    of JObject:
      inc(nodeId)
      for k, v in self.getFields:
        result.add(v.parse(nodeId, typeNames, objName = k.headUpper))
    of JArray:
      if 0 < self.elems.len():
        let child = self.elems[0]
        inc(nodeId)
        result.add(child.parse(nodeId, typeNames, objName = objName))
    else: discard
  else: discard

proc parse*(self: JsonNode, objName = "Object"): seq[Node] =
  var nodeId: int
  var typeNames: HashSet[string]
  return self.parse(nodeId, typeNames, objName = objName)
