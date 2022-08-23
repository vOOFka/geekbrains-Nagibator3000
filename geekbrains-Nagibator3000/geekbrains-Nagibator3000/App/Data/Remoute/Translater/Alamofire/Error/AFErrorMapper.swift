//
//  AFErrorMapper.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 04.08.2022.
//

import Foundation
import Alamofire

public class AFErrorMapper {
  init() {}

  func map(error: AFError) -> GenericNetworkingError {
    switch error {
    case .responseValidationFailed(let reason):
      return responseValidationFailed(reason)

    case .sessionTaskFailed(let error):
      return sessionTaskFailed(error)

    case .responseSerializationFailed(let reason):
      return responseSerializationFailed(reason)

    default:
      return OtherError()
    }
  }
  
  public func sessionTaskFailed(_ error: Error) -> GenericNetworkingError {
    InternetConnectionLost()
  }
  
  private func responseValidationFailed(_ reason: AFError.ResponseValidationFailureReason) -> GenericNetworkingError {
    switch reason {
    case .unacceptableStatusCode(code: let code):
      return unacceptableStatusCode(code: code)

    default:
      return OtherError()
    }
  }

  private func unacceptableStatusCode(code: Int) -> GenericNetworkingError {
    switch code {
    case 400:
      return BadRequest()

    case 401:
      return Unauthorized()

    case 403:
      return Forbidden()
      
    case 500...599:
      return ConnectionLost(code)

    default:
      return OtherError()
    }
  }

  private func responseSerializationFailed(
    _ reason: AFError.ResponseSerializationFailureReason
  ) -> GenericNetworkingError {
    BadResponse()
  }
}
