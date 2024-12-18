//
//  ReminderListViewController+Actions.swift
//  Today
//
//  Created by 임영택 on 12/18/24.
//

import UIKit

extension ReminderListViewController {
    // target-action 패턴
    @objc func didPressDoneButton(_ sender: ReminderDoneButton) { // @objc -> Objective C에서도 사용 가능한 메서드
        guard let reminderId = sender.id else { return }
        completeReminder(withId: reminderId)
    }
}
