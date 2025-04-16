//
//  DataStore.swift
//  JsonDataPersistenceExample
//
//  Created by 임영택 on 4/16/25.
//

import Foundation

final class DataStore: ObservableObject {
    private let fileName = "data.json"
    
    @Published var data: [Item] = []
    
    /**
     data를 JSON 형식으로 변환해 파일로 저장한다.
     */
    private func saveData() {
        let jsonEncoder = JSONEncoder()
        
        do {
            let jsonData = try jsonEncoder.encode(data) // 배열을 JSON 형식으로 인코딩했어요. Encodable 프로토콜을 따르고 있는 덕분이에요.
            print("인코딩 결과 - \(String(data: jsonData, encoding: .utf8))")
            
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! // 문서 디렉토리의 URL을 얻는다 see: https://developer.apple.com/documentation/foundation/filemanager/url(for:in:appropriatefor:create:)
            // .documentDirectory -> Documents/ 디렉토리를 의미합니다
            // .userDomainMask -> MacOS 환경이라면 사용자 홈 디렉토리일텐데, iOS 앱에서는 앱의 샌드박스가 됩니다. (다른 앱과 격리된 이 앱 만의 공간)
            
            let fileURL = documentsDirectory.appendingPathComponent(fileName) // 문서 디렉토리에 파일 이름을 합친 것
            print("\(fileURL)를 저장하려고 합니다.")
            
            try jsonData.write(to: fileURL) // 쓴다
        } catch {
            print("Error saving data: \(error)")
        }
    }
    
    /**
     JSON 파일을 지정한 경로에서 읽어 로드한다. 뷰가 나타나면 수행되어야 한다.
     */
    private func loadData() {
        let jsonDecoder = JSONDecoder()
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(fileName) // 문서 디렉토리에 파일 이름을 합친 것
        print("\(fileURL)를 로드하려고 합니다.")

        let fileExists = FileManager.default.fileExists(atPath: fileURL.path) // 파일이 있나 확인해요
        if !fileExists {
            print("\(fileURL.path) 파일을 찾지 못했습니다. 아마 처음 실행했나봅니다.") // 없으면 로드할 게 없으니 그냥 함수를 종료해요.
            return
        }
        
        do {
            let jsonData = try Data(contentsOf: fileURL)
            print("디코딩 결과 - \(String(data: jsonData, encoding: .utf8))")
            
            let decodedData = try jsonDecoder.decode([Item].self, from: jsonData) // 배열을 JSON으로부터 디코딩했어요. Decodable 프로토콜을 따르고 있는 덕분이에요.
            data = decodedData
        } catch {
            print("Error loading data: \(error)")
        }
    }
    
    /**
     새 Item을 추가한다.
     */
    func appendData(_ item: Item) {
        data.append(item)
        saveData() // 데이터 수정 후 바로 파일로 저장하게 했어요
    }
    
    /**
     특정 Item을 수정한다. 넘겨진 Item의 id를 읽어 리스트에서 기존 Item을 찾고,
     넘겨진 Item으로 대체한다.
     */
    func updateData(_ item: Item) {
        data = data.map { originalItem in
            if originalItem.id == item.id {
                return item
            } else {
                return originalItem
            }
        }
        saveData()
    }
    
    /**
     특정 Item을 삭제한다. 삭제할 Item의 인덱스값을 담은 IndexSet을 받는다.
     */
    func removeData(_ indexSet: IndexSet) {
        guard let index = indexSet.first else {
            return
        }
        
        data.remove(at: index)
        saveData()
    }
    
    /**
     뷰가 화면에 나타나면 실행되어야 한다. 파일로부터 data 배열을 로드한다.
     */
    func viewOnAppear() {
        loadData()
    }
}
