//
//  CityWeatherDetails.swift
//  WeatherApp
//
//  Created by Kusal on 2024-01-30.
//

import SwiftUI

struct CityWeatherDetails: View {
    
    let model: WeatherModel
    
    var body: some View {
        VStack{
            Text(model.location)
                .font(.title)
//                .background(Color.red)
                .padding(100)
                .fontWeight(.heavy)
            
            HStack{
//                Image("")
                Text(String(model.temperature) + "°C")
                    .font(.title3)
    //                .background(Color.red)
                    .fontWeight(.medium)
            }
            Spacer()
           
        }
       
    }
}

#Preview {
    CityWeatherDetails(model: WeatherModel(location: "New York", temperature: 23, windSpeed: 23.0, humidity: 23.0,description: "",iconCode: ""))
}
