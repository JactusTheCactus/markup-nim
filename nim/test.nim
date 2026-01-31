import std/strformat
import std/strutils
import std/nre
proc replaceFirst(s: string, o: string, n: string): string =
    let idx = s.find o
    if idx == -1: return s
    result = s[0 ..< idx] & n & s[idx + o.len..^1]
type
    NodeKind = enum
        nkText,
        nkBold,
        nkItalic,
        nkUnderline,
        nkHeader,
        nkCode,
        nkCommand
    AstNode = ref object
        kind: NodeKind
        text: string
        children: seq[AstNode]
        level: int
        language: string
        command: string
proc `$`(n: AstNode, i: int = 0): string =
    var indent: string
    for x in 0..<i: indent &= "\t"
    var l: seq[string]
    l.add &"{indent}kind: " & n.kind.repr.replace(re"nk(.+)","$1")
    case n.kind:
        of nkHeader:
            if n.level > 0: l.add &"{indent}level: {n.level}"
        of nkCode:
            if n.language.len > 0: l.add &"{indent}language: {n.language}"
        of nkCommand:
            if n.command.len > 0: l.add &"{indent}command: {n.command}"
        else: discard
    if n.text.len > 0: l.add &"{indent}text: {n.text.repr}"
    if n.children.len > 0:
        var c: string
        for index in 0..<n.children.len:
            let cc = n.children[index]
            if index != 0 and n.children[index].children.len == 0: c &= "\n"
            c &= &"\n{cc.`$`(i + 1)}"
        l.add &"{indent}children:{c}"
    l.join "\n"
func escapePass(i: string): string =
    var o: string
    for c in i:
        case c:
            # of '<': o &= "&lt;"
            # of '>': o &= "&gt;"
            else: o &= c
    return o
proc parseCode(i: string): seq[AstNode] =
    var ii = i
    let r = re"<-(!?)(\w+)>\{([\s\S]*?)\}"
    var nodes: seq[AstNode]
    while ii.find(r).isSome:
        let f = ii.find r
        let node = AstNode(
            kind: nkCode,
            text: f.get.captures[2],
            language: f.get.captures[1]
        )
        nodes.add node
        ii = ii.replaceFirst(f.get.match, "")
    return nodes
proc parse(i: string): seq[AstNode] =
    return i
        .escapePass
        .parseCode
        # .parseHeader
        # .parseCommands
        # .parseInline
        # .restoreEscapes
echo AstNode(children: @[
    AstNode(children: @[
        AstNode(children: @[
            AstNode(children: @[AstNode(), AstNode()]),
            AstNode(children: @[AstNode(), AstNode()])
        ]),
        AstNode(children: @[
            AstNode(children: @[AstNode(), AstNode()]),
            AstNode(children: @[AstNode(), AstNode()])
        ])
    ]),
    AstNode(children: @[
        AstNode(children: @[
            AstNode(children: @[AstNode(), AstNode()]),
            AstNode(children: @[AstNode(), AstNode()])
        ]),
        AstNode(children: @[
            AstNode(children: @[AstNode(), AstNode()]),
            AstNode(children: @[AstNode(), AstNode()])
        ])
    ])
])
# echo "<-js>{console.log(\"Hello, World!\");}<-py>{print(\"Hello, World!\")}".parse
# proc render(node: AstNode): string =
    # case node.kind
        # of nkBold: &"<b>{renderChildren(node)}</b>"
        # of nkItalic: &"<i>{renderChildren(node)}</i>"
        # of nkUnderline: &"<u>{renderChildren(node)}</u>"
        # of nkHeader: &"<h{$node.level}>{node.text}</h{$node.level}>"
        # of nkCode: &"<code class=\"lang-{node.language}\">{escapeHtml(node.text)}</code>"
        # else: node.text
