import strutils

func headUpper*(text: string): string =
  ## Returns upper camel case (only prefix 1 character).
  ## Returns an empty string when `text` is an empty string.
  runnableExamples:
    doAssert "hello".headUpper == "Hello"
    doAssert "h".headUpper == "H"
    doAssert "".headUpper == ""

  if text.len < 1: return ""
  return text[0].toUpperAscii & text[1..^1]
