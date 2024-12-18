//
//  ViewController.swift
//  Today
//
//  Created by 임영택 on 12/18/24.
//

import UIKit

class ReminderListViewController: UICollectionViewController {    
    var dataSource: DataSource!
    var reminders: [Reminder] = Reminder.sampleData
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let listLayout = listLayout()
        collectionView.collectionViewLayout = listLayout
        
        // Cell registration specifies how to configure the content and appearance of a cell
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        
        // Create a new data source
        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
        
        updateSnapshot()
    }
    
    /**
     특정 아이템이 선택되었을 때 이 아이템이 선택되어도 되는 아이템인지 확인하고자 호출됨
     */
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let id = reminders[indexPath.item].id
        pushDetailViewForReminder(withId: id) // 디테일 뷰를 네비게이션 컨트롤러에 push
        return false // 선택됨을 UI상에 표시하지 않음
    }
    
    func pushDetailViewForReminder(withId id: Reminder.ID) {
        let reminder = getReminder(withdId: id)
        let vc = ReminderViewController(reminder: reminder)
        navigationController?.pushViewController(vc, animated: true) // 네비게이션 컨트롤러는 스택처럼 작동함
    }

    private func listLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped) // 섹션
        listConfiguration.showsSeparators = true
        listConfiguration.backgroundColor = .clear
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
}

