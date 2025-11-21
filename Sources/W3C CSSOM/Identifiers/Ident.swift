/// Represents a CSS identifier string.
///
/// The `Ident` type represents an arbitrary string used as an identifier in CSS.
/// Identifiers are used throughout CSS for property names, values, and other contexts
/// where an unquoted string is needed.
///
/// Example:
/// ```swift
/// Ident("block")      // Serializes to: block
/// Ident("my-color")   // Serializes to: my-color
/// Ident("3d")         // Serializes to: \33 d (escaped leading digit)
/// ```
///
/// ## Serialization
///
/// The identifier is automatically serialized according to the CSSOM specification when
/// converted to a string. Special characters, control characters, and leading digits
/// are properly escaped.
///
/// - Note: CSS identifiers are case-sensitive.
///
/// - SeeAlso: [CSSOM: Serialize an Identifier](https://drafts.csswg.org/cssom/#serialize-an-identifier)
public struct Ident: Sendable, Hashable {
    /// The raw identifier string value (before serialization)
    public let value: String

    /// Creates an identifier from a string value.
    ///
    /// - Parameter value: The raw identifier string
    ///
    /// The identifier will be properly serialized (escaped) when converted to a string
    /// via the `description` property.
    public init(_ value: String) {
        self.value = value
    }
}

extension Ident: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.value = value
    }
}

/// Provides string conversion for CSS output
extension Ident: CustomStringConvertible {
    /// Converts the identifier to its properly serialized CSS representation
    ///
    /// The identifier is serialized according to the CSSOM specification, with proper
    /// escaping of special characters, control characters, and leading digits.
    ///
    /// - SeeAlso: [CSSOM: Serialize an Identifier](https://drafts.csswg.org/cssom/#serialize-an-identifier)
    public var description: String {
        return serializeIdentifier(value)
    }
}
