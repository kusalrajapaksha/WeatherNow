//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Kusal on 2024-01-22.
//

import Foundation
import SwiftUI

final class WeatherManager{
    
    func downloadWeatherData(cityName: String) async throws -> Data?{
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&units=Metric&APPID=\(APIManager.apiKey)") else {return nil}
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}

struct WeatherModel: Codable, Hashable{
    let location: String
    let temperature: Temperature
    let windSpeed: Double
    let humidity: Double
    let description: String
    let iconCode: String
}

struct Temperature: Codable, Hashable{
    let current: Int
    let max: Int
    let min: Int
}


class WeatherViewModel: ObservableObject{
    
    let manager = WeatherManager()
    @Published var weatherData = [WeatherModel]()
    
    func fetchInitialData() async{
        guard let model1 = await createWeatherData(cityName: "Colombo") else{return}
        guard let model2 = await createWeatherData(cityName: "London") else{return}
        guard let model3 = await createWeatherData(cityName: "Tokyo") else{return}
       
        DispatchQueue.main.async {[weak self] in
            withAnimation {
                self?.weatherData.append(model1)
                self?.weatherData.append(model2)
                self?.weatherData.append(model3)
            }
        }
        
    }
    
    func createWeatherData(cityName: String) async -> WeatherModel?{
        do{
            guard let data = try await manager.downloadWeatherData(cityName: cityName) else{return nil}
            
            if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                // Access data dynamically
                print(jsonObject)
                
                let location = jsonObject["name"] as? String ?? ""
                
                let main = jsonObject["main"] as? [String: Any]
                
                let current_temp = main?["temp"] as? Double ?? 0.0
                let max_temp = main?["temp_max"] as? Double ?? 0.0
                let min_temp = main?["temp_min"] as? Double ?? 0.0
                
                let temp_object = Temperature(current: Int(current_temp), max: Int(max_temp), min: Int(min_temp))
                
                let humidity = main?["humidity"] as? Double ?? 0.0
                
                let wind = jsonObject["wind"] as? [String: Any]
                let wind_speed = wind?["speed"] as? Double ?? 0.0
                
//                let weather = jsonObject["weather"] as? NSDictionary
//                if let weatherArray = weather{
//                    let description = weather["description"] as? String ?? "---"
//                    let iconCode = weather["icon"]
//                    print("KKK \(weatherArray)")
//                }

                
                let description = "description"
                let iconCode = "02d"
                
                
                        
                
                
                return WeatherModel(location: location, temperature:  temp_object, windSpeed: wind_speed, humidity: humidity,description: description, iconCode: iconCode)
               
            }else{
                return nil
            }
            
        }catch{
            print(error)
            return nil
        }
    }
    
}
