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
    container.register(Session.self) { [weak self] _ in
      guard let self = self else { return Session() }
      
      return Session(
        configuration: self.getConfiguration(),
        serverTrustManager: self.getManager()
      )
    }
    .inObjectScope(.container)

    container.register(AFErrorMapper.self) { _ in
      AFErrorMapper()
    }
    .inObjectScope(.container)

    container.register(AFTranslateApi.self) { container in
      AFTranslateApi(
        session: container.resolve(Session.self)!,
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
  }

  private func getManager() -> ServerTrustManager {
    ServerTrustManager(
      allHostsMustBeEvaluated: false,
      evaluators: [
        WebUrlPath.domen : DisabledTrustEvaluator()
      ]
    )
  }
  
  private func getConfiguration() -> URLSessionConfiguration {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 60
    configuration.headers = [
      HTTPHeader(name: "X-Key", value: "80VC2E-CBVF1-Z3V6Z-CV726"),
      HTTPHeader(name: "Content-Type", value: "application/json")
    ]

    return configuration
  }
}
