//
//  OnboradingViewController.swift
//  NRCOnboarding
//
//  Created by 임영택 on 12/13/24.
//

import UIKit

class OnboradingViewController: UIViewController {
    let messageList: [OnboardingMessage] = OnboardingMessage.messages
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = .zero
        }
        
        pageControl.numberOfPages = messageList.count
    }
}

extension OnboradingViewController: UICollectionViewDataSource {
    // 전체 아이템 수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboradingCollectionViewCell", for: indexPath) as? OnboradingCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(messageList[indexPath.item])
        
        return cell
    }
}

extension OnboradingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
        return collectionView.bounds.size
    }
    
    // 셀 사이의 간격 모두 없애기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}

// UICollectionView는 UIScrollView를 상속한다
extension OnboradingViewController: UIScrollViewDelegate {
    // 스크롤뷰가 스크롤될 때마다 호출됨
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // scrollView.contentOffset로 현재 오프셋을 확인할 수 있다.
        // (x축 오프셋, y축 오프셋)
        
        print("contentOffset.x=\(scrollView.contentOffset.x) 컬렉션뷰width=\(self.collectionView.bounds.width) 현재페이지=\(scrollView.contentOffset.x / self.collectionView.bounds.width)")
    }
    
    // 스크롤뷰가 스크롤되다가 속도가 낮아져 멈추었을 때 호출됨
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / self.collectionView.bounds.width)
        self.pageControl.currentPage = index
    }
}
