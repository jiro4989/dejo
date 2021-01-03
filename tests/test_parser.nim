import unittest

include dejopkg/parser

suite "proc parse":
  setup:
    var node: JsonNode
    let objName = "Obj"

  test "ok: parse simple json":
    node = """{"strval":"hello","intval":1,"floatval":1.2,"boolval":true}""".parseJson
    let got = node.parse(objName = objName)
    let want = @[Node(id: 0, name: objName, node: node)]
    check want == got

  test "ok: nested json":
    node = """{"foobar":{"s":"hello","n":1},"b":false}""".parseJson
    let got = node.parse(objName = objName)
    let want = @[
      Node(id: 0, name: objName, node: node),
      Node(id: 1, name: "Foobar", node: """{"s":"hello","n":1}""".parseJson),
    ]
    check want == got

  test "ok: nested json 2":
    node = """{"obj1":{"s":"hello","n":1},"obj2":{"f":1.2}}""".parseJson
    let got = node.parse(objName = objName)
    let want = @[
      Node(id: 0, name: objName, node: node),
      Node(id: 1, name: "Obj1", node: """{"s":"hello","n":1}""".parseJson),
      Node(id: 2, name: "Obj2", node: """{"f":1.2}""".parseJson),
    ]
    check want == got

  test "ok: array":
    node = """{"obj1":{"arr":[1,2,3]},"obj2":{"f":1.2}}""".parseJson
    let got = node.parse(objName = objName)
    let want = @[
      Node(id: 0, name: objName, node: node),
      Node(id: 1, name: "Obj1", node: """{"arr":[1,2,3]}""".parseJson),
      Node(id: 2, name: "Arr", node: """[1,2,3]""".parseJson),
      Node(id: 3, name: "Obj2", node: """{"f":1.2}""".parseJson),
    ]
    check want == got

  test "ok: multi dimentional array":
    node = """{"obj1":{"arr":[[1,2,3],[4,5,6],[7,8,9]]},"obj2":{"f":1.2}}""".parseJson
    let got = node.parse(objName = objName)
    let want = @[
      Node(id: 0, name: objName, node: node),
      Node(id: 1, name: "Obj1", node: """{"arr":[[1,2,3],[4,5,6],[7,8,9]]}""".parseJson),
      Node(id: 2, name: "Arr", node: """[[1,2,3],[4,5,6],[7,8,9]]""".parseJson),
      Node(id: 3, name: "Arr_1", node: """[1,2,3]""".parseJson),
      Node(id: 4, name: "Obj2", node: """{"f":1.2}""".parseJson),
    ]
    check want == got
