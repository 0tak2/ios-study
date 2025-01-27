//
//  Repository.swift
//  swinject-study
//
//  Created by 임영택 on 1/27/25.
//

class Repository: RepositoryProtocol {
    static var counter = 0
    
    let id: Int
    
    let loggger: Logging
    
    init(logger: Logging) {
        self.id = Repository.counter
        Repository.counter += 1
        self.loggger = logger
    }
    
    func save() {
        loggger.log("called: Repository #\(id) \(ObjectIdentifier(self)) - save")
    }
    
    func fetch() {
        loggger.log("called: Repository #\(id) \(ObjectIdentifier(self)) - fetch")
    }
}
