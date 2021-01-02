## .. code-block:: nim
##
##  import json
##
##  let s = """{"strVal":"hello","intVal":1,"floatVal":1.2,"boolVal":true}"""
##  echo s.parseJson.parse

import json, tables

type
  Node* = object
    id*: int
    fields*: Table[string, JsonNodeKind]

proc parse*(self: JsonNode, nodeId: var int, objName = "Object", publicField = false): seq[Node] =
  # フィールドを公開するときに指定する文字列
  var node: Node
  node.id = nodeId
  case self.kind
  of JObject:
    for k, v in self.getFields:
      node.fields[k] = v.kind
      case v.kind
      of JObject:
        inc(nodeId)
        result.add(v.parse(nodeId))
      else: discard
    result.add(node)
  of JArray:
    # let seqObjName = &"Seq{objName.headUpper()}"
    # if 0 < self.elems.len():
    #   let child = self.elems[0]
    #   case child.kind
    #   of JObject:
    #     var ret: seq[string]
    #     child.objFormat(objName, ret, publicStr = publicStr)
    #   else:
    #     var strs: seq[string]
    #     let t = getType(objName, child, strs, 0, publicStr)
    discard
  else: discard

import algorithm

var id = 0
doAssert """
{"strVal":"hello","intVal":1,"floatVal":1.2,"boolVal":true}
""".parseJson.parse(id) == @[Node(fields: {"strVal":JString, "intVal":JInt, "floatVal":JFloat, "boolVal":JBool}.toTable)]

id = 0
doAssert """
{"obj":{"s":"hello","i":1},"s":"world"}
""".parseJson.parse(id).sortedByIt(it.id) == @[
  Node(id: 0, fields: {"obj":JObject, "s":JString}.toTable),
  Node(id: 1, fields: {"s":JString, "i":JInt}.toTable),
]

id = 0
doAssert """
{"obj":{"s":"hello","i":1,"obj":{"b":true}},"s":"world"}
""".parseJson.parse(id).sortedByIt(it.id) == @[
  Node(id: 0, fields: {"obj":JObject, "s":JString}.toTable),
  Node(id: 1, fields: {"s":JString, "i":JInt,"obj":JObject}.toTable),
  Node(id: 2, fields: {"b":JBool}.toTable),
]

id = 0
doAssert """
{"obj1":{"a":1},"obj2":{"b":2}}
""".parseJson.parse(id).sortedByIt(it.id) == @[
  Node(id: 0, fields: {"obj1":JObject, "obj2":JObject}.toTable),
  Node(id: 1, fields: {"a":JInt}.toTable),
  Node(id: 2, fields: {"b":JInt}.toTable),
]

when isMainModule and not defined modeTest:
  discard
