//
//  AFTranslateApi.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 05.08.2022.
//

import Foundation
import Alamofire
import RxSwift

public class AFTranslateApi: TranslateApi {
  let session: AFSession
  let mapper: AFErrorMapper

  public init(session: AFSession, mapper: AFErrorMapper) {
    self.session = session
    self.mapper = mapper
  }

  public func traslate(translate: TranslateParams) -> Observable<TranslateResponse> {
    Observable<TranslateResponse>
      .create { [weak self] observable in
        guard let self = self else {
          observable.onError(OtherError())
          return Disposables.create()
        }

        self.session.session
          .request(
            WebUrlPath.baseUrl + self.path,
            method: .post,
            parameters: translate.params,
            encoder: JSONParameterEncoder.default
          )
          .validate(statusCode: 200..<300)
          .responseDecodable(of: TranslateResponse.self) { result in
            if let response = result.value {
              observable.onNext(response)
              observable.onCompleted()
            } else if let error = result.error {
              let mappedError = self.mapper.map(error: error)
              observable.onError(mappedError)
            }
          }

        return Disposables.create()
      }
  }
}

