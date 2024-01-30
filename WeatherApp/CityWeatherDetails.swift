//
//  CityWeatherDetails.swift
//  WeatherApp
//
//  Created by Kusal on 2024-01-30.
//

import SwiftUI

struct CityWeatherDetails: View {
    
    let model: WeatherModel
    
    @State private var fanRotation = 0.0
    @State private var fanDuration = 0.0
    @State private var arrowRotation = 0.0
    
    
    var body: some View {
        
        ZStack {
            LinearGradient(colors: [Color(hex: "#2E335A"),Color(hex: "#1C1B33")], startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            VStack{
                Text(model.location)
                    .font(.custom(CustomFonts.ExoBold, size: 50))
                    .minimumScaleFactor(0.5)
                    .foregroundStyle(Color.white)
    //                .background(Color.red)
                    .padding(.top, 50)
                    .fontWeight(.heavy)
                
                HStack{
                    Image("temperature")
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(width: 30,height: 30)
                        .foregroundColor(Color.white)
                    Text(String(model.temperature.current) + "°C")
                        .font(.custom(CustomFonts.ExoBold, size: 30))
        //                .background(Color.red)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.white)
                }
                
                HStack{
                    HStack(spacing: 20){
                        Text("Max: \(model.temperature.max)°C")
                            .font(.custom(CustomFonts.ExoMedium, size: 20))
                            .padding(5)
                            .background(Color.red.opacity(0.5))
                            .foregroundColor(Color.white)
                            .cornerRadius(10)
                        Text("Min: \(model.temperature.min)°C")
                            .font(.custom(CustomFonts.ExoMedium, size: 20))
                            .padding(5)
                            .background(Color.green.opacity(0.5))
                            .foregroundColor(Color.white)
                            .cornerRadius(10)
                    }
                }
                
                AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(model.iconCode)@2x.png")) { image in
                    image.resizable().offset(x: 15, y: 0)
                } placeholder: {
                    Image("windy-weather")
                        .resizable()
                        .frame(width: 150,height: 150)
                       
                        .foregroundColor(.white)
                        .offset(x: 15, y: 0)
                }
                .frame(width: 150,height: 150)
                
                Text(model.description)
                    .font(.custom(CustomFonts.ExoMedium, size: 30))
    //                .background(Color.red)
                    .fontWeight(.medium)
                    .foregroundColor(Color.white)
                
                HStack{
                    Text("HUMIDITY")
                        .font(.custom(CustomFonts.ExoMedium, size: 20))
                        .fontWeight(.medium)
                        .foregroundColor(Color.white)
                        .padding(5)
                        .background(Color.blue.opacity(0.5))
                        .cornerRadius(10)
                        .frame(width: UIScreen.main.bounds.width / 3,alignment: .trailing)
                    
                    Divider().frame(width: 2, height: 30).background(.white)
                    
                    Text(String(model.humidity) + " %")
                        .font(.custom(CustomFonts.ExoMedium, size: 20))
                        .fontWeight(.medium)
                        .foregroundColor(Color.white)
                        .frame(width: UIScreen.main.bounds.width / 3,alignment: .leading)
                }.padding(10)
                
                HStack{
                    Text("WIND SPEED")
                        .font(.custom(CustomFonts.ExoMedium, size: 20))
                        
                        .fontWeight(.medium)
                        .foregroundColor(Color.white)
                        .padding(5)
                        .background(Color.blue.opacity(0.5))
                        .cornerRadius(10)
                        .frame(width: UIScreen.main.bounds.width / 3,alignment: .trailing)
                       
                    
                    Divider().frame(width: 2, height: 30).background(.white)
                        
                    Text(String(model.windSpeed)+" km/h")
                        .font(.custom(CustomFonts.ExoMedium, size: 20))
                        .fontWeight(.medium)
                        .foregroundColor(Color.white)
                        .frame(width: UIScreen.main.bounds.width / 3,alignment: .leading)
                }.padding(10)
                
                Spacer().frame(height: 20)
                
                HStack(spacing: 40){
                    Image("fan")
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .foregroundColor(Color.white)
                        .rotationEffect(.degrees(fanRotation))
                        .onAppear {
                            fanDuration = 20/(3 * model.windSpeed + 10)
                            withAnimation(.linear(duration: fanDuration)
                                    .repeatForever(autoreverses: false)) {
                                fanRotation = 360.0
                            }
                        }
                    Image("arrow")
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .foregroundColor(Color.white)
                        .frame(height: 50)
                        .rotationEffect(.degrees(-90))
                        .rotationEffect(.degrees(arrowRotation - 180))
                        .onAppear{
                            withAnimation {
                                arrowRotation = 0
                            }
                        }
                        
                }
                .frame(height: 80)
                
                Spacer()
                
            }
        }
       
    }
}

#Preview {
    CityWeatherDetails(model: WeatherModel(location: "New York", temperature: Temperature(current: 23, max: 24, min: 20), windSpeed: 4.0, humidity: 23.0,description: "Rainy day",iconCode: "02d"))
}
