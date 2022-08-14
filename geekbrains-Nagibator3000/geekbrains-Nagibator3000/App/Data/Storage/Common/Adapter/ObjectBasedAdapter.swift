//
//  ObjectBasedAdapter.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 09.08.2022.
//

import Foundation
import RxSwift

class ObjectBasedAdapter<RepositoryModel, StorageModel: Codable> {
    private let dataStorage: DataStorage
    private let mapper: Mapper<RepositoryModel, StorageModel>
    
    init(
        dataStorage: DataStorage,
        mapper: Mapper<RepositoryModel, StorageModel>
    ) {
        self.dataStorage = dataStorage
        self.mapper = mapper
    }
    
    func read() -> Observable<[RepositoryModel]> {
        Observable<[RepositoryModel]>.create { [weak self] observable in
            self?.dataStorage.read { (storageModel: StorageModel?) in
                let storageModel = storageModel as? [StorageModel] ?? []
                let repositoryModel = self?.mapper.mapFromStorage(model: storageModel)
                
                observable.onNext(repositoryModel!)
                observable.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    func write(model: Observable<[RepositoryModel]>) -> Observable<Bool> {
        Observable<Bool>.create { [weak self] observable in
            let _ = model
                .bind { repositoryModel in
                    let storageModel = self?.mapper.mapFromRepository(model: repositoryModel)
                    self?.dataStorage.write(object: storageModel) { comleted in
                        observable.onNext(comleted)
                        observable.onCompleted()
                    }
                }
            
            return Disposables.create()
        }
    }
    
    func clear() -> Completable {
        Completable.create { [weak self] completable in
            self?.dataStorage.clear { _ in
                completable(.completed)
            }
            
            return Disposables.create()
        }
    }
}
