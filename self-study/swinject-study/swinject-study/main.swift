//
//  main.swift
//  swinject-study
//
//  Created by 임영택 on 1/27/25.
//

import Foundation
import Swinject

let container = Container()

container.register(Logging.self) { _ in
    Logger()
}

container.register(RepositoryProtocol.self) { r in
    Repository(logger: r.resolve(Logging.self)!)
}
.inObjectScope(.container)

container.register(Readable.self) { r in
    ReadService(repository: r.resolve(RepositoryProtocol.self)!, logger: r.resolve(Logging.self)!)
}

container.register(Writable.self) { r in
    WriteService(repository: r.resolve(RepositoryProtocol.self)!, logger: r.resolve(Logging.self)!)
}

let reader = container.resolve(Readable.self)!
let writer = container.resolve(Writable.self)!

reader.read()
writer.write()

/**
 Logger #0 ObjectIdentifier(0x00006000028c21c0) says ... called: ReadService - read
 Logger #0 ObjectIdentifier(0x00006000028c21c0) says ... called: Repository #0 ObjectIdentifier(0x0000600003dc03c0) - fetch
 Logger #1 ObjectIdentifier(0x00006000028c2440) says ... called: WriteService - write
 Logger #0 ObjectIdentifier(0x00006000028c21c0) says ... called: Repository #0 ObjectIdentifier(0x0000600003dc03c0) - save
 */
