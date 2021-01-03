import tables, strformat, strutils, algorithm
import types, util

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
