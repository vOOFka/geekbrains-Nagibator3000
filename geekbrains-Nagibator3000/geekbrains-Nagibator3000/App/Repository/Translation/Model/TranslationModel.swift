//
//  TranslationModel.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 05.08.2022.
//

import Foundation
import RxDataSources

public struct TranslationModel: IdentifiableType {
    public var identity: String {
            UUID().uuidString
        }
    
    public typealias Identity = String
    
  let fromText: String
  let toText: String
}

extension TranslationModel: Equatable {
    public static func == (lhs: TranslationModel, rhs: TranslationModel) -> Bool {
        return lhs.identity == rhs.identity
    }
}
