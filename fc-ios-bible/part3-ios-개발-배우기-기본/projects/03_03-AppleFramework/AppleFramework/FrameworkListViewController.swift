//
//  FrameworkListViewController.swift
//  AppleFramework
//
//  Created by 임영택 on 12/11/24.
//

import UIKit

class FrameworkListViewController: UIViewController {
    let data: [AppleFramework] = AppleFramework.list
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 네비게이션 컨트롤러
        navigationController?.navigationBar.topItem?.title = "🍎 애플 프레임워크"
        
        // 컬렉션 뷰 -> Data, Presentation, Layout
        collectionView.dataSource = self
        collectionView.delegate = self
        
        if let flowlayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowlayout.estimatedItemSize = .zero // None
        }
        
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FrameworkListViewController: UICollectionViewDataSource {
    // 아이템의 개수가 몇 개인지
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    // 어떻게 한 셀을 포현할 것인지
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FrameworkCollectionViewCell", for: indexPath) as? FrameworkCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(data[indexPath.item])
        
        return cell
    }
}

extension FrameworkListViewController: UICollectionViewDelegateFlowLayout {
    // 셀들을 어떻게 배치할지
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        /*
            cell     cell     cell
         x [    ] v [    ] v [    ] x
         padding  space    space    padding
         */
        
        let interItemSpacing: CGFloat = 10
        let padding: CGFloat = 16
        
        // 컬럼 세 개
//        let width = (collectionView.bounds.width - interItemSpacing * 2 - padding * 2) / 3 // 한 셀의 너비는 전체 컬렉션뷰 너비에서 셀 사이의 간격과 좌우 패딩을 제외한 길이를 3으로 나눈 값
        // 컬럼 두 개
        // let width = (collectionView.bounds.width - interItemSpacing * 1 - padding * 2) / 2
        // 컬럼 네 개
         let width = (collectionView.bounds.width - interItemSpacing * 3 - padding * 2) / 4
        
        let height = width * 1.5
        
        return CGSize(width: width, height: height)
    }
    
    // 셀 간 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    // 로우 간 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension FrameworkListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(data[indexPath.item])
    }
}
