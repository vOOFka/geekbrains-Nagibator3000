//
//  AFSession.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 15.08.2022.
//

import Foundation

import Alamofire
public class AFSession {
  let baseUrl: String
  let session: Session

  public init() {
    self.baseUrl = ""
    self.session = Session()
  }
  
  public init(
    baseUrl: String,
    configuration: URLSessionConfiguration,
    trustManaget: ServerTrustManager
  ) {
    self.baseUrl = baseUrl
    self.session = Session(
      configuration: configuration,
      serverTrustManager: trustManaget
    )
  }
}
