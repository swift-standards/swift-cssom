import Foundation

/// Serializes a string according to the CSSOM specification.
///
/// This function implements the string serialization algorithm defined in
/// Section 2.1 of the CSS Object Model (CSSOM) specification.
///
/// - Parameter string: The string value to serialize
/// - Returns: A properly escaped and quoted string suitable for CSS output
///
/// - SeeAlso: [CSSOM: Serialize a String](https://drafts.csswg.org/cssom/#serialize-a-string)
///
/// ## Algorithm
///
/// The string is wrapped in double quotes (`"`) and characters are processed as follows:
///
/// 1. **NULL (U+0000)**: Replaced with U+FFFD (REPLACEMENT CHARACTER)
/// 2. **Control characters (U+0001-U+001F, U+007F)**: Escaped as code point
/// 3. **Double quote (U+0022)**: Escaped as single character (`\"`)
/// 4. **Backslash (U+005C)**: Escaped as single character (`\\`)
/// 5. **All other characters**: Included as-is
///
/// ### Escaping Methods
///
/// - **Escape as code point**: `\` + hex representation (minimum digits) + space
///   - Example: U+0001 → `\1 `, U+001F → `\1f `
///
/// - **Escape as single character**: `\` + character
///   - Example: `"` → `\"`, `\` → `\\`
///
/// ### Note
///
/// Per CSSOM specification, strings always serialize with double quotes.
/// Single quotes (U+0027) are never escaped since they don't need escaping
/// within double-quoted strings.
func serializeString(_ string: String) -> String {
    var result = "\""

    for char in string {
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

        // 3. Double quote (U+0022) -> escape as single character
        if value == 0x0022 {
            result.append("\\\"")
            continue
        }

        // 4. Backslash (U+005C) -> escape as single character
        if value == 0x005C {
            result.append("\\\\")
            continue
        }

        // 5. All other characters -> include as-is
        result.append(char)
    }

    result.append("\"")
    return result
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
