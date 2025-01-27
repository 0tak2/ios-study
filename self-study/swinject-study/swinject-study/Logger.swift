//
//  Logger.swift
//  swinject-study
//
//  Created by 임영택 on 1/27/25.
//

class Logger: Logging {
    static var counter = 0
    
    let id: Int
    
    init() {
        self.id = Logger.counter
        Logger.counter += 1
    }
    
    func log(_ message: String) {
        print("Logger #\(id) \(ObjectIdentifier(self)) says ... \(message)")
    }
}
