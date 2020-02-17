//
//  ViewController.swift
//  Weather aplication
//
//  Created by Pavel Khatenovsky on 16/12/2019.
//  Copyright © 2019 Pavel Khatenovsky. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var cityInputTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getWeather(cityName: "Minsk")
    }
    
    @IBAction func searchButtonClick(_ sender: Any) {
        getWeather(cityName: cityInputTextField.text!)
        cityInputTextField.resignFirstResponder()
    }
    
    func getWeather(cityName: String) {
       
        let url = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=152acdd8b86aa8b1052d49ad07e2f9cf"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            if response.data != nil {
                do {
                    let currentWeatherDictionary = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: Any]
                    
                    let cod = currentWeatherDictionary?["cod"] as? String
                    
                    if cod != "404" {
                        let city = currentWeatherDictionary!["name"]
                        self.cityLabel.text = city as? String
                        
                        let main = currentWeatherDictionary!["main"] as? [String: Any]
                        let temp = main?["temp"] as? Double
                        let c = temp! - 273.00
                        let roundedTemp = Int(c)
                        self.tempLabel.text = "\(roundedTemp)°"
                        
                        
                        let weather = currentWeatherDictionary!["weather"] as? [[String: Any]]
                        let weatherDict = weather?[0]
                        let descriptionn = weatherDict!["description"] as! String
                        self.descriptionLabel.text = descriptionn
                        
                        let wind = currentWeatherDictionary!["wind"] as? [String: Double]

                        let speed = wind!["speed"]!
                        let windSpeed = "Скорость ветра: \(speed) м/с"
                        self.windLabel.text = windSpeed
                        
                        self.weatherImageView.image = UIImage(named: "01d")
                        
                        let icon = weatherDict!["icon"] as! String
                        self.weatherImageView.image = UIImage(named: "\(icon)")
                        
                    } else {
                        self.cityLabel.text = "Город не найден"
                        self.tempLabel.text = ""
                        self.windLabel.text = ""
                        self.descriptionLabel.text = ""
                        self.weatherImageView.image = nil
                    }
                } catch {}
            }
        }
    }
}
