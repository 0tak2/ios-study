# 리스트 및 그리드 뷰 구성해보기

## 컬렉션뷰 이해하기

### 개요

- 리스트
- 그리드

### 구현

- UIKit에서는 UITableView, UICollectionView를 이용
- UITableView
  - 여러 데이터를 싱글 컬럼으로 나열하는 뷰
- UICollectionView
  - 여러 데이터를 여러 컬럼 또는 커스텀된 레이아웃으로 표현해주는 뷰 (예: 그리드뷰)
- 둘 다 학습 난이도는 비슷하며, UICollectionView의 자유도가 조금 더 높음. 강의에서는 UICollectionView를 다룸

### UICollectionView

- ⭐️ Data, Presentation, Layout만 알려주면 원하는 뷰를 그릴 수 있다.
- Data: 표현할 데이터
- Presentation: 하나의 셀에서 데이터를 어떻게 표현할지
- Layout: 여러 셀들을 어떤 레이아웃으로 배치할지

### 참고문서

- https://developer.apple.com/documentation/uikit/uitableview
- https://developer.apple.com/documentation/uikit/uicollectionview
- https://developer.apple.com/videos/play/wwdc2019/220/
- https://developer.apple.com/videos/play/wwdc2020/10045


## StockRank

- CollectionView를 오토 레이아웃으로 꽉 차게 넣고, 셀 하나를 그린다.
  - 셀 내부에 여러 오브젝트를 넣고 오토 레이아웃으로 배치한다.
  - 셀과의 관계에 따라 제약조건을 줘도 되고, 인접 오브젝트와의 관계에 따라 제약조건을 줘도 된다.
- 뷰 컨트롤러에 CollectionView를 프로퍼티로 연결한다.
  - viewDidLoad에서 해당 컬렉션 뷰의 dataSource와 delegate를 self(뷰 컨트롤러)로 둔다.
  - 뷰 컨트롤러가 UICollectionViewDataSource, UICollectionViewDelegateFlowLayout 프로토콜을 준수하도록 익스텐션으로 구현해준다.
    - UICollectionViewDataSource: CollectionView::dataSource의 타입
      - `collectionView(_:numberOfItemsInSection:)`: 특정 섹션에 대해 데이터 수가 몇 개인지 반환한다. 우리는 섹션 한 개이므로 단순히 stockList의 count를 반환
      - `collectionView(_:cellForItemAt:)`: 특정 인덱스에 해당하는 셀을 어떻게 표현할 것인지. 
    - UICollectionViewDelegateFlowLayout: CollectionView::Delegate의 타입인 UICollectionViewDelegate를 준수하는 하위 프로토콜
      - `collectionView(_:layout:sizeForItemAt:)`: 하나의 셀의 사이즈를 반환한다. 우리는 컬럼 한 개의 리스트를 만들고 있기 때문에 다음과 같이 작성한다.   
        ```swift
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            // width는 컬렉션 뷰의 너비와 같다. 컬럼이 1개이기 때문.
            // height는 80
            return CGSize(width: collectionView.bounds.width, height: 80) // UIView::bounds는 사각형 객체의 위치와 사이즈 정보를 담고 있다.
        }
        ```
- UICollectionViewCell을 상속받는 StockRankCollectionViewCell 클래스를 만들고, 스토리보드에서 셀의 뷰 컨트롤러로 연결해준다. 또한 셀에 대해 어트리뷰트 인스펙터를 열면 리유저뷸 뷰에 대한 식별자를 지정할 수 있다. 클래스 이름을 그대로 주면 편하다. (StockRankCollectionViewCell)
- 어시스턴트 뷰에서 StockRankCollectionViewCell에 각종 오브젝트를 연결해준다.   
  ```swift
  @IBOutlet weak var rankLabel: UILabel!
  @IBOutlet weak var companyIconImageView: UIImageView!
  @IBOutlet weak var companyNameLabel: UILabel!
  @IBOutlet weak var companyPriceLabel: UILabel!
  @IBOutlet weak var diffLabel: UILabel!
  ```
- Stock 구조체를 받으면 해당 셀의 UI를 업데이트해주는 메서드 configure(_)를 구현한다.   
  ```swift
  func configure(_ stock: StockModel) {
      rankLabel.text = "\(stock.rank)"
      companyIconImageView.image = UIImage(named: stock.imageName)
      companyNameLabel.text = stock.name
      companyPriceLabel.text = "\(convertToCurrencyFormat(price: stock.price))원"
      diffLabel.text = "\(stock.diff)%"
  }
  
  func convertToCurrencyFormat(price: Int) -> String {
      let numberFormatter = NumberFormatter()
      numberFormatter.numberStyle = .decimal
      numberFormatter.maximumFractionDigits = 0
      return numberFormatter.string(from: NSNumber(value: price)) ?? ""
  }
  ```
  - [NumberFormatter](https://developer.apple.com/documentation/foundation/numberformatter/)를 이용해 가격을 포매팅하도록 구현했다.
- 뷰 컨트롤러로 돌아가 `collectionView(_:cellForItemAt:)`를 구현해준다.
  - CollectionView::dequeueReusableCell(withReuseIdentifier:for:)를 이용해 해당 컬렉션 뷰에 등록된 재사용 셀을 가져온다. 식별자를 위에서 등록한 `StockRankCollectionViewCell`으로 준다.
  - 이때 타입이 UICollectionViewCell이다. 우리가 만든 커스텀 클래스인 StockRankCollectionViewCell로 캐스팅한다.
  - 구현해둔 UI 업데이트 메서드 StockRankCollectionViewCell::configure를 호출한다. 인자로는 stockList[indexPath.item]를 넘긴다.
    - indexPath는 해당 셀의 섹션, 로우, 로우 내에서 몇 번째인지(.item) 등을 표현한다.
  ```swift
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      // CollectionView에 등록된 재사용 가능한 셀을 가져오고, 상속한 클래스로 캐스팅한다.
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StockRankCollectionViewCell", for: indexPath) as? StockRankCollectionViewCell else {
          return UICollectionViewCell()
      }
      
      cell.configure(stockList[indexPath.item]) // IndexPath에는 섹션이 무엇인지, 그리고 해당 섹션의 몇 번쨰 아이템인지 정보가 담겨져 있다.
      
      return cell
  }
  ```

### 더 공부할 것

- 스위프트에서의 [타입 캐스팅](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/typecasting)
- [NumberFormatter](https://developer.apple.com/documentation/foundation/numberformatter/)

### 과제

- diff가 음수이면 파란색으로 표시
  - StockRankCollectionViewCell::configure에 한 줄을 추가했다.
    ```swift
    // diffLabel.textColor = stock.diff > 0 ? .red : .blue
    diffLabel.textColor = stock.diff > 0 ? .systemRed : .systemBlue
    ```

![](imgs/stock-final.png)
