# Combine 실습

## 실습 1 - 플레이그라운드에서 Combine 실습

[code](../projects/Hello%20Combine.playground/)

## 실습 2 - 이전 프로젝트 AppleFramework에 Combine 도입

- 메인 뷰인 `FrameworkListViewController`를 리팩토링한다
- 주요 패턴: Subject를 프로퍼티로 정의하고, 메시지를 보내거나 상태가 변경되는 지점에서 해당 Subject에 send를 통해 값을 주입해 방출,  
  `bind()`라는 메서드를 만들고, 메시지가 수신되거나 상태 변경이 되면 수행되어야 하는 후속 작업을 sink를 통해 클로져로 전달하는 방식  
  `bind()`는 `viewDidLoad()`에서 호출되어 준비됨
- Combine을 이용하면 다양한 설계가 가능할 것 같다. 다른 예제도 찾아볼 필요가 있다.

### 사용자 인텐트 처리

- 기존: `UICollectionViewDelegate`의 `collectionView(_:didSelectItemAt:)`에서 선택된 셀이 가리키는 모델을 찾고, FrameworkDetailViewController를 초기화하고 configure, present를 통해 모달로 띄우는 것까지 모두 수행
- 개선
  - 프로퍼티 추가: `let didSelect = PassthroughSubject<AppleFramework, Never>()`
  - `collectionView(_:didSelectItemAt:)`에서는 값만 방출
    ```swift
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let framework = list.value[indexPath.item]
        print(">>> selected: \(framework.name)")
        didSelect.send(framework)
    }
    ```
  - `bind()`에서 UI 업데이트
    ```swift
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
        
        // ...
    }
    ```

### 아이템 데이터와 뷰 동기화

- 기존: `list` 프로퍼티를 UI에 반영하려면, 그때마다 dataSource에 apply 해야 했음
- 개선
  - `list`를 CurrentValueSubject로 변경
    ```swift
    let list = CurrentValueSubject<[AppleFramework], Never>(AppleFramework.list)
    ```
  - `bind()`에서 UI 업데이트
    ```swift
    private func bind() {
        // ...
        
        // output - 상태 변경에 의한 UI 업데이트 처리
        // - items가 업데이트 되었을 때 뷰를 업데이트
        list
            .receive(on: RunLoop.main)
            .print("[items] ")
            .sink { [unowned self] list in
            self.applySectionItems(list)
        }.store(in: &subscriptions)
    }
    ```
  - `bind()`는 `viewDidLoad()`에서 우선 호출되고, 이때 list는 CurrentValueSubject로서, 초깃값을 방출하기 때문에 원래 `viewDidLoad()`에 있던 초기 데이터 apply 작업도 삭제해도 됨

### 과제

- `FrameworkDetailViewController`를 개선해보기
- 해본 것
  1. Subject를 프로퍼티로 잡는다
    ```swift
    private var subscriptions = Set<AnyCancellable>()
    private let shouldShowUrl = PassthroughSubject<URL, Never>()
    private let selectedFramework = CurrentValueSubject<AppleFramework, Never>(
        AppleFramework(name: "Unknown", imageName: "", urlString: "", description: ""))
    ```
  2. bind()를 작성하고 방출된 값을 처리한다
    ```swift
    private func bind() {
        // input
        shouldShowUrl
            .receive(on: RunLoop.main)
            .print("[shouldShowUrl] ")
            .sink { [unowned self] url in
                let safari = SFSafariViewController(url: url)
                self.present(safari, animated: true)
            }
            .store(in: &subscriptions)
        
        // output
        selectedFramework
            .receive(on: RunLoop.main)
            .print("[selectedFramework] ")
            .sink { [unowned self] framework in
                self.imageView.image = UIImage(named: framework.imageName)
                self.titleLabel.text = framework.name
                self.descriptionLabel.text = framework.description
            }
            .store(in: &subscriptions)
    }
    ```
- 해설
  - 강의에서는 URL 객체가 아닌 Framework 객체를 제네릭으로 줬다
    - 확실히 탭에 대한 처리의 요구사항이 확장될 수 있으므로 URL을 명시해서 넘기는 것보다 Framework를 넘기는 게 좋아보인다.
  - framework는 CurrentValueSubject로 잡지 않고, AppleFramework로 남기되, @Published로 래핑하는 방법도 소개했다.
    - FrameworkListViewController에서 FrameworkDetailViewController를 초기화한 후 framework 프로퍼티를 할당해 데이터를 주입해주는데, CurrentValueSubject로 변경하면, send(_:)를 호출하는 식으로 변경해야 한다.
    - @Published로 래핑하면 값은 그대로 읽고 쓰고, Publisher 접근 시에만 $ 사인으로 참조하면 되기 때문에 더 편리하긴 할 것 같다.

  ```swift
  import UIKit
  import SafariServices
  import Combine

  class FrameworkDetailViewController: UIViewController {
      @IBOutlet weak var imageView: UIImageView!
      @IBOutlet weak var titleLabel: UILabel!
      @IBOutlet weak var descriptionLabel: UILabel!
      
      private var subscriptions = Set<AnyCancellable>()
      private let buttonTapped = PassthroughSubject<AppleFramework, Never>()
      @Published var framework = AppleFramework(name: "Unknown", imageName: "", urlString: "", description: "")
      
      override func viewDidLoad() {
          super.viewDidLoad()
          bind()
      }
      
      private func bind() {
          // input
          buttonTapped
              .receive(on: RunLoop.main)
              .print("[buttonTapped] ")
              .compactMap({ (framework: AppleFramework) in
                  URL(string: framework.urlString) // compactMap이므로 nil이면 뒤로 방출되지 않는다
              })
              .sink { [unowned self] (url: URL) in
                  let safari = SFSafariViewController(url: url)
                  self.present(safari, animated: true)
              }
              .store(in: &subscriptions)
          
          // output
          $framework
              .receive(on: RunLoop.main)
              .print("[selectedFramework] ")
              .sink { [unowned self] framework in
                  self.imageView.image = UIImage(named: framework.imageName)
                  self.titleLabel.text = framework.name
                  self.descriptionLabel.text = framework.description
              }
              .store(in: &subscriptions)
      }
      
      @IBAction func learnMoreTapped(_ sender: Any) {
          buttonTapped.send(framework)
      }
  }

  ```

## 더 찾아본 것

- [`weak`](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/automaticreferencecounting#Weak-References)과 [`unowned`](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/automaticreferencecounting#Unowned-Optional-References)
  - 강의에서는 sink의 클로져에서 self에 접근하는 경우 `unowned` 키워드를 사용했다. 얼마 전 Apple의 UIKit 튜토리얼에서는 이런 식으로 @escaping 클로져에서 self를 참조할 때 `weak` 키워드를 사용했다.
  - 둘 다 strong reference로 인한 순환참조를 막기 위해 사용된다.
  - 다만 weak으로 캡쳐하게 되면 Optional 타입으로 값을 취급하게 되고, unowned로 캡쳐하게 되면 강제로 언래핑하여 취급하게 된다는 차이가 있다.
  
  &nbsp;

  - 이 차이를 이해하려면, GC 없이 ARC로 메모리를 관리하는 swift의 특성을 이해해야한다.
    - 익숙한 Java와 같이 GC가 별도 쓰레드로 돌게 되는 경우, 순환참조가 있더라도 사용되지 않는 객체는 언젠가 해제된다. GC 알고리즘에 따라 차이는 있지만, 흔히 Mark and Sweep이라고 하는, Root에서 시작해 그래프 탐색하며 필요 없는 객체를 해제하는 식의 작업이 진행되기 때문이다.
    - 그러나 Swift에서는 참조 카운트를 세면서, 0이 될 때 해제하는 식으로 메모리 관리를 자동으로 수행한다.
    - 이 경우 서로 순환참조하는 객체가 있다면 참조 카운트가 항상 최소 1을 유지하게 되어 해제되지 못하고 메모리 누수가 발생한다.
    - Swift에서 클로져는 일급객체로, 자유롭게 메모리에 할당될 수 있으며, 여기에는 자신이 정의되었던 컨텍스트에서 클로져 외부에 있던 객체에 대한 레퍼런스가 살아있을 수 있다. (captured) -> 두 클래스의 인스턴스가 서로 순환참조하듯, 클로져 자신이 정의된 컨텍스트의 외부 객체와 클로져 자신이 순환참조하는 경우가 발생할 수 있다.
    - 이런 경우는 특정 클래스의 프로퍼티로 정의된 클로져거나, 다른 클로져에 `@escaping` 인자로 넘겨지는 클로져일 때 발생 가능하다.

  &nbsp;

  - 이런 경우 위와 같은 strong reference를 피해야 하며, 이때 사용하는 키워드가 `weak`과 `unowned`이다.
    - 이들 키워드들 사용하게 되면 참조한 객체에 대한 참조 카운트를 증가시키지 않는다.
    - 다만 그렇게 되면, 사실 클로져는 아직 메모리에 남아 실행되는 시점인데 클로져에 캡쳐된 weak reference가 가리키는 객체는 이미 할당 해제되었을 가능성이 있다.
    - 따라서 기본적으로 weaK 키워드가 붙은 객체는 Optional로 취급된다.
    - 하지만, 경우에 따라 특정 클로져에 캡쳐한 레퍼런스가, 클로져가 실행되는 시점에 무조건 잔존해있다고 보장할 수 있는 경우가 있다. 이럴 때에는 `unowned` 키워드를 쓴다.  
      문서에서는 Customer 클래스와 거기에 소유된 CreditCard 클래스를 예시로 든다. Customer 클래스가 deinit된 상태라면, CreditCard 클래스가 참조될 가능성은 없다는 가정이다.  
      이럴 때에는 Optional로 취급하는 것이 번거롭고 가독성을 해칠 수 있으니 대상 레퍼런스를 강제 언래핑하는 `unowned`가 도움이 될 수 있다.
    - 다만 `unowned`를 사용할 때에는 먼저 두 객체 간의 라이프사이클이 동일한지를 반드시 고려해야할 것이다. 참조하는 순간 nil인 경우 런타임 예외가 발생할 것이다.

  &nbsp;

  - 강의에서는 왜 `unowned`를 썼을까?
    - `unowned`는 sink의 인자로 전달된 클로져들에서 self를 캡쳐하기 위해 사용되었다.
    - 이때 self는 각 뷰 컨트롤러들이다. 뷰 컨트롤러가 해제되면? sink에 전달된 클로져가 실행될 가능성은 없다. 즉 라이프사이클이 동일하다.
    - 따라서 `unowned`를 써도 문제가 없어 보이며, 언래핑할 필요가 없어서 수고가 덜어진다.
  - Apple 튜토리얼에서는 왜 `weak`을 썼을까?
    - 처음엔 완벽했던 설계도 점차 요구사항이 변하면서 복잡도가 높아진다.
    - 당장 라이프사이클 분석에 문제가 없었더라고 해도, 나중에 어떤 이슈로 돌아올지 확답할 수는 없을 것이다.
    - 그런 맥락에서 보면 안전이라는 가치를 따른 선택이 아닐까 싶다.
    - Swift와 UIKit같은 각종 프레임워크들은 제약이 많은 듯 하면서 자유도도 높고 키워드도 많다. 최신 언어들의 기능을 제공하면서도, 개발자의 판단에 좌지우지되는 부분도 존재한다. 개발자의 책임이 C나 C++만큼 강한 것 같다는 인상이다.

  &nbsp;

  - 사족
    - `unowned`로 정의했으나, Optional 타입으로 취급할 수도 있다. [참고](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/automaticreferencecounting#Unowned-Optional-References)
    - 문서에 따르면 이런 경우는 라이프사이클이 동일한 것은 보장하지만, 비즈니스 규칙 상 nil이 될 수 있는 경우를 명시적으로 나타내는 상황인 것 같다.

  &nbsp;

  - 참고해볼만한 자료
    - [What is the difference between a weak reference and an unowned reference?](https://stackoverflow.com/questions/24011575/what-is-the-difference-between-a-weak-reference-and-an-unowned-reference)
    - [You don’t (always) need [weak self]](https://medium.com/@almalehdev/you-dont-always-need-weak-self-a778bec505ef)