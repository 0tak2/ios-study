//
//  ServiceA.swift
//  swinject-study
//
//  Created by 임영택 on 1/27/25.
//

class ReadService: Readable {
    let repository: RepositoryProtocol
    let logger: Logging
    
    init(repository: RepositoryProtocol, logger: Logging) {
        self.repository = repository
        self.logger = logger
    }
    
    func read() {
        logger.log("called: ReadService - read")
        repository.fetch()
    }
}
