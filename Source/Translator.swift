//
//  TranslationError.swift
//  Pods
//
//  Created by Akash Tala on 02/08/25.
//

import Foundation

public enum TranslationError: Error {
    case unsupportedLanguage(String)
    case invalidResponse
    case serverError(statusCode: Int, body: String)
    case parsingError
}

public struct Translation {
    public let translatedText: String
    public let sourceText: String
    public let sourceLanguage: Language
    public let targetLanguage: Language
}

public enum ClientType {
    case siteGT
    case extensionGT
}

public class Translator {
    private let baseUrl = "translate.googleapis.com"
    private let path = "/translate_a/single"
    private let client: ClientType
    private let tokenProvider = TokenProvider()
    private let languageList = LanguageList()
    
    public init(client: ClientType = .siteGT) {
        self.client = client
    }
    
    public func translate(_ sourceText: String, from: String = "auto", to: String = "en", success: @escaping (Translation) -> Void, failure: @escaping (TranslationError) -> Void) {
        for lang in [from, to] {
            guard languageList.contains(lang) else {
                failure(.unsupportedLanguage(lang))
                return
            }
        }
        
        let token = tokenProvider.generateToken(text: sourceText)
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = baseUrl
        components.path = path
        components.queryItems = [
            URLQueryItem(name: "client", value: client == .siteGT ? "t" : "gtx"),
            URLQueryItem(name: "sl", value: from),
            URLQueryItem(name: "tl", value: to),
            URLQueryItem(name: "hl", value: to),
            URLQueryItem(name: "dt", value: "t"),
            URLQueryItem(name: "ie", value: "UTF-8"),
            URLQueryItem(name: "oe", value: "UTF-8"),
            URLQueryItem(name: "otf", value: "1"),
            URLQueryItem(name: "ssel", value: "0"),
            URLQueryItem(name: "tsel", value: "0"),
            URLQueryItem(name: "kc", value: "7"),
            URLQueryItem(name: "tk", value: token),
            URLQueryItem(name: "q", value: sourceText)
        ]
        
        guard let url = components.url else {
            failure(.parsingError)
            return
        }
        
        Task {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                failure(.parsingError)
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                failure(.serverError(statusCode: httpResponse.statusCode, body: String(data: data, encoding: .utf8) ?? "Unknown Error"))
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let outerArray = json as? [Any],
                   let translations = outerArray[0] as? [[Any]],
                   let firstTranslation = translations.first,
                   let translatedText = firstTranslation[0] as? String  {
                    var inputLang = from
                    if outerArray.count > 3 {
                        inputLang = outerArray[2] as? String ?? from
                    }
                    let translation = Translation(translatedText: translatedText, sourceText: sourceText, sourceLanguage: try languageList.getLanguage(by: inputLang), targetLanguage: try languageList.getLanguage(by: to))
                    success(translation)
                } else {
                    failure(.invalidResponse)
                }
            } catch {
                debugPrint(error.localizedDescription)
                failure(.invalidResponse)
            }
        }
    }
}
