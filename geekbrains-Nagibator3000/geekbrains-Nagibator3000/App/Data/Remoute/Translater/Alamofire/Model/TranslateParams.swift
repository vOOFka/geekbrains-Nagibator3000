//
//  TranslateParams.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 05.08.2022.
//

import Foundation
import SwiftUI

public struct TranslateParams {
    let params: [String : String]
    
    init(texts: String, sourceLanguageCode: String?, targetLanguageCode: String) {
        self.params = [TranslateParamsKey.texts.rawValue : texts,
                       TranslateParamsKey.sourceLanguageCode.rawValue : sourceLanguageCode ?? "",
                       TranslateParamsKey.targetLanguageCode.rawValue : targetLanguageCode]
    }
}

enum TranslateParamsKey: String {
    case texts = "texts"
    case targetLanguageCode = "targetLanguageCode"
    case sourceLanguageCode = "sourceLanguageCode"
}
