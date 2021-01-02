import strutils

func headUpper*(text: string): string =
  return text[0].toUpperAscii & text[1..^1]
