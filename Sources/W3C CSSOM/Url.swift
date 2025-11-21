import Foundation

/// Represents a CSS URL value.
///
/// The `Url` type is a pointer to a resource such as an image, video, CSS file, font file, or SVG.
/// It is used in various CSS properties like `background-image`, `cursor`, `@import`, and more.
///
/// Example:
/// ```swift
/// .backgroundImage(.url("images/background.png"))     // background-image: url("images/background.png")
/// .cursor(.url("cursors/pointer.cur"))                // cursor: url("cursors/pointer.cur")
/// ```
///
/// - Note: URLs in CSS can be relative or absolute, and may be quoted or unquoted.
///         This implementation uses quotes by default.
///
/// - SeeAlso: [MDN Web Docs on url](https://developer.mozilla.org/en-US/docs/Web/CSS/url)
public struct Url: Sendable, Hashable {
    /// The URL string value
    public let value: String

    /// Whether to use quotes around the URL
    public let quotes: CSSString.Quotes?

    /// Creates a new CSS URL value
    ///
    /// - Parameters:
    ///   - value: The URL string
    ///   - quotes: Whether to put quotes around the URL (default: true)
    public init(_ value: String, quotes: CSSString.Quotes? = .single) {
        self.value = value
        self.quotes = quotes
    }

    /// Creates a data URL for an embedded resource
    ///
    /// - Parameters:
    ///   - mimeType: The MIME type of the resource
    ///   - base64Data: The Base64-encoded data
    ///   - quotes: Whether to put quotes around the URL (default: true)
    /// - Returns: A data URL
    public static func dataUrl(
        mimeType: String,
        base64Data: String,
        quotes: CSSString.Quotes? = .single
    ) -> Url {
        let dataUrl = "data:\(mimeType);base64,\(base64Data)"
        return Url(dataUrl, quotes: quotes)
    }
}

/// Provides string conversion for CSS output
extension Url: CustomStringConvertible {
    /// Converts the URL to its CSS string representation
    ///
    /// Per CSSOM specification, URLs are serialized as strings with minimal escaping:
    /// - Quoted: only newlines, backslashes, and the quote character need escaping
    /// - Unquoted: spaces, parentheses, quotes, and special chars need backslash-escaping
    public var description: String {
        // Remove surrounding quotes if present in the input value
        var processedValue = value
        if (processedValue.hasPrefix("\"") && processedValue.hasSuffix("\""))
            || (processedValue.hasPrefix("'") && processedValue.hasSuffix("'"))
        {
            // Remove the first and last character (quotes)
            let startIndex = processedValue.index(after: processedValue.startIndex)
            let endIndex = processedValue.index(before: processedValue.endIndex)
            processedValue = String(processedValue[startIndex..<endIndex])
        }

        // Handle quotes based on the quotes property
        let urlString: String
        if let quoteStyle = quotes {
            // Per CSSOM: quoted URLs only escape newlines, backslashes, and the quote character
            // Spaces and other characters remain literal (no percent-encoding)
            switch quoteStyle {
            case .single:
                let escaped = processedValue
                    .replacing("\\", with: "\\\\")
                    .replacing("\n", with: "\\n")
                    .replacing("'", with: "\\'")
                urlString = "'\(escaped)'"
            case .double:
                let escaped = processedValue
                    .replacing("\\", with: "\\\\")
                    .replacing("\n", with: "\\n")
                    .replacing("\"", with: "\\\"")
                urlString = "\"\(escaped)\""
            }
        } else {
            // Unquoted URLs: backslash-escape spaces and special characters
            let escapedValue = escapeUrlCharacters(processedValue)
            urlString = escapedValue
        }

        return "url(\(urlString))"
    }

    /// Escapes URL-specific special characters for unquoted URL syntax
    ///
    /// Per CSS Values spec: "parentheses, whitespace characters, single quotes (')
    /// and double quotes (") appearing in a URL must be escaped with a backslash"
    ///
    /// - Parameter string: The URL string to escape
    /// - Returns: An escaped URL string suitable for unquoted url() syntax
    private func escapeUrlCharacters(_ string: String) -> String {
        // Special handling for data URLs
        if string.hasPrefix("data:") {
            // For data URLs, we don't need to escape URL-specific characters
            return string
        }

        // For unquoted URLs, use backslash-escaping (not percent-encoding)
        return string
            .replacing("\\", with: "\\\\")
            .replacing("(", with: "\\(")
            .replacing(")", with: "\\)")
            .replacing(" ", with: "\\ ")
            .replacing("\t", with: "\\\t")
            .replacing("\n", with: "\\n")
            .replacing("'", with: "\\'")
            .replacing("\"", with: "\\\"")
    }
}

/// String literal conversion
extension Url: ExpressibleByStringLiteral {
    /// Creates a URL from a string literal
    public init(stringLiteral value: StringLiteralType) {
        self.init(value)
    }
}
