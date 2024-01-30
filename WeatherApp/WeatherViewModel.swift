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
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&units=Metric&APPID=9d389f5542dfa050ab5519863d41f922") else {return nil}
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}

struct WeatherModel: Codable, Hashable{
    let location: String
    let temperature: Int
    let windSpeed: Double
    let humidity: Double
    let description: String
    let iconCode: String
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
                let temperature = main?["temp"] as? Double ?? 0.0
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
                
                
                        
                
                
                return WeatherModel(location: location, temperature:  Int(temperature), windSpeed: wind_speed, humidity: humidity,description: description, iconCode: iconCode)
               
            }else{
                return nil
            }
            
        }catch{
            print(error)
            return nil
        }
    }
    
}
