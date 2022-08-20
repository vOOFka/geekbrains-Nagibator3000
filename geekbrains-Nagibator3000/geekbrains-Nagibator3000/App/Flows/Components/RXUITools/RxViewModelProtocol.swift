//
//  RxViewModelProtocol.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 12.08.2022.
//

protocol RxViewModelProtocol {
  associatedtype Input
  associatedtype Output

  var input: Input! { get }
  var output: Output! { get }
}
