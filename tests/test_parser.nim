import unittest

include json2codepkg/parser

suite "proc parse":
  setup:
    var nodeId: int
    var node: JsonNode
    let objName = "Obj"

  test "ok: parse simple json":
    node = """{"strval":"hello","intval":1,"floatval":1.2,"boolval":true}""".parseJson
    let got = node.parse(nodeId, objName = objName)
    let want = @[Node(id: 0, name: objName, node: node)]
    check want == got

  test "ok: nested json":
    node = """{"foobar":{"s":"hello","n":1},"b":false}""".parseJson
    let got = node.parse(nodeId, objName = objName)
    let want = @[
      Node(id: 0, name: objName, node: node),
      Node(id: 1, name: "Foobar", node: """{"s":"hello","n":1}""".parseJson),
    ]
    check want == got

  test "ok: nested json 2":
    node = """{"obj1":{"s":"hello","n":1},"obj2":{"f":1.2}}""".parseJson
    let got = node.parse(nodeId, objName = objName)
    let want = @[
      Node(id: 0, name: objName, node: node),
      Node(id: 1, name: "Obj1", node: """{"s":"hello","n":1}""".parseJson),
      Node(id: 2, name: "Obj2", node: """{"f":1.2}""".parseJson),
    ]
    check want == got
