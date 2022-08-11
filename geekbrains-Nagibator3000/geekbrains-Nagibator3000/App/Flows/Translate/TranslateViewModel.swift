//
//  TranslateViewModel.swift
//  geekbrains-Nagibator3000
//
//  Created by Home on 02.08.2022.
//

import Foundation
import RxCocoa
import RxSwift

final class TranslateViewModel {
    private let disposeBag = DisposeBag()
    
    private let translaterUseCase: TranslaterUseCase?
    
    private(set) var sourceLanguage: BehaviorRelay<Language>
    private(set) var destinationLanguage: BehaviorRelay<Language>
    
    private(set) var translatedText: BehaviorRelay<String>
    
    init?(translaterUseCase: TranslaterUseCase) {
        guard let languages = RepositoryLanguages.loadJson() else {
            return nil
        }
        
        self.translaterUseCase = translaterUseCase
    
        self.sourceLanguage = BehaviorRelay<Language>(value: languages[0])
        self.destinationLanguage = BehaviorRelay<Language>(value: languages[0])
        self.translatedText = BehaviorRelay<String>(value: String())
    }
    
    public func swapLanguages() {
        let sourceLanguage = self.destinationLanguage.value
        let destinationLanguage = self.sourceLanguage.value
        
        self.sourceLanguage.accept(sourceLanguage)
        self.destinationLanguage.accept(destinationLanguage)
    }
    
    public func configTranslateLanguage(language: Language, type: LanguageType) {
        type == .source ? sourceLanguage.accept(language) : destinationLanguage.accept(language)
    }
    
    public func translate(text: String) {
        let sourceLanguageCode = (self.sourceLanguage.value.code == "auto") ? nil : self.sourceLanguage.value.code
        let targetLanguageCode = (self.destinationLanguage.value.code == "auto") ? Locale.preferredLanguageCode : self.destinationLanguage.value.code

        let tanslateParams = TranslateParams(texts: text,
                                             sourceLanguageCode: sourceLanguageCode,
                                             targetLanguageCode: targetLanguageCode ?? Locale.preferredLanguageCode)
        translaterUseCase?.traslate(fromText: text, params: tanslateParams)
            .subscribe { [weak self] event in
                switch event {
                case .next(let tanslate):
                    self?.translatedText.accept(tanslate.toText)
                    break
                    
                case .error(let error):
                    print(error)
                    break
                    
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}

enum LanguageType {
    case source, destination
}
