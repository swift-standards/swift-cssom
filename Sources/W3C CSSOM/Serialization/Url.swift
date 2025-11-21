/// Represents a CSS URL value.
///
/// The `Url` type is a pointer to a resource such as an image, video, CSS file, font file, or SVG.
/// It is used in various CSS properties like `background-image`, `cursor`, `@import`, and more.
///
/// URLs are automatically serialized according to the CSSOM specification as `url("...")` with
/// proper escaping of special characters.
///
/// Example:
/// ```swift
/// Url("images/background.png")     // Serializes to: url("images/background.png")
/// Url("path with spaces.png")      // Serializes to: url("path with spaces.png")
/// Url("data:image/png;base64,...")  // Serializes to: url("data:image/png;base64,...")
/// ```
///
/// ## Serialization
///
/// Per CSSOM specification, URLs are serialized as `url(` + serialized string + `)`,
/// where the string serialization applies the same escaping rules as CSS strings.
///
/// - Note: CSSOM always serializes URLs with double quotes.
///
/// - SeeAlso: [CSSOM: Serialize a URL](https://drafts.csswg.org/cssom/#serialize-a-url)
public struct Url: Sendable, Hashable {
    /// The raw URL string value (before serialization)
    public let value: String

    /// Creates a new CSS URL value
    ///
    /// - Parameter value: The raw URL string
    ///
    /// The URL will be properly serialized (escaped and quoted) when converted
    /// to a string via the `description` property.
    public init(_ value: String) {
        self.value = value
    }

    /// Creates a new CSS URL value (deprecated API for backward compatibility)
    ///
    /// - Parameters:
    ///   - value: The raw URL string
    ///   - quotes: Ignored - CSSOM always uses double quotes
    ///
    /// - Note: This initializer is provided for backward compatibility. Per CSSOM specification,
    ///         URLs are always serialized with double quotes. The `quotes` parameter is ignored.
    @available(*, deprecated, message: "Per CSSOM spec, URLs are always serialized with double quotes. Use init(_:) instead.")
    public init(_ value: String, quotes: CSSString.Quotes?) {
        self.value = value
    }

    /// Creates a data URL for an embedded resource
    ///
    /// - Parameters:
    ///   - mimeType: The MIME type of the resource
    ///   - base64Data: The Base64-encoded data
    /// - Returns: A data URL
    public static func dataUrl(
        mimeType: String,
        base64Data: String
    ) -> Url {
        let dataUrl = "data:\(mimeType);base64,\(base64Data)"
        return Url(dataUrl)
    }
}

/// Provides string conversion for CSS output
extension Url: CustomStringConvertible {
    /// Converts the URL to its properly serialized CSS representation
    ///
    /// Per CSSOM specification, a URL is serialized as `url(` + serialized string + `)`,
    /// where the URL value is serialized using the same string serialization rules.
    ///
    /// - SeeAlso: [CSSOM: Serialize a URL](https://drafts.csswg.org/cssom/#serialize-a-url)
    public var description: String {
        return "url(\(serializeString(value)))"
    }
}

/// String literal conversion
extension Url: ExpressibleByStringLiteral {
    /// Creates a URL from a string literal
    public init(stringLiteral value: StringLiteralType) {
        self.init(value)
    }
}
