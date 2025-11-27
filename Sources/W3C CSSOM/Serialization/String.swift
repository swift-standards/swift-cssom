/// Represents a CSS string value.
///
/// The `CSSString` type represents a sequence of characters used in CSS properties
/// such as `content`, `font-family`, and `quotes`. Strings are automatically serialized
/// according to the CSSOM specification with proper escaping of special characters.
///
/// Example:
/// ```swift
/// CSSString("Hello, world!")    // Serializes to: "Hello, world!"
/// CSSString("Line 1\nLine 2")   // Serializes to: "Line 1\a Line 2"
/// CSSString("Say \"Hi\"")       // Serializes to: "Say \"Hi\""
/// ```
///
/// ## Serialization
///
/// Strings are serialized with double quotes and special characters are escaped:
/// - NULL (U+0000) → U+FFFD (replacement character)
/// - Control characters (U+0001-U+001F, U+007F) → escaped as hex codes
/// - Double quotes (") → `\"`
/// - Backslashes (\) → `\\`
///
/// - Note: Per CSSOM specification, strings always serialize with double quotes.
///
/// - SeeAlso: [CSSOM: Serialize a String](https://drafts.csswg.org/cssom/#serialize-a-string)
public struct CSSString: Sendable, Hashable {
    /// The raw string value (before serialization)
    public let value: String
//
//    /// Quote style enum (deprecated, kept for backward compatibility)
//    @available(*, deprecated, message: "Per CSSOM spec, strings are always serialized with double quotes")
//    public enum Quotes: Sendable, Hashable {
//        case single
//        case double
//    }

    /// Creates a new CSS string value
    ///
    /// - Parameter value: The raw string value
    ///
    /// The string will be properly serialized (escaped and quoted) when converted
    /// to a string via the `description` property.
    public init(_ value: String) {
        self.value = value
    }
//
//    /// Creates a new CSS string value (deprecated API for backward compatibility)
//    ///
//    /// - Parameters:
//    ///   - value: The raw string value
//    ///   - quotes: Ignored - CSSOM always uses double quotes
//    ///
//    /// - Note: This initializer is provided for backward compatibility. Per CSSOM specification,
//    ///         strings are always serialized with double quotes. The `quotes` parameter is ignored.
//    @available(*, deprecated, message: "Per CSSOM spec, strings are always serialized with double quotes. Use init(_:) instead.")
//    public init(_ value: String, quotes: Quotes) {
//        self.value = value
//    }

    /// Creates an empty CSS string value
    public static let empty = CSSString("")
}

/// Provides string conversion for CSS output
extension CSSString: CustomStringConvertible {
    /// Converts the CSS string to its properly serialized CSS representation
    ///
    /// The string is serialized according to the CSSOM specification, wrapped in
    /// double quotes with proper escaping of special characters and control characters.
    ///
    /// - SeeAlso: [CSSOM: Serialize a String](https://drafts.csswg.org/cssom/#serialize-a-string)
    public var description: String {
        return serializeString(value)
    }
}

/// String literal conversion
extension CSSString: ExpressibleByStringLiteral {
    /// Creates a CSS string from a string literal
    public init(stringLiteral value: StringLiteralType) {
        self.init(value)
    }
}

/// String literal conversion
extension CSSString: ExpressibleByStringInterpolation {

}
