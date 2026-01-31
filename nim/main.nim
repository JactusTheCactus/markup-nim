import std/nre
import std/strformat
import std/strutils
import std/sugar
import std/sequtils
proc stringify(x: string): string =
    return &"This text is {x}.\n"
var text = [
    "*bold*",
    "/italic/",
    "_underlined_"
].toSeq.map(stringify).join
echo text
proc format(r: Regex, h: string): void =
    while text.find(r).isSome:
        let f = text.find r
        let match = f.get.match
        let html = &"<{h}>{f.get.captures[0]}</{h}>"
        text = text.replace(match, html)
format(re"\*(?!\s)([^*\n]+?)(?<!\s)\*", "b")
format(re"/(?!\s)([^*\n]+?)(?<!\s)/", "i")
format(re"_(?!\s)([^*\n]+?)(?<!\s)_", "u")
echo text
