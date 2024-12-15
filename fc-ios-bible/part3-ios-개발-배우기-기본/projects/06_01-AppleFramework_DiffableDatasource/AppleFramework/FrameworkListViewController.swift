//
//  FrameworkListViewController.swift
//  AppleFramework
//
//  Created by joonwon lee on 2022/04/24.
//

import UIKit

class FrameworkListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let list: [AppleFramework] = AppleFramework.list
    
    private lazy var datasource: UICollectionViewDiffableDataSource<Section, Item> = createDatasource()
    
    typealias Item = AppleFramework // 가독성을 위해 AppleFramework 타입을 Item 타입 앨리어스로 잡아준다.
    enum Section { // 열거형은 그 자체로 Hashable하다
        case main
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        collectionView.dataSource = self
        collectionView.delegate = self
        
        navigationController?.navigationBar.topItem?.title = "☀️ Apple Frameworks"
        
        // Data, Presentation, Layout 새로운 방법
        // - diffable dataource -> Data, Presentation
        // - compositional layout -> Layout
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(list, toSection: .main)
        datasource.apply(snapshot)
        
        collectionView.collectionViewLayout = createLayout()
    }
    
    private func createDatasource() -> UICollectionViewDiffableDataSource<Section, Item> {
        let datasource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FrameworkCell", for: indexPath) as? FrameworkCell else {
                return nil
            }
            
            cell.configure(item)
            
            return cell
        })
        
        return datasource
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        /*
         section
           item item item
           [ ]  [ ]  [ ] -> group
           [ ]  [ ]  [ ] -> group
           [ ]  [ ]  [ ] -> group
         */
        
        // fractionalWidth, fractionalHeight: 자신을 포함하는 그룹/섹션에 대해 상대적인 너비, 높이를 지정
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalHeight(1)) // 아이템 너비 = 그룹 전체 너비의 1/3, 아이템 높이 = 그룹 전체 높이와 동일
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.33)) // 그룹 너비 = 섹션 전체 너비와 동일, 그룹 높이 = 섹션 전체 너비의 1/3
         let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3) // Deprecated
        // let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 3) // >= iOS 16
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        let layout =  UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}

extension FrameworkListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let framework = list[indexPath.item]
        print(">>> selected: \(framework.name)")
    }
}
