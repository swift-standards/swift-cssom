// DashedIdent Tests.swift
// swift-cssom
//
// Tests for CSSOM DashedIdent type (CSS Custom Properties)

import Testing

@testable import W3C_CSSOM

// MARK: - Basic Functionality

@Suite
struct `DashedIdent - Initialization` {
    @Test(arguments: [
        ("primary-color", "--primary-color"),
        ("font-size", "--font-size"),
        ("my-var", "--my-var"),
    ])
    func `dashed ident auto-prefixes with double dash`(value: String, expected: String) {
        let ident = DashedIdent(value)
        #expect(ident.description == expected)
    }

    @Test func `double dash prefix is not duplicated`() {
        let ident = DashedIdent("--already-prefixed")
        #expect(ident.description == "--already-prefixed")
    }

    @Test func `single dash is not treated as prefix`() {
        let ident = DashedIdent("-single-dash")
        #expect(ident.description == "---single-dash")
    }
}

// MARK: - var() Function

@Suite
struct `DashedIdent - var() Helper` {
    @Test func `var without fallback`() {
        let ident = DashedIdent("primary-color")
        #expect(ident.var() == "var(--primary-color)")
    }

    @Test func `var with string fallback`() {
        let ident = DashedIdent("primary-color")
        #expect(ident.var(fallback: "blue") == "var(--primary-color, blue)")
    }

    @Test func `var with numeric fallback`() {
        let ident = DashedIdent("font-size")
        #expect(ident.var(fallback: "16px") == "var(--font-size, 16px)")
    }

    @Test func `var with complex fallback`() {
        let ident = DashedIdent("color")
        #expect(ident.var(fallback: "rgba(0, 0, 0, 0.5)") == "var(--color, rgba(0, 0, 0, 0.5))")
    }

    @Test func `var with empty fallback`() {
        let ident = DashedIdent("test")
        #expect(ident.var(fallback: "") == "var(--test, )")
    }
}

// MARK: - CSS Property Usage

@Suite
struct `DashedIdent - CSS Property Usage` {
    @Test func `custom property declaration`() {
        let declaration = "\(DashedIdent("primary-color")): blue"
        #expect(declaration == "--primary-color: blue")
    }

    @Test func `custom property usage in color`() {
        let color = "color: \(DashedIdent("text-color").var())"
        #expect(color == "color: var(--text-color)")
    }

    @Test func `custom property with fallback in background`() {
        let bg = "background: \(DashedIdent("bg-color").var(fallback: "#fff"))"
        #expect(bg == "background: var(--bg-color, #fff)")
    }
}

// MARK: - Edge Cases

@Suite
struct `DashedIdent - Edge Cases` {
    @Test func `single character after dashes`() {
        let ident = DashedIdent("a")
        #expect(ident.description == "--a")
    }

    @Test func `numbers in name`() {
        let ident = DashedIdent("color123")
        #expect(ident.description == "--color123")
    }

    @Test func `multiple hyphens in name`() {
        let ident = DashedIdent("my-custom-color-value")
        #expect(ident.description == "--my-custom-color-value")
    }

    @Test func `underscores in name`() {
        let ident = DashedIdent("my_custom_var")
        #expect(ident.description == "--my_custom_var")
    }

    @Test func `case sensitive`() {
        let lower = DashedIdent("myvar")
        let upper = DashedIdent("MYVAR")
        #expect(lower.description != upper.description)
        #expect(lower != upper)
    }
}

// MARK: - Protocol Conformance

@Suite
struct `DashedIdent - String Literal Conformance` {
    @Test func `string literal creates dashed ident`() {
        let ident: DashedIdent = "theme-color"
        #expect(ident.description == "--theme-color")
    }
}

@Suite
struct `DashedIdent - Hashable Conformance` {
    @Test func `equal idents are equal`() {
        let ident1 = DashedIdent("test")
        let ident2 = DashedIdent("test")
        #expect(ident1 == ident2)
    }

    @Test func `different idents are not equal`() {
        let ident1 = DashedIdent("test1")
        let ident2 = DashedIdent("test2")
        #expect(ident1 != ident2)
    }

    @Test func `idents can be used in sets`() {
        let set: Set<DashedIdent> = [
            DashedIdent("a"),
            DashedIdent("b"),
            DashedIdent("a"),  // duplicate
        ]
        #expect(set.count == 2)
    }

    @Test func `idents can be used as dictionary keys`() {
        let dict: [DashedIdent: String] = [
            DashedIdent("primary-color"): "#007bff",
            DashedIdent("secondary-color"): "#6c757d",
        ]
        #expect(dict[DashedIdent("primary-color")] == "#007bff")
    }
}

// MARK: - Value Access

@Suite
struct `DashedIdent - Value Property` {
    @Test func `value property returns name without prefix`() {
        let ident = DashedIdent("primary-color")
        #expect(ident.value == "primary-color")
    }

    @Test func `value property for already prefixed`() {
        let ident = DashedIdent("--primary-color")
        #expect(ident.value == "primary-color")
    }
}

// MARK: - Nested var() Usage

@Suite
struct `DashedIdent - Nested var()` {
    @Test func `var with var fallback`() {
        let primary = DashedIdent("primary")
        let fallback = DashedIdent("secondary")
        let result = primary.var(fallback: fallback.var())
        #expect(result == "var(--primary, var(--secondary))")
    }

    @Test func `var with multiple levels`() {
        let first = DashedIdent("first")
        let second = DashedIdent("second")
        let third = DashedIdent("third")
        let result = first.var(fallback: second.var(fallback: third.var(fallback: "default")))
        #expect(result == "var(--first, var(--second, var(--third, default)))")
    }
}

// MARK: - CSSOM Specification

@Suite
struct `DashedIdent - CSS Variables Specification` {
    @Test func `follows css variables naming convention`() {
        // CSS variables must start with --
        let ident = DashedIdent("my-var")
        #expect(ident.description.hasPrefix("--"))
    }

    @Test func `can be used in custom property declaration`() {
        // Custom properties are defined using -- prefix
        let prop = "\(DashedIdent("theme")): value"
        #expect(prop == "--theme: value")
    }

    @Test func `can be used in var function`() {
        // Custom properties are referenced with var()
        let varUsage = DashedIdent("theme").var()
        #expect(varUsage.hasPrefix("var(--"))
        #expect(varUsage.hasSuffix(")"))
    }
}

// MARK: - Performance

extension `Performance Tests` {
    @Suite
    struct `DashedIdent - Performance` {
        @Test(.timeLimit(.minutes(1)))
        func `dashed ident creation 100K times`() {
            for i in 0..<100_000 {
                _ = DashedIdent("var\(i % 100)")
            }
        }

        @Test(.timeLimit(.minutes(1)))
        func `dashed ident description 100K times`() {
            let ident = DashedIdent("theme-color")
            for _ in 0..<100_000 {
                _ = ident.description
            }
        }

        @Test(.timeLimit(.minutes(1)))
        func `var() function 100K times`() {
            let ident = DashedIdent("color")
            for _ in 0..<100_000 {
                _ = ident.var(fallback: "blue")
            }
        }
    }
}
