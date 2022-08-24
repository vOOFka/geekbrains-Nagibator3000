//
//  LanguagesRepository.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 09.08.2022.
//

import Foundation
import RxSwift

class LanguagesRepository {
  private let disposeBag = DisposeBag()
  let objectAdapter: ObjectBasedAdapter<LanguageModel, LanguageStorageModel>
  let api: AFLanguagesApi
  let mapper: LanguagesMapper

  init (
    objectAdapter: ObjectBasedAdapter<LanguageModel, LanguageStorageModel>,
    api: AFLanguagesApi,
    mapper: LanguagesMapper
  ) {
    self.objectAdapter = objectAdapter
    self.api = api
    self.mapper = mapper
  }

  func load() -> Completable {
    Completable.create { [weak self] completable in
      guard let self = self else { return Disposables.create() }
      
      self.api.get()
        .subscribe { [weak self] event in
          guard let self = self else { return }
          
          switch event {
          case .next(let values):
            self.objectAdapter.write(model: self.mapper.map(response: values))
              .subscribe(onNext: { completed in
                if completed {
                  completable(.completed)
                } else {
                  completable(.error(OtherError()))
                }
              })
              .disposed(by: self.disposeBag)
            
          case .error(let error):
            completable(.error(error))
            
          default:
            break
          }
        }
        .disposed(by: self.disposeBag)
      
      return Disposables.create()
    }
  }
  
  func get() -> Observable<[LanguageModel]> {
    objectAdapter.read()
  }
}
