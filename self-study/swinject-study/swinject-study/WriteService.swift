//
//  WriteService.swift
//  swinject-study
//
//  Created by 임영택 on 1/27/25.
//

class WriteService: Writable {
    let repository: RepositoryProtocol
    let logger: Logging
    
    init(repository: RepositoryProtocol, logger: Logging) {
        self.repository = repository
        self.logger = logger
    }
    
    func write() {
        logger.log("called: WriteService - write")
        repository.save()
    }
}
