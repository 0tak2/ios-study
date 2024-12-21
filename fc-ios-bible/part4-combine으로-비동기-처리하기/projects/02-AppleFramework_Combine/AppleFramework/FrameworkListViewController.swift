//
//  FrameworkListViewController.swift
//  AppleFramework
//
//  Created by joonwon lee on 2022/04/24.
//

import UIKit
import Combine

class FrameworkListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    typealias Item = AppleFramework
    enum Section {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    let list = CurrentValueSubject<[AppleFramework], Never>(AppleFramework.list)
//    @Published var list: [AppleFramework] = AppleFramework.list
    
    // Combine
    var subscriptions = Set<AnyCancellable>()
    let didSelect = PassthroughSubject<AppleFramework, Never>()
    
    // Data, Presentation, Layout
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        
        // data
//        applySectionItems(list) // 아래에서 바로 방출되니 여기서 안해줘도 된다.
        bind()
    }
    
    private func configureCollectionView() {
        // presentation
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FrameworkCell", for: indexPath) as? FrameworkCell else {
                return nil
            }
            cell.configure(item)
            return cell
        })
        
        // layer
        collectionView.collectionViewLayout = layout()
        
        // delegate
        collectionView.delegate = self
    }
    
    private func applySectionItems(_ items: [Item], to section: Section = .main) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([section])
        snapshot.appendItems(items, toSection: section)
        dataSource.apply(snapshot)
    }
    
    private func bind() {
        // input - 사용자 인텐트에 대한 처리
        // - 셀이 선택되었을 때 처리
        didSelect
            .receive(on: RunLoop.main) // UI 업데이트를 위해 메인 쓰레드에서 수행하도록 지정 - 다만 주석처리해도 앱이 크래시되거나 하지는 않았다. 78라인도 마찬가지.
            .print("[didSelect] ") // debug
            .sink { [unowned self] framework in // TODO: unowned? weak랑은 다른건가?
            let sb = UIStoryboard(name: "Detail", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "FrameworkDetailViewController") as! FrameworkDetailViewController
             vc.framework = framework
            
            self.present(vc, animated: true)
        }.store(in: &subscriptions)
        
        // output - 상태 변경에 의한 UI 업데이트 처리
        // - items가 업데이트 되었을 때 뷰를 업데이트
        list
            .receive(on: RunLoop.main)
            .print("[items] ")
            .sink { [unowned self] list in
            self.applySectionItems(list)
        }.store(in: &subscriptions)
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        let spacing: CGFloat = 10
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalWidth(0.33))
        let itemLayout = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.33))
        let groupLayout = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: itemLayout, count:   3)
        groupLayout.interItemSpacing = .fixed(spacing)
        
        // Section
        let section = NSCollectionLayoutSection(group: groupLayout)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        section.interGroupSpacing = spacing
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension FrameworkListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let framework = list.value[indexPath.item]
        print(">>> selected: \(framework.name)")
        didSelect.send(framework)
    }
}
