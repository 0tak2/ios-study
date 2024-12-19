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
    
    @objc func didPressAddButton(_ sender: UIBarButtonItem) {
        let reminder = Reminder(title: "", dueDate: Date.now)
        let vc = ReminderViewController(reminder: reminder) { [weak self] reminder in
            self?.addReminder(reminder)
            self?.updateSnapshot()
            self?.dismiss(animated: true)
        }
        vc.isAddingNewReminder = true
        vc.setEditing(true, animated: true)
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel, target: self, action: #selector(didCancelEdit(_:)))
        vc.navigationItem.title = NSLocalizedString("새 Reminder", comment: "새 Reminder 추가 뷰 컨트롤러 타이틀")
        
        let navigationController = UINavigationController(rootViewController: vc) // 네비게이션 컨트롤러를 만들고 디테일 뷰 컨트롤러를 래핑
        present(navigationController, animated: true)
        
    }
    
    @objc func didCancelEdit(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}
