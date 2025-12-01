// Url Tests.swift
// swift-cssom
//
// Tests for CSSOM Url type

import Testing

@testable import W3C_CSSOM

// MARK: - Basic Functionality

@Suite
struct `Url - CSSOM Serialization` {
    // Per CSSOM spec: URLs are serialized as url(<string>) where <string>
    // uses the same serialization rules as CSS strings (always double quotes)
    @Test(arguments: [
        ("images/background.png", "url(\"images/background.png\")"),
        ("https://example.com/image.jpg", "url(\"https://example.com/image.jpg\")"),
        ("../assets/logo.svg", "url(\"../assets/logo.svg\")"),
        ("/absolute/path.png", "url(\"/absolute/path.png\")"),
    ])
    func `url renders correctly`(path: String, expected: String) {
        let url = Url(path)
        #expect(url.description == expected)
    }
}

// MARK: - Special Characters and Escaping

@Suite
struct `Url - Character Escaping` {
    // Per CSSOM: URLs use string serialization which escapes:
    // - NULL -> U+FFFD
    // - Control characters (U+0001-U+001F, U+007F) -> \<hex><space>
    // - Double quotes -> \"
    // - Backslashes -> \\

    @Test func `spaces remain literal`() {
        let url = Url("images/my background.png")
        #expect(url.description == "url(\"images/my background.png\")")
    }

    @Test func `parentheses remain literal`() {
        let url = Url("images/photo(1).jpg")
        #expect(url.description == "url(\"images/photo(1).jpg\")")
    }

    @Test func `commas remain literal`() {
        let url = Url("images/file,name.jpg")
        #expect(url.description == "url(\"images/file,name.jpg\")")
    }

    @Test func `single quotes remain literal`() {
        // Single quotes don't need escaping in double-quoted strings
        let url = Url("images/my'photo'.jpg")
        #expect(url.description == "url(\"images/my'photo'.jpg\")")
    }

    @Test func `double quotes are escaped`() {
        let url = Url("images/my\"photo\".jpg")
        #expect(url.description == "url(\"images/my\\\"photo\\\".jpg\")")
    }

    @Test func `backslashes are escaped`() {
        let url = Url("C:\\Users\\file.jpg")
        #expect(url.description == "url(\"C:\\\\Users\\\\file.jpg\")")
    }

    @Test func `newlines are escaped as code points`() {
        let url = Url("path\nwith\nnewlines")
        // Newlines (U+000A) are control characters, escaped as \a
        #expect(url.description == "url(\"path\\a with\\a newlines\")")
    }
}

// MARK: - Edge Cases

@Suite
struct `Url - Edge Cases` {
    @Test func `empty path`() {
        let url = Url("")
        #expect(url.description == "url(\"\")")
    }

    @Test func `url with query parameters`() {
        let url = Url("https://example.com/api?param1=value1&param2=value2")
        #expect(url.description == "url(\"https://example.com/api?param1=value1&param2=value2\")")
    }

    @Test func `url with fragment identifier`() {
        let url = Url("page.html#section")
        #expect(url.description == "url(\"page.html#section\")")
    }

    @Test func `absolute file path`() {
        let url = Url("/Users/username/images/photo.jpg")
        #expect(url.description == "url(\"/Users/username/images/photo.jpg\")")
    }

    @Test func `url with unicode characters`() {
        let url = Url("images/文件.jpg")
        #expect(url.description == "url(\"images/文件.jpg\")")
    }
}

// MARK: - Data URLs

@Suite
struct `Url - Data URLs` {
    @Test func `data url with default quotes`() {
        let url = Url.dataUrl(mimeType: "image/png", base64Data: "iVBORw0KGgo=")
        #expect(url.description == "url(\"data:image/png;base64,iVBORw0KGgo=\")")
    }

    @Test func `data url with different mime types`() {
        let pngUrl = Url.dataUrl(mimeType: "image/png", base64Data: "ABC")
        let jpegUrl = Url.dataUrl(mimeType: "image/jpeg", base64Data: "XYZ")

        #expect(pngUrl.description == "url(\"data:image/png;base64,ABC\")")
        #expect(jpegUrl.description == "url(\"data:image/jpeg;base64,XYZ\")")
    }

    @Test func `data url with long base64 string`() {
        let longData = String(repeating: "A", count: 100)
        let url = Url.dataUrl(mimeType: "image/svg+xml", base64Data: longData)
        #expect(url.description.hasPrefix("url(\"data:image/svg+xml;base64,"))
        #expect(url.description.hasSuffix("\")"))
    }
}

// MARK: - CSS Property Usage

@Suite
struct `Url - CSS Property Usage` {
    @Test func `url renders correctly in background-image property`() {
        let url = Url("images/bg.png")
        let property = "background-image: \(url)"
        #expect(property == "background-image: url(\"images/bg.png\")")
    }

    @Test func `url renders correctly in cursor property`() {
        let url = Url("cursors/pointer.cur")
        let property = "cursor: \(url)"
        #expect(property == "cursor: url(\"cursors/pointer.cur\")")
    }

    @Test func `url renders correctly in content property`() {
        let url = Url("icons/arrow.svg")
        let property = "content: \(url)"
        #expect(property == "content: url(\"icons/arrow.svg\")")
    }

    @Test func `url renders correctly in list-style-image property`() {
        let url = Url("bullets/custom.png")
        let property = "list-style-image: \(url)"
        #expect(property == "list-style-image: url(\"bullets/custom.png\")")
    }
}

// MARK: - Protocol Conformance

@Suite
struct `Url - String Literal Conformance` {
    @Test func `string literal creates url with default quotes`() {
        let url: Url = "images/photo.jpg"
        #expect(url.description == "url(\"images/photo.jpg\")")
    }
}

@Suite
struct `Url - Hashable Conformance` {
    @Test func `equal urls are equal`() {
        let url1 = Url("images/photo.jpg")
        let url2 = Url("images/photo.jpg")
        #expect(url1 == url2)
    }

    @Test func `different urls are not equal`() {
        let url1 = Url("images/photo1.jpg")
        let url2 = Url("images/photo2.jpg")
        #expect(url1 != url2)
    }
}

// MARK: - CSSOM Specification Compliance

@Suite
struct `Url - CSSOM Specification` {
    @Test func `follows cssom url serialization`() {
        // Per CSSOM: URL serialization is url(<serialized string>)
        let url = Url("path/to/file.jpg")
        #expect(url.description.hasPrefix("url(\""))
        #expect(url.description.hasSuffix("\")"))
    }

    @Test func `uses string serialization rules`() {
        // Control characters should be escaped as code points
        let url = Url("file\u{0001}name.jpg")
        #expect(url.description.contains("\\1 "))
    }
}

// MARK: - Performance

extension `Performance Tests` {
    @Suite
    struct `Url - Performance` {
        @Test(.timeLimit(.minutes(1)))
        func `url creation 100K times`() {
            for i in 0..<100_000 {
                _ = Url("path/file\(i % 100).jpg")
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
                _ = Url.dataUrl(mimeType: "image/png", base64Data: "data\(i % 100)")
            }
        }
    }
}
