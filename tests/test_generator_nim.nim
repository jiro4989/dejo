import unittest

include dejopkg/[parser, generator_nim]

suite "proc generateNimCode":
  setup:
    var node: JsonNode
    let objName = "Obj"

  test "ok: generate simple json":
    node = """{"strval":"hello","intval":1,"floatval":1.2,"boolval":true}""".parseJson
    let got = node.parse(objName = objName).generateNimCode
    let want = """type
  Obj* = ref object
    strval*: string
    intval*: int64
    floatval*: float64
    boolval*: bool"""
    check want == got

  test "ok: nested json":
    node = """{"obj1":{"s":"hello","n":1},"obj2":{"f":1.2}}""".parseJson
    let got = node.parse(objName = objName).generateNimCode
    let want = """type
  Obj* = ref object
    obj1*: Obj1
    obj2*: Obj2
  Obj1* = ref object
    s*: string
    n*: int64
  Obj2* = ref object
    f*: float64"""
    check want == got

