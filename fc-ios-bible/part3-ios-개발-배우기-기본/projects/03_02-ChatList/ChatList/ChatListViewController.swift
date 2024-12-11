//
//  ChatListViewController.swift
//  ChatList
//
//  Created by 임영택 on 12/11/24.
//

import UIKit

class ChatListViewController: UIViewController {
    var chatDataList: [Chat] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 데이터 정렬
        chatDataList = Chat.list.sorted {
            $0.date > $1.date
        }
        
        // Data, Presentation, Layout
        collectionView.dataSource = self // data, presentation
        collectionView.delegate = self // layout
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// Data, Presentation
extension ChatListViewController: UICollectionViewDataSource {
    // 아이템 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chatDataList.count
    }
    
    // 데이터 표현
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatListCollectionViewCell", for: indexPath) as? ChatListCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(chatDataList[indexPath.item])
        
        return cell
    }
    
    
}

// Layout
extension ChatListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 100)
    }
}
