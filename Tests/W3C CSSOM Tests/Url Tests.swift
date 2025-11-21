// Url Tests.swift
// swift-cssom
//
// Tests for CSSOM Url type

import Testing
@testable import W3C_CSSOM

// MARK: - Basic Functionality

@Suite
struct `Url - Initialization with Single Quotes` {
    @Test(arguments: [
        ("images/background.png", "url('images/background.png')"),
        ("https://example.com/image.jpg", "url('https://example.com/image.jpg')"),
        ("../assets/logo.svg", "url('../assets/logo.svg')")
    ])
    func `url with single quotes renders correctly`(path: String, expected: String) {
        let url = Url(path, quotes: .single)
        #expect(url.description == expected)
    }
}

@Suite
struct `Url - Initialization with Double Quotes` {
    @Test(arguments: [
        ("images/background.png", "url(\"images/background.png\")"),
        ("https://example.com/image.jpg", "url(\"https://example.com/image.jpg\")"),
        ("../assets/logo.svg", "url(\"../assets/logo.svg\")")
    ])
    func `url with double quotes renders correctly`(path: String, expected: String) {
        let url = Url(path, quotes: .double)
        #expect(url.description == expected)
    }
}

@Suite
struct `Url - Initialization without Quotes` {
    @Test(arguments: [
        ("images/background.png", "url(images/background.png)"),
        ("https://example.com/image.jpg", "url(https://example.com/image.jpg)"),
        ("../assets/logo.svg", "url(../assets/logo.svg)")
    ])
    func `url without quotes renders correctly`(path: String, expected: String) {
        let url = Url(path, quotes: nil)
        #expect(url.description == expected)
    }
}

@Suite
struct `Url - Default Quote Behavior` {
    @Test func `default quotes are single quotes`() {
        let url = Url("images/background.png")
        #expect(url.description == "url('images/background.png')")
    }

    @Test func `explicit single quotes match default`() {
        let defaultUrl = Url("images/background.png")
        let explicitUrl = Url("images/background.png", quotes: .single)
        #expect(defaultUrl.description == explicitUrl.description)
    }
}

// MARK: - Special Characters

@Suite
struct `Url - Single Quote Escaping` {
    // Per CSSOM: quoted URLs only escape newlines, backslashes, and the quote character
    // Spaces and other characters remain literal (no percent-encoding)
    @Test func `spaces remain literal with single quotes`() {
        let url = Url("images/my background.png", quotes: .single)
        #expect(url.description == "url('images/my background.png')")
    }

    @Test func `parentheses remain literal with single quotes`() {
        let url = Url("images/photo(1).jpg", quotes: .single)
        #expect(url.description == "url('images/photo(1).jpg')")
    }

    @Test func `commas remain literal with single quotes`() {
        let url = Url("images/file,name.jpg", quotes: .single)
        #expect(url.description == "url('images/file,name.jpg')")
    }

    @Test func `single quotes are escaped with single quotes`() {
        let url = Url("images/my'photo'.jpg", quotes: .single)
        #expect(url.description == "url('images/my\\'photo\\'.jpg')")
    }
}

@Suite
struct `Url - Double Quote Escaping` {
    // Per CSSOM: quoted URLs only escape newlines, backslashes, and the quote character
    // Spaces and other characters remain literal (no percent-encoding)
    @Test func `spaces remain literal with double quotes`() {
        let url = Url("images/my background.png", quotes: .double)
        #expect(url.description == "url(\"images/my background.png\")")
    }

    @Test func `parentheses remain literal with double quotes`() {
        let url = Url("images/photo(1).jpg", quotes: .double)
        #expect(url.description == "url(\"images/photo(1).jpg\")")
    }

    @Test func `commas remain literal with double quotes`() {
        let url = Url("images/file,name.jpg", quotes: .double)
        #expect(url.description == "url(\"images/file,name.jpg\")")
    }

    @Test func `double quotes are escaped with double quotes`() {
        let url = Url("images/my\"photo\".jpg", quotes: .double)
        #expect(url.description == "url(\"images/my\\\"photo\\\".jpg\")")
    }
}

// MARK: - Data URLs

@Suite
struct `Url - Data URLs` {
    @Test func `data url with default single quotes`() {
        let dataUrl = Url.dataUrl(
            mimeType: "image/png",
            base64Data: "iVBORw0KGgoAAAANSU"
        )
        #expect(dataUrl.description == "url('data:image/png;base64,iVBORw0KGgoAAAANSU')")
    }

    @Test func `data url with double quotes`() {
        let dataUrl = Url.dataUrl(
            mimeType: "image/png",
            base64Data: "iVBORw0KGgoAAAANSU",
            quotes: .double
        )
        #expect(dataUrl.description == "url(\"data:image/png;base64,iVBORw0KGgoAAAANSU\")")
    }

    @Test func `data url without quotes`() {
        let dataUrl = Url.dataUrl(
            mimeType: "image/png",
            base64Data: "iVBORw0KGgoAAAANSU",
            quotes: nil
        )
        #expect(dataUrl.description == "url(data:image/png;base64,iVBORw0KGgoAAAANSU)")
    }

    @Test func `data url with different mime types`() {
        let svgUrl = Url.dataUrl(mimeType: "image/svg+xml", base64Data: "PHN2Zz4=")
        #expect(svgUrl.description == "url('data:image/svg+xml;base64,PHN2Zz4=')")
    }
}

// MARK: - Protocol Conformance

@Suite
struct `Url - String Literal Conformance` {
    @Test func `string literal creates url with default quotes`() {
        let urlLiteral: Url = "images/icon.png"
        #expect(urlLiteral.description == "url('images/icon.png')")
    }
}

@Suite
struct `Url - Hashable Conformance` {
    @Test func `equal urls are equal`() {
        let url1 = Url("image.jpg")
        let url2 = Url("image.jpg")
        #expect(url1 == url2)
    }

    @Test func `different urls are not equal`() {
        let url1 = Url("image.jpg")
        let url2 = Url("different.jpg")
        #expect(url1 != url2)
    }

    @Test func `different quote settings produce different urls`() {
        let singleQuoteUrl = Url("image.jpg", quotes: .single)
        let doubleQuoteUrl = Url("image.jpg", quotes: .double)
        let unquotedUrl = Url("image.jpg", quotes: nil)

        #expect(singleQuoteUrl != doubleQuoteUrl)
        #expect(singleQuoteUrl != unquotedUrl)
        #expect(doubleQuoteUrl != unquotedUrl)
    }
}

// MARK: - Usage in Context

@Suite
struct `Url - CSS Property Usage` {
    @Test func `url renders correctly in background-image property`() {
        let backgroundImage = "background-image: \(Url("pattern.png"))"
        #expect(backgroundImage == "background-image: url('pattern.png')")
    }

    @Test func `url renders correctly in list-style-image property`() {
        let listStyleImage = "list-style-image: \(Url("bullet.svg"))"
        #expect(listStyleImage == "list-style-image: url('bullet.svg')")
    }

    @Test func `url renders correctly in cursor property`() {
        let cursor = "cursor: \(Url("custom.cur"))"
        #expect(cursor == "cursor: url('custom.cur')")
    }

    @Test func `url renders correctly in content property`() {
        let content = "content: \(Url("icon.png"))"
        #expect(content == "content: url('icon.png')")
    }
}

// MARK: - Edge Cases

@Suite
struct `Url - Edge Cases` {
    @Test func `empty path`() {
        let url = Url("")
        #expect(url.description == "url('')")
    }

    @Test func `absolute file path`() {
        let url = Url("/usr/local/share/fonts/font.woff")
        #expect(url.description == "url('/usr/local/share/fonts/font.woff')")
    }

    @Test func `url with query parameters`() {
        let url = Url("https://example.com/image.jpg?size=large&format=webp")
        #expect(url.description.contains("url('https://example.com/image.jpg"))
    }

    @Test func `url with fragment identifier`() {
        let url = Url("sprite.svg#icon")
        #expect(url.description == "url('sprite.svg#icon')")
    }

    @Test func `data url with long base64 string`() {
        let longData = String(repeating: "A", count: 1000)
        let dataUrl = Url.dataUrl(mimeType: "image/png", base64Data: longData)
        #expect(dataUrl.description.contains("data:image/png;base64,"))
        #expect(dataUrl.description.contains(longData))
    }

    @Test func `url with unicode characters`() {
        let url = Url("images/写真.jpg", quotes: .single)
        // Unicode characters should be percent encoded
        #expect(url.description.contains("url('images/"))
    }
}

// MARK: - Performance

extension `Performance Tests` {
    @Suite
    struct `Url - Performance` {
        @Test(.timeLimit(.minutes(1)))
        func `url creation 100K times`() {
            for i in 0..<100_000 {
                _ = Url("image\(i % 100).jpg")
            }
        }

        @Test(.timeLimit(.minutes(1)))
        func `url description generation 100K times`() {
            let url = Url("images/background.png")
            for _ in 0..<100_000 {
                _ = url.description
            }
        }

        @Test(.timeLimit(.minutes(1)))
        func `data url creation 100K times`() {
            for i in 0..<100_000 {
                _ = Url.dataUrl(
                    mimeType: "image/png",
                    base64Data: "data\(i % 100)"
                )
            }
        }
    }
}
