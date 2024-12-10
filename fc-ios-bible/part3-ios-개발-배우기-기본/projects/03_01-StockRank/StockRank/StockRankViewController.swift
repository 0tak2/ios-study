//
//  StockRankViewController.swift
//  StockRank
//
//  Created by 임영택 on 12/10/24.
//

import UIKit

class StockRankViewController: UIViewController {
    let stockList: [StockModel] = StockModel.list
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Data, Presentation, Layout
        // Data - 어떤 데이터를 표현할까? -> stockList
        // Presentation - 셀을 어떻게 표현할까?
        // Layout - 셀들을 어떻게 배치할까?
        
        collectionView.dataSource = self // Data 알려줌
        collectionView.delegate = self // Presentation, Layout 등 알려줌
        // self(StockRankViewController)가 위 각각에 할당되려면 UICollectionViewDataSource를 준수해야함
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

extension StockRankViewController: UICollectionViewDataSource {
    /**
     몇 개의 셀이 필요한지
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stockList.count
    }
    
    /**
     각 셀을 어떻게 표현할 것인지
     */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // CollectionView에 등록된 재사용 가능한 셀을 가져오고, 상속한 클래스로 캐스팅한다.
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StockRankCollectionViewCell", for: indexPath) as? StockRankCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(stockList[indexPath.item]) // IndexPath에는 섹션이 무엇인지, 그리고 해당 섹션의 몇 번쨰 아이템인지 정보가 담겨져 있다.
        
        return cell
    }
    
    
}

extension StockRankViewController: UICollectionViewDelegateFlowLayout {
    /**
     하나의 셀의 사이즈를 알려줌
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // width는 컬렉션 뷰의 너비와 같다. 컬럼이 1개이기 때문.
        // height는 80
        return CGSize(width: collectionView.bounds.width, height: 80)
    }
}
