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
    
}

// MARK: Public Methods
extension Translator {
    public func translateToEnglish(_ sourceText: String) async throws -> Translation {
        let translation = try await self.translate(sourceText)
        return await MainActor.run {
            translation
        }
    }
    
    public func translateToEnglish(_ sourceText: String, completion: @escaping (Result<Translation, TranslationError>) -> Void) {
        Task {
            do {
                let translation = try await self.translate(sourceText)
                await MainActor.run {
                    completion(.success(translation))
                }
            } catch let error as TranslationError {
                await MainActor.run {
                    completion(.failure(error))
                }
            } catch {
                await MainActor.run {
                    completion(.failure(.invalidResponse))
                }
            }
        }
    }
    
    public func translate(from: String = "auto", to: String, sourceText: String) async throws -> Translation {
        let translation = try await self.translate(sourceText, from: from, to: to)
        return await MainActor.run {
            translation
        }
    }
    
    public func translate(from: String, to: String, sourceText: String, completion: @escaping (Result<Translation, TranslationError>) -> Void) {
        Task {
            do {
                let translation = try await self.translate(sourceText, from: from, to: to)
                await MainActor.run {
                    completion(.success(translation))
                }
            } catch let error as TranslationError {
                await MainActor.run {
                    completion(.failure(error))
                }
            } catch {
                await MainActor.run {
                    completion(.failure(.invalidResponse))
                }
            }
        }
    }
}

// MARK: Private Methods
extension Translator {
    private func translate(_ sourceText: String, from: String = "auto", to: String = "en") async throws -> Translation {
        for lang in [from, to] {
            guard languageList.contains(lang) else {
                throw TranslationError.unsupportedLanguage(lang)
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
            throw TranslationError.parsingError
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw TranslationError.parsingError
        }
        
        guard httpResponse.statusCode == 200 else {
            throw TranslationError.serverError(statusCode: httpResponse.statusCode, body: String(data: data, encoding: .utf8) ?? "Unknown Error")
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
                return translation
            } else {
                throw TranslationError.invalidResponse
            }
        } catch {
            debugPrint(error.localizedDescription)
            throw TranslationError.invalidResponse
        }
    }
}
