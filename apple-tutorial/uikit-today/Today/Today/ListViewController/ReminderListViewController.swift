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
        
        // create a new snapshot
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(Reminder.sampleData.map{ $0.id })
        
        // Apply the snapshot to the data source
        dataSource.apply(snapshot) // reflects the changes in the user interface
    }

    private func listLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped) // 섹션
        listConfiguration.showsSeparators = true
        listConfiguration.backgroundColor = .clear
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
}

