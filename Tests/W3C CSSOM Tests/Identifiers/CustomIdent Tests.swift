// CustomIdent Tests.swift
// swift-cssom
//
// Tests for CSSOM CustomIdent type

import Testing

@testable import W3C_CSSOM

// MARK: - Basic Functionality

@Suite
struct `CustomIdent - Initialization` {
    @Test(arguments: [
        ("my-animation", "my-animation"),
        ("slideIn", "slideIn"),
        ("header-main", "header-main"),
        ("_private", "_private"),
    ])
    func `custom ident renders correctly`(value: String, expected: String) {
        let ident = CustomIdent(value)
        #expect(ident.description == expected)
    }
}

@Suite
struct `CustomIdent - CSS Property Usage` {
    @Test func `custom ident in animation-name`() {
        let animationName = "animation-name: \(CustomIdent("slideIn"))"
        #expect(animationName == "animation-name: slideIn")
    }

    @Test func `custom ident in grid-area`() {
        let gridArea = "grid-area: \(CustomIdent("header"))"
        #expect(gridArea == "grid-area: header")
    }

    @Test func `custom ident in list-style-type`() {
        let listStyle = "list-style-type: \(CustomIdent("custom-counter"))"
        #expect(listStyle == "list-style-type: custom-counter")
    }
}

// MARK: - Edge Cases

@Suite
struct `CustomIdent - Edge Cases` {
    @Test func `single character ident`() {
        let ident = CustomIdent("a")
        #expect(ident.description == "a")
    }

    @Test func `ident with numbers`() {
        let ident = CustomIdent("item123")
        #expect(ident.description == "item123")
    }

    @Test func `ident with hyphens`() {
        let ident = CustomIdent("my-custom-ident")
        #expect(ident.description == "my-custom-ident")
    }

    @Test func `ident with underscores`() {
        let ident = CustomIdent("my_custom_ident")
        #expect(ident.description == "my_custom_ident")
    }

    @Test func `case sensitive`() {
        let lower = CustomIdent("test")
        let upper = CustomIdent("TEST")
        #expect(lower.description != upper.description)
        #expect(lower != upper)
    }
}

// MARK: - Protocol Conformance

@Suite
struct `CustomIdent - String Literal Conformance` {
    @Test func `string literal creates custom ident`() {
        let ident: CustomIdent = "my-ident"
        #expect(ident.description == "my-ident")
    }
}

@Suite
struct `CustomIdent - Hashable Conformance` {
    @Test func `equal idents are equal`() {
        let ident1 = CustomIdent("test")
        let ident2 = CustomIdent("test")
        #expect(ident1 == ident2)
    }

    @Test func `different idents are not equal`() {
        let ident1 = CustomIdent("test1")
        let ident2 = CustomIdent("test2")
        #expect(ident1 != ident2)
    }

    @Test func `idents can be used in sets`() {
        let set: Set<CustomIdent> = [
            CustomIdent("a"),
            CustomIdent("b"),
            CustomIdent("a"),  // duplicate
        ]
        #expect(set.count == 2)
    }

    @Test func `idents can be used as dictionary keys`() {
        let dict: [CustomIdent: String] = [
            CustomIdent("header"): "Header content",
            CustomIdent("footer"): "Footer content",
        ]
        #expect(dict[CustomIdent("header")] == "Header content")
    }
}

// MARK: - Value Access

@Suite
struct `CustomIdent - Value Property` {
    @Test func `value property returns raw value`() {
        let ident = CustomIdent("my-ident")
        #expect(ident.value == "my-ident")
    }
}

// MARK: - Performance

extension `Performance Tests` {
    @Suite
    struct `CustomIdent - Performance` {
        @Test(.timeLimit(.minutes(1)))
        func `custom ident creation 100K times`() {
            for i in 0..<100_000 {
                _ = CustomIdent("ident\(i % 100)")
            }
        }

        @Test(.timeLimit(.minutes(1)))
        func `custom ident description 100K times`() {
            let ident = CustomIdent("my-animation")
            for _ in 0..<100_000 {
                _ = ident.description
            }
        }
    }
}
