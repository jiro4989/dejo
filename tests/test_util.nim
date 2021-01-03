import unittest

include json2codepkg/util

suite "proc headUpper":
  test "ok: 'hello'":
    check "hello".headUpper == "Hello"

  test "ok: 'Hello'":
    check "Hello".headUpper == "Hello"

  test "ok: 'h'":
    check "h".headUpper == "H"

  test "ng: returns empty string if string is empty":
    check "".headUpper == ""
