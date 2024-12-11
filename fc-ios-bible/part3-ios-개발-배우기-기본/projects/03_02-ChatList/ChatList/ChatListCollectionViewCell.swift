//
//  ChatListCollectionViewCell.swift
//  ChatList
//
//  Created by 임영택 on 12/11/24.
//

import UIKit

class ChatListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var chatLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // 스토리보드에서 재사용 셀이 deque될 때 호출됨
    override func awakeFromNib() {
        thumbnailImage.layer.cornerRadius = 10
    }
    
    func configure(_ chat: Chat) {
        thumbnailImage.image = UIImage(named: chat.name)
        nameLabel.text = chat.name
        chatLabel.text = chat.chat
        dateLabel.text = formattedDateString(dateString: chat.date)
    }
    
    func formattedDateString(dateString: String) -> String {
        let formatter = DateFormatter() // see: https://developer.apple.com/documentation/foundation/dateformatter
        formatter.dateFormat = "yyyy-MM-dd"
        
        // 먼저 문자열을 Date로 변환
        guard let date = formatter.date(from: dateString) else { return "" }
        
        // Date를 다시 문자열로 변환
        formatter.dateFormat = "M/d"
        return formatter.string(from: date)
    }
}
