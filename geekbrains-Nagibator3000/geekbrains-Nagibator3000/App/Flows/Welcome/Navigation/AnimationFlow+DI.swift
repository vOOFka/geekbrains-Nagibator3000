//
//  AnimationFlow+DI.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 17.08.2022.
//

import Foundation
import Alamofire
import Swinject

extension AnimationFlow {
  func setUpDiContainer() {
    setupApi()
    setupRepository()
    setupUseCase()
  }
    
  private func setupApi() {
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
    
    container.register(AFLanguagesApi.self) { container in
      AFLanguagesApi(
        session: container.resolve(AFSession.self)!,
        mapper: container.resolve(AFErrorMapper.self)!
      )
    }
  }
  
  private func setupRepository() {
    container.register(UserDefaultsWrapper.self) { _ in
      UserDefaultsWrapper()
    }
    
    container.register(StorageController.self) { container in
      StorageController(
        userDefaults: container.resolve(UserDefaultsWrapper.self)!,
        key: StorageKeys.languages.rawValue
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
    
    container.register(Mapper<LanguageModel, LanguageStorageModel>.self) { _ in
      LanguageMapper()
    }
    .inObjectScope(.container)
    
    container.register(ObjectBasedAdapter<LanguageModel, LanguageStorageModel>.self) { container in
      ObjectBasedAdapter<LanguageModel, LanguageStorageModel>(
        dataStorage: container.resolve(DataStorage.self)!,
        mapper: container.resolve(Mapper<LanguageModel, LanguageStorageModel>.self)!
      )
    }
    .inObjectScope(.container)
    
    container.register(LanguagesMapper.self) { _ in
      LanguagesMapper()
    }
    .inObjectScope(.container)
    
    container.register(LanguagesRepository.self) { container in
      LanguagesRepository(
        objectAdapter: container.resolve(ObjectBasedAdapter<LanguageModel, LanguageStorageModel>.self)!,
        api: container.resolve(AFLanguagesApi.self)!,
        mapper: container.resolve(LanguagesMapper.self)!
      )
    }
    .inObjectScope(.container)
  }
  
  private func setupUseCase() {
    container.register(LanguageUseCase.self) { container in
      LanguageUseCase(
        repository: container.resolve(LanguagesRepository.self)!
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
