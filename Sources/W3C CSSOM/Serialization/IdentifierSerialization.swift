import Foundation

/// Serializes an identifier according to the CSSOM specification.
///
/// This function implements the identifier serialization algorithm defined in
/// Section 2.1 of the CSS Object Model (CSSOM) specification.
///
/// - Parameter identifier: The identifier string to serialize
/// - Returns: A properly escaped identifier string suitable for CSS output
///
/// - SeeAlso: [CSSOM: Serialize an Identifier](https://drafts.csswg.org/cssom/#serialize-an-identifier)
///
/// ## Algorithm
///
/// For each character in the identifier:
///
/// 1. **NULL (U+0000)**: Replaced with U+FFFD (REPLACEMENT CHARACTER)
/// 2. **Control characters (U+0001-U+001F, U+007F)**: Escaped as code point
/// 3. **First character is digit (U+0030-U+0039)**: Escaped as code point
/// 4. **Second character is digit when first is hyphen**: Escaped as code point
/// 5. **Lone hyphen**: Escaped as single character if it's the only character
/// 6. **Valid identifier characters**: Passed through unchanged:
///    - Letters (A-Z, a-z)
///    - Digits (0-9, except in positions mentioned above)
///    - Hyphen (U+002D)
///    - Underscore (U+005F)
///    - Non-ASCII (≥ U+0080)
/// 7. **All other characters**: Escaped as single character
///
/// ### Escaping Methods
///
/// - **Escape as code point**: `\` + hex representation (minimum digits) + space
///   - Example: U+0001 → `\1 `, U+007F → `\7f `
///
/// - **Escape as single character**: `\` + character
///   - Example: `!` → `\!`
func serializeIdentifier(_ identifier: String) -> String {
    guard !identifier.isEmpty else {
        return ""
    }

    var result = ""
    let characters = Array(identifier)

    for (index, char) in characters.enumerated() {
        let scalar = char.unicodeScalars.first!
        let value = scalar.value

        // 1. NULL (U+0000) -> U+FFFD
        if value == 0x0000 {
            result.append("\u{FFFD}")
            continue
        }

        // 2. Control characters (U+0001-U+001F, U+007F) -> escape as code point
        if (value >= 0x0001 && value <= 0x001F) || value == 0x007F {
            result.append(escapeAsCodePoint(scalar))
            continue
        }

        // 3. First character is digit -> escape as code point
        if index == 0 && value >= 0x0030 && value <= 0x0039 {
            result.append(escapeAsCodePoint(scalar))
            continue
        }

        // 4. Second character is digit when first is hyphen -> escape as code point
        if index == 1 && characters[0] == "-" && value >= 0x0030 && value <= 0x0039 {
            result.append(escapeAsCodePoint(scalar))
            continue
        }

        // 5. Lone hyphen -> escape as single character
        if index == 0 && characters.count == 1 && char == "-" {
            result.append("\\-")
            continue
        }

        // 6. Valid identifier characters -> pass through
        if isValidIdentifierCharacter(scalar) {
            result.append(char)
            continue
        }

        // 7. All other characters -> escape as single character
        result.append("\\")
        result.append(char)
    }

    return result
}

/// Checks if a character is a valid identifier character that doesn't need escaping.
///
/// Valid characters are:
/// - Letters (A-Z, a-z)
/// - Digits (0-9)
/// - Hyphen (U+002D)
/// - Underscore (U+005F)
/// - Non-ASCII (≥ U+0080)
private func isValidIdentifierCharacter(_ scalar: Unicode.Scalar) -> Bool {
    let value = scalar.value

    return (value >= 0x0041 && value <= 0x005A) ||  // A-Z
           (value >= 0x0061 && value <= 0x007A) ||  // a-z
           (value >= 0x0030 && value <= 0x0039) ||  // 0-9
           value == 0x002D ||                        // -
           value == 0x005F ||                        // _
           value >= 0x0080                           // non-ASCII
}

/// Escapes a Unicode scalar as a code point.
///
/// Format: backslash + hexadecimal (minimum digits) + space
///
/// Examples:
/// - U+0001 → `\1 `
/// - U+001F → `\1f `
/// - U+007F → `\7f `
private func escapeAsCodePoint(_ scalar: Unicode.Scalar) -> String {
    return String(format: "\\%x ", scalar.value)
}
