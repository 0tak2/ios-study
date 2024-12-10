//
//  WeatherViewController.swift
//  SimpleWeather
//
//  Created by 임영택 on 12/10/24.
//

import UIKit

class WeatherViewController: UIViewController {
    let cities = ["Seoul", "Tokyo", "LA", "Seattle"]
    let weathers = ["cloud.fill", "wind", "sun.max.fill", "cloud.snow.fill", "sun.snow.fill"]
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func changeButtonTapped(_ sender: Any) {
        cityLabel.text = cities.randomElement()!
        weatherImageView.image = UIImage(systemName: weathers.randomElement()!)?
            .withRenderingMode(.alwaysOriginal) // monochrome이 아닌 multicolor로 렌더링되도록 변경
        
        let randomTemp = Int.random(in: -8..<10)
        temperatureLabel.text = "\(randomTemp)°"
        
        print("도시, 온도, 날씨 변경")
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
