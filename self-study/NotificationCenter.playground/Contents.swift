import Foundation

let listener1 = Listener(1)
let listener2 = Listener(2)

let publisher = Publisher()
publisher.post("첫번쨰 알림")
publisher.post("두번쨰 알림")
publisher.post("세번쨰 알림")

final class Publisher {
    func post(_ contents: String) {
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("SomeNotification"), object: self, userInfo: ["contents": contents])
    }
}

final class Listener {
    let id: Int
    
    init(_ id: Int) {
        self.id = id
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(handler), name: Notification.Name("SomeNotification"), object: nil)
    }
    
    @objc func handler(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let contents = userInfo["contents"] as? String {
            print("[Listener#\(id)] 알림을 수신했습니다. name: \(notification.name) contents: \(contents)")
        }
    }
}
