## .. code-block:: nim
##
##  import json
##
##  let s = """{"strVal":"hello","intVal":1,"floatVal":1.2,"boolVal":true}"""
##  echo s.parseJson.parse

import json, tables, strformat, strutils, algorithm

type
  Node* = object
    id*: int
    name*: string
    node*: JsonNode

const
  kindMap* = {
    "nim": {
      JObject: "",
      JArray: "",
      JString: "string",
      JInt: "int64",
      JFloat: "float64",
      JBool: "bool",
    }.toTable
  }.toTable

func headUpper(text: string): string =
  return text[0].toUpperAscii & text[1..^1]

proc parse*(self: JsonNode, nodeId: var int, objName = "Object"): seq[Node] =
  case self.kind
  of JObject, JArray:
    var node: Node
    node.id = nodeId
    node.name = objName
    node.node = self
    result.add(node)

    case self.kind
    of JObject:
      for k, v in self.getFields:
        inc(nodeId)
        result.add(v.parse(nodeId, objName = k.headUpper))
    of JArray:
      if 0 < self.elems.len():
        let child = self.elems[0]
        inc(nodeId)
        result.add(child.parse(nodeId, objName = objName))
    else: discard
  else: discard

func generateNimCode(self: Node): string =
  var lines: seq[string]
  lines.add(&"""  {self.name}* = ref object""")
  for k, v in self.node.getFields:
    let t =
      if v.kind == JObject:
        k.headUpper
      else:
        kindMap["nim"][v.kind]
    lines.add(&"""    {k}*: {t}""")
  return lines.join("\n")

func generateNimCode*(self: seq[Node]): string =
  var lines = @["type"]
  for node in self.sortedByIt(it.id):
    lines.add(node.generateNimCode())
  return lines.join("\n")

var id = 0
echo """
{"strVal":"hello","intVal":1,"floatVal":1.2,"boolVal":true}
""".parseJson.parse(id)

id = 0
echo """
{"strVal":"hello","intVal":1,"floatVal":1.2,"boolVal":true}
""".parseJson.parse(id).generateNimCode

echo "==="

# doAssert """
# {"strVal":"hello","intVal":1,"floatVal":1.2,"boolVal":true}
# """.parseJson.parse(id) == @[Node(fields: {"strVal":JString, "intVal":JInt, "floatVal":JFloat, "boolVal":JBool}.toTable)]

id = 0
echo """
{"person":{"firstName":"taro","lastName":"tanaka"},"age":20}
""".parseJson.parse(id)

id = 0
echo """
{"person":{"firstName":"taro","lastName":"tanaka"},"age":20}
""".parseJson.parse(id).generateNimCode

echo "==="

# id = 0
# doAssert """
# {"obj":{"s":"hello","i":1,"obj":{"b":true}},"s":"world"}
# """.parseJson.parse(id).sortedByIt(it.id) == @[
#   Node(id: 0, fields: {"obj":JObject, "s":JString}.toTable),
#   Node(id: 1, fields: {"s":JString, "i":JInt,"obj":JObject}.toTable),
#   Node(id: 2, fields: {"b":JBool}.toTable),
# ]
# 
# id = 0
# doAssert """
# {"obj1":{"a":1},"obj2":{"b":2}}
# """.parseJson.parse(id).sortedByIt(it.id) == @[
#   Node(id: 0, fields: {"obj1":JObject, "obj2":JObject}.toTable),
#   Node(id: 1, fields: {"a":JInt}.toTable),
#   Node(id: 2, fields: {"b":JInt}.toTable),
# ]

id = 0
echo """
{"arr":[1,2,3],"i":1}
""".parseJson.parse(id)

id = 0
echo """
{"arr":[[1,2,3],[4,5,6],[7,8,9]],"i":1}
""".parseJson.parse(id)

id = 0
echo """
[{"arr":[1,2,3]}]
""".parseJson.parse(id)

when isMainModule and not defined modeTest:
  discard
