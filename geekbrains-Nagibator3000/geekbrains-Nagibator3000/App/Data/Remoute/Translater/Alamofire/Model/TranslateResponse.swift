//
//  TranslateResponse.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 05.08.2022.
//

import Foundation

public struct TranslateResponse: Codable {
    let translations: [Translation]?
    let code: Int?
    let message: String?
    let details: [Detail]?
}

public struct Translation: Codable {
    let text, detectedLanguageCode: String
}

public struct Detail: Codable {
    let type, requestID: String
    
    enum CodingKeys: String, CodingKey {
        case type
        case requestID
    }
}
