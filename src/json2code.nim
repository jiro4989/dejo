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
    dependsNodeId: int

var
  autoIncrementNodeId = 0

proc parse*(self: JsonNode, objName = "Object", publicField = false): Node =
  # フィールドを公開するときに指定する文字列
  result.id = autoIncrementNodeId
  case self.kind
  of JObject:
    for k, v in self.getFields:
      case v.kind
      of JObject:
        discard # TODO
      else:
        result.fields[k] = v.kind
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

doAssert """{"strVal":"hello","intVal":1,"floatVal":1.2,"boolVal":true}""".parseJson.parse == Node(fields: {"strVal":JString, "intVal":JInt, "floatVal":JFloat, "boolVal":JBool}.toTable)

when isMainModule and not defined modeTest:
  discard
