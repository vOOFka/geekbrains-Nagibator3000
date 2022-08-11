//
//  FileObjectBasedAdapter.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 09.08.2022.
//

import Foundation
import RxSwift

class FileObjectBasedAdapter<RepositoryModel, StorageModel: Codable> {
  private let dataStorage: FileDataStorage
  private let mapper: Mapper<RepositoryModel, StorageModel>

  init(
    dataStorage: FileDataStorage,
    mapper: Mapper<RepositoryModel, StorageModel>
  ) {
    self.dataStorage = dataStorage
    self.mapper = mapper
  }

  func read() -> Observable<[RepositoryModel]> {
    Observable<[RepositoryModel]>.create { [weak self] observable in
      self?.dataStorage.read { (storageModel: StorageModel?) in
        guard let storageModel = storageModel as? [StorageModel],
              let repositoryModel = self?.mapper.mapFromStorage(model: storageModel) else {
          observable.onError(OtherError())
          return
        }
        
        observable.onNext(repositoryModel)
        observable.onCompleted()
      }
      
      return Disposables.create()
    }
  }
}
