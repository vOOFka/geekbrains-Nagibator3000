//
//  MainFlow+DI.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 05.08.2022.
//

import Foundation
import Alamofire

extension MainFlow {
  func setUpDiContainer() {
    //Remoute
    container.register(AFSession.self) { [weak self] _ in
      guard let self = self else { return AFSession() }
      
      return AFSession(
        baseUrl: WebUrlPath.baseUrl,
        configuration: self.getConfiguration(),
        trustManaget: self.getManager()
      )
    }
    .inObjectScope(.container)
    
    container.register(AFErrorMapper.self) { _ in
      AFErrorMapper()
    }
    .inObjectScope(.container)
    
    container.register(AFTranslateApi.self) { container in
      AFTranslateApi(
        session: container.resolve(AFSession.self)!,
        mapper: container.resolve(AFErrorMapper.self)!
      )
    }
    
    container.register(TranslateMapper.self) { _ in
      TranslateMapper()
    }
    
    container.register(TranslaterUseCase.self) { container in
      TranslaterUseCase(
        api: container.resolve(AFTranslateApi.self)!,
        mapper: container.resolve(TranslateMapper.self)!
      )
    }
    
    //Storage
    container.register(UserDefaultsWrapper.self) { _ in
      UserDefaultsWrapper()
    }
    
    container.register(StorageController.self) { container in
      StorageController(
        userDefaults: container.resolve(UserDefaultsWrapper.self)!,
        key: StorageKeys.dictionary.rawValue
      )
    }
    
    container.register(JSONSerialiser.self) { _ in
      JSONSerialiser()
    }
    
    container.register(DataStorage.self) { container in
      DataStorage(
        controller: container.resolve(StorageController.self)!,
        serialiser: container.resolve(JSONSerialiser.self)!
      )
    }
    
    container.register(Mapper<TranslationModel, TranslationStorageModel>.self) { _ in
      TranslationMapper()
    }
    .inObjectScope(.container)
    
    container.register(ObjectBasedAdapter<TranslationModel, TranslationStorageModel>.self) { container in
      ObjectBasedAdapter<TranslationModel, TranslationStorageModel>(
        dataStorage: container.resolve(DataStorage.self)!,
        mapper: container.resolve(Mapper<TranslationModel, TranslationStorageModel>.self)!
      )
    }
    .inObjectScope(.container)
    
    container.register(TranslationRepository.self) { container in
      TranslationRepository(
        objectAdapter: container.resolve(ObjectBasedAdapter<TranslationModel, TranslationStorageModel>.self)!
      )
    }
    .inObjectScope(.container)
    
    container.register(DictionaryUseCase.self) { container in
      DictionaryUseCase(
        repository: container.resolve(TranslationRepository.self)!
      )
    }
  }
  
  private func getManager() -> ServerTrustManager {
    ServerTrustManager(
      allHostsMustBeEvaluated: false,
      evaluators: [
        WebUrlPath.baseUrl : DefaultTrustEvaluator()
        
      ]
    )
  }
  
  private func getConfiguration() -> URLSessionConfiguration {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 60
    configuration.headers = [
      HTTPHeader(name: "Authorization", value: getApiKey()),
      HTTPHeader(name: "Content-Type", value: "application/json")
    ]
    
    return configuration
  }
  
  private func getApiKey() -> String {
    if let path = Bundle.main.path(forResource: "YandexService-Info", ofType: "plist") {
      let nsDictionary = NSDictionary(contentsOfFile: path)
      if let apiKey = nsDictionary?["API_KEY"] as? String {
        print("API_KEY found")
        return "Api-Key " + apiKey
      }
    }
    return String()
  }
}
