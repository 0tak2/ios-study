//
//  QuickFocusListViewController.swift
//  HeadSpaceFocus
//
//  Created by 임영택 on 12/17/24.
//

import UIKit

class QuickFocusListViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    let breathingList = QuickFocus.breathing
    let walkingList = QuickFocus.walking
    
    enum Section: CaseIterable { // CaseIterable -> allCases
        case breathing
        case walking
        
        var title: String {
            switch self {
            case .breathing: return "Breathing exercises"
            case .walking: return "Mindful walks"
            }
        }
    }
    typealias Item = QuickFocus
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        // Presentation
        self.dataSource = initDataSource()
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let headerView = self.collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "QuickFocusHeaderCollectionReusableView", for: indexPath) as? QuickFocusHeaderCollectionReusableView else {
                return UICollectionReusableView()
            }
            
            let section = Section.allCases[indexPath.section]
            
            headerView.configure(title: section.title)
            
            return headerView
        }
        
        // Data
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(breathingList, toSection: .breathing)
        snapshot.appendItems(walkingList, toSection: .walking)
        dataSource.apply(snapshot)
        
        // Layout
        collectionView.collectionViewLayout = initLayout()
        
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    private func initDataSource() -> UICollectionViewDiffableDataSource<Section, Item> {
        return UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuickFocusCollectionViewCell", for: indexPath) as? QuickFocusCollectionViewCell else {
                return nil
            }
            
            cell.configure(item)
            
            return cell
        }
    }
    
    private func initLayout() -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .estimated(50)) // 높이가 컨텐츠마다 다름
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 30, leading: 20, bottom: 30, trailing: 20)
        section.interGroupSpacing = 20
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(20))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
