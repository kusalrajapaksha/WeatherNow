//
//  CityWeatherDetails.swift
//  WeatherApp
//
//  Created by Kusal on 2024-01-30.
//

import SwiftUI

struct CityWeatherDetails: View {
    
    @ObservedObject var viewModel: WeatherViewModel
    @State var model: WeatherModel
    
    @State private var fanRotation = 0.0
    @State private var fanDuration = 0.0
    @State private var arrowRotation = 0.0
    @State private var showProgressView = false
    
    var cities = ["Colombo", "New York", "Tokyo"]
    @State private var number: Int = 0
    
    var points : [UnitPoint] = [.top,.bottom,.topTrailing, .bottomLeading, .trailing, .leading, .bottomTrailing, .topLeading, .bottom, .top, .bottomLeading, .topTrailing, .leading, .trailing, .topLeading, .bottomTrailing]
    @State var startPoint: UnitPoint = .top
    @State var endPoint: UnitPoint = .bottom
    @State var startIndex: Int = 0
    @State var endIndex: Int = 1
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        ZStack {
            LinearGradient(colors: [Color(hex: "#5D36B4"),Color(hex: "#362A84")], startPoint: points[startIndex], endPoint: points[endIndex])
            /*LinearGradient(colors: [Color.red,Color.green], startPoint: startPoint, endPoint: endPoint)*/.edgesIgnoringSafeArea(.all)
            
            VStack{
                HStack{
                    Spacer()
                    HStack{
                        ProgressView()
                            .opacity(showProgressView ? 1.0 : 0.0)
                            .progressViewStyle(.circular)
                            .tint(Color.white)
                        
                        Text("Refresh")
                            .padding()
                            .font(.custom(CustomFonts.ExoMedium, size: 16))
                            .foregroundColor(.white.opacity(0.7))
                            .onTapGesture {
                                Task{
                                    showProgressView = true
                                    guard let newModel =  await viewModel.refreshData(cityName: model.location) else{return}
                                    model = newModel
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                        showProgressView = false
                                    })
                                    
                                }
                            }
                    }
                    .onChange(of: number) { newValue in
                        let newCity = cities[number]
                        Task{
                            showProgressView = true
                            guard let newModel =  await viewModel.refreshData(cityName: newCity) else{return}
                            model = newModel
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                showProgressView = false
                            })
                            
                        }
                    }
                    
                }
                
                Spacer()
            }
            
            VStack{
                Text(model.location)
                    .font(.custom(CustomFonts.ExoBold, size: 50))
                    .minimumScaleFactor(0.5)
                    .foregroundStyle(Color.white)
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
                .frame(width: 150,height: 150,alignment: .center)
                
                Text(model.description.capitalized)
                    .font(.custom(CustomFonts.ExoMedium, size: 30))
                    .fontWeight(.medium)
                    .foregroundColor(Color.white)
                    .padding(.top,0)
                
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
                        
                    Text(String(model.wind.windSpeed)+" km/h")
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
                        .foregroundColor(Color.mint)
                        .rotationEffect(.degrees(fanRotation))
                        .onAppear {
                            fanDuration = 20/(3 * model.wind.windSpeed + 10)
                            withAnimation(.linear(duration: fanDuration)
                                    .repeatForever(autoreverses: false)) {
                                fanRotation = 360.0
                            }
                        }
                        .onChange(of: model) { oldValue, newValue in
                            fanDuration = 20/(3 * newValue.wind.windSpeed + 10)
                            withAnimation(.linear(duration: fanDuration)
                                    .repeatForever(autoreverses: false)) {
                                fanRotation = 360.0
                            }
                        }
                    Image("arrow")
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .foregroundColor(Color.accentColor)
                        .frame(height: 50)
                        .rotationEffect(.degrees(-90))
                        .rotationEffect(.degrees(arrowRotation - 180))
                        .onAppear{
                            withAnimation {
                                arrowRotation = model.wind.direction
                            }
                        }
                        .onChange(of: model) { oldValue, newValue in
                            withAnimation {
                                arrowRotation = newValue.wind.direction
                            }
                        }
                        
                        
                }
                .frame(height: 60)
                
                Picker("City", selection: $number) {
                    ForEach(0..<cities.count, id: \.self) { index in
                        Text(cities[index])
                            .foregroundColor(.white)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 400, height: 100, alignment: .center)
                    
                    
                    
                
                Spacer()
                
            }
        }
        .onReceive(timer) { _ in
            // Change the background color
            if startIndex < points.count - 2{
                withAnimation(.linear(duration: 1)) {
                    startIndex += 2
                    endIndex = startIndex + 1
                }
            }
            
            if startIndex == points.count - 2{
                withAnimation(.linear(duration: 1)) {
                    startIndex = 0
                    endIndex = startIndex + 1
                }
            }
        }
       
    }
}

#Preview {
    CityWeatherDetails(viewModel: WeatherViewModel(), model: WeatherModel(location: "New York", temperature: Temperature(current: 23, max: 24, min: 20), wind: Wind(windSpeed: 4, direction: 45), humidity: 23.0,description: "Rainy day",iconCode: "02d"))
}
