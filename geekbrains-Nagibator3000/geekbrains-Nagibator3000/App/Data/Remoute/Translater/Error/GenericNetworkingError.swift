//
//  GenericNetworkingError.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 04.08.2022.
//

import Foundation

public class GenericNetworkingError: TRError {
  override public init(
    _ message: String,
    file: StaticString = #filePath
  ) {
    super.init(message, file: file)
  }
}

public class HTTPError: GenericNetworkingError {
  let code: Int

  init(
    _ code: Int,
    _ message: String,
    file: StaticString = #filePath
  ) {
    self.code = code

    super.init(message, file: file)
  }
}

public class InternetConnectionLost: GenericNetworkingError {
  init(file: StaticString = #filePath, line: UInt = #line) {
    super.init("Internet connection lost", file: file)
  }
}

public class ConnectionLost: HTTPError {
  init(_ code: Int, file: StaticString = #filePath, line: UInt = #line) {
    super.init(code, "Connection lost", file: file)
  }
}

public class BadRequest: HTTPError {
  init(file: StaticString = #filePath) {
    super.init(400, "Bad request", file: file)
  }
}

public class Unauthorized: HTTPError {
  init(file: StaticString = #filePath) {
    super.init(401, "Unauthorized", file: file)
  }
}

public class Forbidden: HTTPError {
  init(file: StaticString = #filePath) {
    super.init(403, "Forbidden", file: file)
  }
}

public class BadResponse: GenericNetworkingError {
  init(file: StaticString = #filePath) {
    super.init("Response data is not JSON as it expected", file: file)
  }
}

public class OtherError: GenericNetworkingError {
  init(file: StaticString = #filePath) {
    super.init("Oops... something went wrong", file: file)
  }
}
