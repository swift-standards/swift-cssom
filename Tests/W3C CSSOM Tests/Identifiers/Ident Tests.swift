// Ident Tests.swift
// swift-cssom
//
// Tests for CSSOM Ident type (Base identifier)

import Testing

@testable import W3C_CSSOM

// MARK: - Basic Functionality

@Suite
struct `Ident - Initialization` {
    @Test(arguments: [
        ("test", "test"),
        ("my-ident", "my-ident"),
        ("_private", "_private"),
        ("value123", "value123"),
    ])
    func `ident renders correctly`(value: String, expected: String) {
        let ident = Ident(value)
        #expect(ident.description == expected)
    }
}

// MARK: - CSS Property Usage

@Suite
struct `Ident - CSS Property Usage` {
    @Test func `ident in property value`() {
        let value = "display: \(Ident("block"))"
        #expect(value == "display: block")
    }

    @Test func `ident in keyword value`() {
        let value = "position: \(Ident("absolute"))"
        #expect(value == "position: absolute")
    }

    @Test func `ident as enum value`() {
        let value = "text-align: \(Ident("center"))"
        #expect(value == "text-align: center")
    }
}

// MARK: - Edge Cases

@Suite
struct `Ident - Edge Cases` {
    @Test func `single character ident`() {
        let ident = Ident("a")
        #expect(ident.description == "a")
    }

    @Test func `ident with numbers`() {
        let ident = Ident("test123")
        #expect(ident.description == "test123")
    }

    @Test func `ident with hyphens`() {
        let ident = Ident("my-ident-value")
        #expect(ident.description == "my-ident-value")
    }

    @Test func `ident with underscores`() {
        let ident = Ident("my_ident_value")
        #expect(ident.description == "my_ident_value")
    }

    @Test func `case sensitive`() {
        let lower = Ident("test")
        let upper = Ident("TEST")
        #expect(lower.description != upper.description)
        #expect(lower != upper)
    }
}

// MARK: - Protocol Conformance

@Suite
struct `Ident - String Literal Conformance` {
    @Test func `string literal creates ident`() {
        let ident: Ident = "my-ident"
        #expect(ident.description == "my-ident")
    }
}

@Suite
struct `Ident - Hashable Conformance` {
    @Test func `equal idents are equal`() {
        let ident1 = Ident("test")
        let ident2 = Ident("test")
        #expect(ident1 == ident2)
    }

    @Test func `different idents are not equal`() {
        let ident1 = Ident("test1")
        let ident2 = Ident("test2")
        #expect(ident1 != ident2)
    }

    @Test func `idents can be used in sets`() {
        let set: Set<Ident> = [
            Ident("a"),
            Ident("b"),
            Ident("a"),  // duplicate
        ]
        #expect(set.count == 2)
    }

    @Test func `idents can be used as dictionary keys`() {
        let dict: [Ident: String] = [
            Ident("display"): "block",
            Ident("position"): "absolute",
        ]
        #expect(dict[Ident("display")] == "block")
    }
}

// MARK: - Value Access

@Suite
struct `Ident - Value Property` {
    @Test func `value property returns raw value`() {
        let ident = Ident("my-ident")
        #expect(ident.value == "my-ident")
    }
}

// MARK: - Common CSS Keywords

@Suite
struct `Ident - Common CSS Keywords` {
    @Test func `display values`() {
        #expect(Ident("block").description == "block")
        #expect(Ident("inline").description == "inline")
        #expect(Ident("flex").description == "flex")
        #expect(Ident("grid").description == "grid")
        #expect(Ident("none").description == "none")
    }

    @Test func `position values`() {
        #expect(Ident("static").description == "static")
        #expect(Ident("relative").description == "relative")
        #expect(Ident("absolute").description == "absolute")
        #expect(Ident("fixed").description == "fixed")
        #expect(Ident("sticky").description == "sticky")
    }

    @Test func `text-align values`() {
        #expect(Ident("left").description == "left")
        #expect(Ident("right").description == "right")
        #expect(Ident("center").description == "center")
        #expect(Ident("justify").description == "justify")
    }

    @Test func `overflow values`() {
        #expect(Ident("visible").description == "visible")
        #expect(Ident("hidden").description == "hidden")
        #expect(Ident("scroll").description == "scroll")
        #expect(Ident("auto").description == "auto")
    }
}

// MARK: - CSSOM Specification

@Suite
struct `Ident - CSSOM Specification` {
    @Test func `follows identifier syntax`() {
        // CSS identifiers are case-sensitive sequences of characters
        let ident = Ident("myIdent")
        #expect(ident.description == "myIdent")
    }

    @Test func `preserves case`() {
        // CSS is case-sensitive for identifiers
        let lower = Ident("value")
        let upper = Ident("VALUE")
        let mixed = Ident("Value")

        #expect(lower.description == "value")
        #expect(upper.description == "VALUE")
        #expect(mixed.description == "Value")
    }
}

// MARK: - Performance

extension `Performance Tests` {
    @Suite
    struct `Ident - Performance` {
        @Test(.timeLimit(.minutes(1)))
        func `ident creation 100K times`() {
            for i in 0..<100_000 {
                _ = Ident("ident\(i % 100)")
            }
        }

        @Test(.timeLimit(.minutes(1)))
        func `ident description 100K times`() {
            let ident = Ident("block")
            for _ in 0..<100_000 {
                _ = ident.description
            }
        }

        @Test(.timeLimit(.minutes(1)))
        func `ident comparison 100K times`() {
            let ident1 = Ident("test")
            let ident2 = Ident("test")
            for _ in 0..<100_000 {
                _ = ident1 == ident2
            }
        }
    }
}
