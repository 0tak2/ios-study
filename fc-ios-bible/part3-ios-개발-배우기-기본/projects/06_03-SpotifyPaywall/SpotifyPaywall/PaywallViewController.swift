//
//  PaywallViewController.swift
//  SpotifyPaywall
//
//  Created by joonwon lee on 2022/04/30.
//

import UIKit

// https://developer.spotify.com/documentation/general/design-and-branding/#using-our-logo
// https://developer.apple.com/documentation/uikit/nscollectionlayoutsectionvisibleitemsinvalidationhandler
// 과제: 아래 애플 샘플 코드 다운받아서 돌려보기  https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/implementing_modern_collection_views

class PaywallViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    let bannerInfos: [BannerInfo] = BannerInfo.list
    let colors: [UIColor] = [.systemPurple, .systemOrange, .systemPink, .systemRed]
    
    // 1. Presentation: DataSource
    enum Section {
        case main
    }
    
    typealias Item = BannerInfo
    
    private lazy var datasource: UICollectionViewDiffableDataSource<Section, Item> = createDatasource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageControl.numberOfPages = bannerInfos.count
        
        // 2. Data: Snapshot
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(bannerInfos, toSection: .main)
        datasource.apply(snapshot)
        
        // 3. Layout: Compositional Layout
        collectionView.collectionViewLayout = createLayout()
        collectionView.alwaysBounceVertical = false // 세로 스크롤 비활성화
    }
    
    private func createDatasource() -> UICollectionViewDiffableDataSource<Section, Item> {
        return UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath) as? BannerCell else {
                return nil
            }
            
            cell.configure(item)
            cell.backgroundColor = self.colors[indexPath.item] // 배경색 설정
            
            return cell
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        // section.orthogonalScrollingBehavior = .continuous // 섹션 너비에 구해받지 않고 수평 방향으로 이어서 스크롤; orthogonal: 직교, 수직/수평
        // section.orthogonalScrollingBehavior = .groupPaging // 한 번에 한 그룹씩 페이징 (왼쪽 정렬)
//        section.orthogonalScrollingBehavior = .groupPagingCentered // 한 번에 한 그룹씩 페이징 (가운데 정렬)
        collectionView.scrollDirection = .horizontal
        section.interGroupSpacing = 20
        section.visibleItemsInvalidationHandler = { (visibleItems, scrollOffset, layoutEnvironment) in
//            print("items = \(visibleItems)")
//            print("offset = \(scrollOffset)")
//            print("env = \(layoutEnvironment)")
//            print("env->container->contentSize = \(layoutEnvironment.container.contentSize)")
//            print("offset.x / contentSize.width = \(scrollOffset.x / layoutEnvironment.container.contentSize.width)")
            let contentWidth = layoutEnvironment.container.contentSize.width
            let ratioAdjusted = (scrollOffset.x / contentWidth) + 0.1 // 실제로 해보니 마지막 페이지의 경우 2.4 정도에 걸려서 인덱스가 변하지 않았다. 0.1 정도를 더해 보정해줬다.
            let index = Int(ratioAdjusted.rounded())
            print("current index = \(index)")
            self.pageControl.currentPage = index
        }
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
