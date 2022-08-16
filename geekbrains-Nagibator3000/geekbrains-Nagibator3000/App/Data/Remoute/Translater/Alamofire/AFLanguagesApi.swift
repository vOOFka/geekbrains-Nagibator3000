//
//  AFLanguagesApi.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 16.08.2022.
//

import Foundation
import Alamofire
import RxSwift

public class AFLanguagesApi: LanguagesApi {
  let session: AFSession
  let mapper: AFErrorMapper

  public init(session: AFSession, mapper: AFErrorMapper) {
    self.session = session
    self.mapper = mapper
  }

  public func get() -> Observable<LanguagesResponse> {
    Observable<LanguagesResponse>
      .create { [weak self] observable in
        guard let self = self else {
          observable.onError(OtherError())
          return Disposables.create()
        }

        self.session.session
          .request(
            WebUrlPath.baseUrl + self.path,
            method: .post
          )
          .validate(statusCode: 200..<300)
          .responseDecodable(of: LanguagesResponse.self) { result in
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


