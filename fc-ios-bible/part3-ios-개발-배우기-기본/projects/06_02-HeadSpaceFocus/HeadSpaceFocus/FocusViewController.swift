//
//  FocusViewController.swift
//  HeadSpaceFocus
//
//  Created by 임영택 on 12/15/24.
//

import UIKit

class FocusViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var updateButton: UIButton!
    
    private typealias Item = Focus
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    
    private var items: [Focus] = Focus.list
    
    private enum Section {
        case main
    }
    
    private lazy var datasource: DataSource = createDatasource()
    
    private var curated: Bool = false
    
    /*
     Presentation, Data, Layout
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateButton.layer.cornerRadius = 10
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        datasource.apply(snapshot)
        
        collectionView.collectionViewLayout = createLayout()
        
        setButtonTitle()
    }
    
    private func createDatasource() -> DataSource {
        let datasource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FocusCollectionViewCell", for: indexPath) as? FocusCollectionViewCell else {
                return nil
            }
            
            cell.configure(item)
            // cell.configure(self.items[indexPath.item]) // 동일 동작
            
            return cell
        }
        
        return datasource
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        // width: 그룹 너비 전체 => .fractionalWidth(1)
        // height: 기본 50 예상. 그러나 컨텐츠에 따라 계산 필요 => .estimated(50)
        //         꼭 인자가 50일 필요는 없음
        //         + .absolute(_)로 절대값을 넣어줄 수도 있음.
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        section.interGroupSpacing = 10 // 그룹 사이의 간격
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func setButtonTitle() {
        let buttonTitle = curated ? "See All" : "Recommendation"
        updateButton.setTitle(buttonTitle, for: .normal)
    }
    
    @IBAction func updateButtonTapped(_ sender: Any) {
        curated.toggle()
        
        self.items = curated ? Focus.recommendations : Focus.list
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        datasource.apply(snapshot)
        
        setButtonTitle()
    }
}
