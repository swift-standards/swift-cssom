# swift-cssom

A spec-compliant Swift implementation of the W3C CSS Object Model (CSSOM) serialization algorithms.

## Overview

This package implements the serialization algorithms defined in the [CSS Object Model (CSSOM) specification](https://drafts.csswg.org/cssom/), Section 2.1: Common Serializing Idioms, providing accurate and standards-compliant generation of CSS output from Swift.

## Features

- ✅ **100% Spec-Compliant**: Implements CSSOM serialization algorithms exactly as specified
- ✅ **Comprehensive Testing**: 134 tests covering all edge cases and specification requirements
- ✅ **Type Safety**: Leverages Swift's type system for compile-time safety
- ✅ **Performance Optimized**: Efficient serialization with minimal overhead
- ✅ **Well Documented**: Extensive inline documentation with direct spec references

## Installation

### Swift Package Manager

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/coenttb/swift-cssom", from: "1.0.0")
]
```

Then add the dependency to your target:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "W3C CSSOM", package: "swift-cssom")
    ]
)
```

## Usage

### String Serialization

Per CSSOM specification, strings are **always** serialized with double quotes:

```swift
import W3C_CSSOM

CSSString("Hello, world!")       // → "Hello, world!"
CSSString("Line 1\nLine 2")      // → "Line 1\a Line 2" (newline escaped)
CSSString("Say \"Hi\"")          // → "Say \"Hi\"" (quotes escaped)
CSSString("C:\\path")            // → "C:\\\\path" (backslashes escaped)
```

### URL Serialization

URLs are serialized as `url(<string>)` using string serialization rules:

```swift
import W3C_CSSOM

Url("images/background.png")    // → url("images/background.png")
Url("path with spaces.png")     // → url("path with spaces.png")
Url("file\nname.jpg")           // → url("file\a name.jpg")

// Data URLs
Url.dataUrl(mimeType: "image/png", base64Data: "iVBORw0KGgo=")
// → url("data:image/png;base64,iVBORw0KGgo=")
```

### Identifiers

Identifiers automatically apply CSSOM escaping rules:

```swift
import W3C_CSSOM

// Base identifier
Ident("block")                   // → block
Ident("my-color")               // → my-color
Ident("3d")                     // → \33 d (leading digit escaped)

// Custom identifiers (for animations, counters, etc.)
CustomIdent("slideIn")          // → slideIn
CustomIdent("my-animation")     // → my-animation

// Dashed identifiers (CSS custom properties)
DashedIdent("primary-color")                    // → --primary-color
DashedIdent("primary-color").var()              // → var(--primary-color)
DashedIdent("theme").var(fallback: "light")     // → var(--theme, light)
```

## Package Organization

The package structure mirrors the CSSOM specification:

```
Sources/W3C CSSOM/
├── Serialization/                  # CSSOM §2.1: Common Serializing Idioms
│   ├── String.swift               # CSSString type
│   ├── StringSerialization.swift  # String serialization algorithm
│   ├── Url.swift                  # Url type
│   └── IdentifierSerialization.swift  # Identifier serialization algorithm
└── Identifiers/                    # CSS Values types using CSSOM serialization
    ├── Ident.swift               # Base identifier
    ├── CustomIdent.swift         # User-defined identifiers
    └── DashedIdent.swift         # CSS custom properties (--*)
```

## Specification Compliance

### String Serialization ([CSSOM §2.1](https://drafts.csswg.org/cssom/#serialize-a-string))

1. Wrap in double quotes (`"`)
2. NULL (U+0000) → U+FFFD (replacement character)
3. Control characters (U+0001-U+001F, U+007F) → `\<hex><space>`
4. Double quote (U+0022) → `\"`
5. Backslash (U+005C) → `\\`
6. All other characters remain unchanged

### URL Serialization ([CSSOM §2.1](https://drafts.csswg.org/cssom/#serialize-a-url))

Format: `url(` + serialized string + `)`

The URL value is serialized using the same string serialization rules.

### Identifier Serialization ([CSSOM §2.1](https://drafts.csswg.org/cssom/#serialize-an-identifier))

1. NULL (U+0000) → U+FFFD
2. Control characters (U+0001-U+001F, U+007F) → `\<hex><space>`
3. Leading digit (U+0030-U+0039) → `\<hex><space>`
4. Second character digit when first is hyphen → `\<hex><space>`
5. Lone hyphen → `\-`
6. Valid identifier characters (letters, digits, `-`, `_`, ≥U+0080) pass through
7. All other characters → `\<char>`

## Testing

Run the comprehensive test suite:

```bash
swift test
```

The package includes 134 tests in 49 suites covering:
- ✅ CSSOM serialization algorithm compliance
- ✅ Edge cases and special characters
- ✅ Control character handling
- ✅ NULL character handling
- ✅ Performance benchmarks (100K iterations)
- ✅ Protocol conformances
- ✅ Real-world CSS property usage

## Backward Compatibility

Deprecated APIs are provided for backward compatibility with swift-w3c-css:

```swift
// ⚠️ Deprecated (generates warnings)
CSSString("test", quotes: .single)    // Ignored - always uses double quotes per spec
Url("path", quotes: nil)              // Ignored - always uses double quotes per spec

// ✅ Preferred (spec-compliant)
CSSString("test")                     // Always uses double quotes
Url("path")                           // Always uses double quotes
```

These deprecated APIs will be removed in a future major version.

## Requirements

- Swift 6.0+
- macOS 15.0+, iOS 18.0+, tvOS 18.0+, watchOS 11.0+, macCatalyst 18.0+

## License

Apache 2.0

## Specifications

This implementation follows:

- **[CSSOM Module Level 1](https://drafts.csswg.org/cssom/)** (W3C Editor's Draft)
  - Section 2.1: Common Serializing Idioms
- **[CSS Values and Units Module Level 4](https://drafts.csswg.org/css-values-4/)** (W3C Editor's Draft)
  - Section 4: Textual Data Types (for identifier type definitions)

## Related Packages

- **[swift-w3c-css](https://github.com/coenttb/swift-w3c-css)** - Comprehensive W3C CSS implementation using swift-cssom
- **[swift-whatwg-url](https://github.com/swift-standards/swift-whatwg-url)** - WHATWG URL Living Standard (for URL parsing, not serialization)

## Contributing

Contributions are welcome! Please ensure:
- All changes maintain 100% CSSOM specification compliance
- Tests are added for any new functionality
- Documentation includes spec references
- Code follows the existing patterns and style

## Quality Metrics

- **Specification Compliance**: 100% (all CSSOM §2.1 serialization algorithms)
- **Test Coverage**: 134 tests, 49 suites, 100% pass rate
- **Performance**: All operations complete 100K iterations in <1 second
