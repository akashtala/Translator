# 📘 Translator

[![Version](https://img.shields.io/cocoapods/v/Translator.svg?style=flat)](https://cocoapods.org/pods/Translator)
[![License](https://img.shields.io/cocoapods/l/Translator.svg?style=flat)](https://cocoapods.org/pods/Translator)
[![Platform](https://img.shields.io/cocoapods/p/Translator.svg?style=flat)](https://cocoapods.org/pods/Translator)

**A lightweight, Swift-based translation client** leveraging Google Translate endpoints.  
Supports both modern `async/await` and legacy completion-handler APIs.

---

## 🧩 Features

- ✅ Auto-detection of source language (`sl = auto`)
- ✅ Supports `async/await` and completion-handler interfaces
- ✅ Error handling with detailed enum-based errors
- ✅ Token-based query generation

---

## 🚀 Installation

Translator is available through [CocoaPods](https://cocoapods.org) and swift package manager.

**CocoaPods:**

```ruby
pod 'Translator'
```

**Swift Package Manager:**

```swift
dependencies: [
    .package(url: "https://github.com/akashtala/Translator.git", from: "1.0.0")
]
```

## 🔧 Usage

### 🔹 Async/Await

```swift
let translator = Translator()
do {
    let result = try await translator.translateToEnglish("Bonjour")
    print(result.translatedText)
} catch {
    print("❌ Error: \(error)")
}
```

### 🔹 Async/Await

```swift
let translator = Translator()
do {
    let result = try await translator.translateToEnglish("Bonjour")
    print(result.translatedText)
} catch {
    print("❌ Error: \(error)")
}
```

## 🧪 API Surface
| Function Signature | Description |
|:----------:|:----------:|
|translateToEnglish(_:)|Translate text to English (auto source detection)|
|translateToEnglish(_:completion:)|Same as above, using a callback|
|translate(from:to:sourceText:)|Translate from a specific language to another|
|translate(from:to:sourceText:)|Translate from a specific language to another|
|translate(from:to:sourceText:completion:)|Same, using a completion handler|

### 🔐 Error Handling
All translation operations may throw or return TranslationError:

- .unsupportedLanguage(String) – Language not supported by the internal list

- .invalidResponse – Unexpected or malformed response from the server

- .serverError(statusCode: Int, body: String) – HTTP error with status code

- .parsingError – Failed to construct request or parse the response

### 🤝 Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you’d like to change.

### 📄 License
Distributed under the MIT License. See LICENSE for more information.

### 🔗 Author
Akash Tala

[GitHub @akashtala](https://github.com/akashtala)

akashpatel54668@gmail.com
