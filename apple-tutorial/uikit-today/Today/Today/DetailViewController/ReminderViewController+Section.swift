//
//  ReminderViewController+Section.swift
//  Today
//
//  Created by 임영택 on 12/18/24.
//

import Foundation

extension ReminderViewController {
    enum Section: Int, Hashable {
        case view
        case title
        case date
        case notes
        
        var name: String {
            switch self {
            case .view: return ""
            case .title:
                return NSLocalizedString("제목", comment: "Title 섹션 이름")
            case .date:
                return NSLocalizedString("기한", comment: "Date 섹션 이름")
            case .notes:
                return NSLocalizedString("노트", comment: "Notes 섹션 이름")
            }
        }
    }
}
