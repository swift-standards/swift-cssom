# swift-cssom

W3C CSS Object Model (CSSOM) implementation in Swift.

## Overview

This package implements fundamental types from the [W3C CSSOM specification](https://drafts.csswg.org/cssom/), providing:

- **URL Serialization**: CSS `url()` values with proper quoting and escaping
- **String Serialization**: CSS string values with escape sequences
- **Identifiers**: Custom identifiers, dashed identifiers (CSS variables), and base identifier types

These types form the foundation for CSS serialization and are used throughout CSS specifications.

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

### URL Serialization

```swift
import W3C_CSSOM

// Quoted URLs (default - single quotes)
let url1 = Url("images/background.png")
print(url1) // url('images/background.png')

// Double quotes
let url2 = Url("images/photo.jpg", quotes: .double)
print(url2) // url("images/photo.jpg")

// Unquoted URLs
let url3 = Url("https://example.com/image.jpg", quotes: nil)
print(url3) // url(https://example.com/image.jpg)

// Per CSSOM spec: quoted URLs preserve spaces as literals
let url4 = Url("images/my photo.jpg")
print(url4) // url('images/my photo.jpg')

// Data URLs
let dataUrl = Url.dataUrl(
    mimeType: "image/png",
    base64Data: "iVBORw0KGgoAAAANSU"
)
print(dataUrl) // url('data:image/png;base64,iVBORw0KGgoAAAANSU')
```

### String Serialization

```swift
import W3C_CSSOM

// CSS strings with automatic escaping
let str1 = CSSString("Hello, world!")
print(str1) // 'Hello, world!'

// Double quotes
let str2 = CSSString("Content", quotes: .double)
print(str2) // "Content"

// Automatic escaping of quotes and special characters
let str3 = CSSString("It's great!", quotes: .single)
print(str3) // 'It\'s great!'

// Newlines are escaped
let str4 = CSSString("Line 1\nLine 2")
print(str4) // 'Line 1\A Line 2'
```

### Identifiers

```swift
import W3C_CSSOM

// Custom identifiers
let customId = CustomIdent("my-animation")
print(customId) // my-animation

// Dashed identifiers (CSS custom properties)
let variable = DashedIdent("primary-color")
print(variable) // --primary-color

// Use in var() function
print(variable.var()) // var(--primary-color)

// With fallback
print(variable.var(fallback: "blue")) // var(--primary-color, blue)
```

## CSSOM Specification

This implementation follows the [W3C CSSOM specification](https://drafts.csswg.org/cssom/) for serialization:

- **Quoted URLs**: Only newlines, backslashes, and quote characters are escaped
- **Unquoted URLs**: Spaces, parentheses, quotes, and special characters use backslash-escaping
- **Strings**: Quote characters, backslashes, and newlines are escaped

## Requirements

- Swift 6.2+
- macOS 15.0+, iOS 18.0+, tvOS 18.0+, watchOS 11.0+, macCatalyst 18.0+

## License

Apache 2.0

## Related Packages

- [swift-w3c-css](https://github.com/coenttb/swift-w3c-css) - W3C CSS specifications in Swift
- [swift-whatwg-url](https://github.com/swift-standards/swift-whatwg-url) - WHATWG URL Living Standard

