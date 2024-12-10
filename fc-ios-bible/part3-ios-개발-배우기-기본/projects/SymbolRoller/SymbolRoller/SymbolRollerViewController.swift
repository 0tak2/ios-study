//
//  SymbolRollerViewController.swift
//  SymbolRoller
//
//  Created by 임영택 on 12/10/24.
//

import UIKit

class SymbolRollerViewController: UIViewController {
    let symbols: [String] = ["sun.min", "moon", "cloud", "wind", "snowflake"]
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    /*
     각종 라이프사이클에 따라 호출되는 메서드들
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // 메모리에 뷰가 로드되었을 때 호출됨
        
//        print("viewDidLoad")
        
        reloadSymbol()
        button.tintColor = .systemPink
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 화면이 곧 보여질 때 호출됨
        
//        print("viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 화면이 보여졌을 때 호출됨
        
//        print("viewDidAppear")
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
//        print("tapped!")
        reloadSymbol()
    }
    
    /**
     symbols에서 하나의 문자열을 추출해 imageView와 label에 지정한다.
     */
    func reloadSymbol() {
        let symbol = symbols.randomElement()! // symbols에 원소가 이미 들어가 있기 때문에 Nil일 수 없으므로 강제 언래핑
        imageView.image = UIImage(systemName: symbol)
        label.text = symbol
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
