import std/nre
import std/strformat
import std/strutils
import std/sugar
import std/sequtils
var text = @[
    "*bold*",
    "/italic/",
    "_underlined_"
].join "\n"
echo text
proc format(r: Regex, h: string): void =
    while text.find(r).isSome:
        let f = text.find r
        text = text.replace(f.get.match, &"<{h}>{f.get.captures[0]}</{h}>")
format re"\*(?!\s)([^*\n]+?)(?<!\s)\*", "b"
format re"/(?!\s)([^*\n]+?)(?<!\s)/", "i"
format re"_(?!\s)([^*\n]+?)(?<!\s)_", "u"
echo text
