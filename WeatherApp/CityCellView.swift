//
//  CityCellView.swift
//  WeatherApp
//
//  Created by Kusal on 2024-01-22.
//

import SwiftUI

struct CityCellView: View {
    
    let model: WeatherModel
    
    var body: some View {
        ZStack{
            VStack{
                Spacer()
                CellBGShape()
                    .fill(LinearGradient(colors: [Color(hex: "#5D36B4"),Color(hex: "#362A84")], startPoint: .leading, endPoint: .trailing))
                    .frame(height: 175)
                    .clipped(antialiased: false)
                    .shadow(color: .black.opacity(0.7), radius: 2, x: 0, y:4)
            }
            
                
            GeometryReader{ geo in
                HStack{
                    VStack(content: {
                        HStack{
                            Spacer().frame(width: 40)
                            Text(String(model.temperature.current) + "°C")
                                .frame(height: geo.size.height/3)
                                .font(.custom(CustomFonts.ExoBold, size: 70))
                                .minimumScaleFactor(0.01)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.top, 40)
                        
                        HStack{
                            Spacer().frame(width: 40)
                            Text("H " + String(model.temperature.max) + "°C")
                                .font(.custom(CustomFonts.ExoMedium, size: 10))
                                .foregroundColor(.white)
                            Text("L " + String(model.temperature.min) + "°C")
                                .font(.custom(CustomFonts.ExoMedium, size: 10))
                                .foregroundColor(.white)
                                
                            Spacer()
                        }
                        
                        HStack{
                            Spacer().frame(width: 40)
                            Text(model.location)
                                .font(.custom(CustomFonts.ExoBold, size: 30))
                                .foregroundColor(.white)
                                .padding(.bottom, 20)
                                
                            Spacer()
                        }
                        
                            
                    })
                    .frame(width: geo.size.width/2, height: geo.size.height)
                    
                    VStack(alignment: .trailing){
                        
                        AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(model.iconCode)@2x.png")) { image in
                            image.resizable().offset(x: 0, y: 0)
                                
                            
                        } placeholder: {
                            Image("windy-weather")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 100,height: 100)
                                .foregroundColor(.white)
                                .offset(x: 0, y: 0)
                        }
                        .frame(width: 150,height: 150)
                        .background(LinearGradient(colors: [Color(hex: "#F7CBFD"),Color(hex: "#7758D1")], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .cornerRadius(75)
                        .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y:2)

                        
                        Spacer()
                        
                        ZStack(alignment: .trailing){
                            Text(String(model.description.capitalized))
                                .bold()
                                .foregroundColor(.white)
                                .padding(.bottom,40)
                                .padding(.trailing,20)
                        }
                        
                    }
                    .frame(width: geo.size.width/2, height: geo.size.height)
                    
                }
            }
        }
        .frame(height: 184)
    }
}

struct CellBGShape: Shape {
    
    let cornerRadius: CGFloat = 30
    
    func path(in rect: CGRect) -> Path {
        
        let start_x = rect.width/2
        let start_y = rect.height * 0.4 / 2
        
        return Path { path in
            path.move(to: CGPoint(x: start_x, y: start_y))
            path.addArc(tangent1End: CGPoint(x: 0, y: 0), tangent2End: CGPoint(x: 0, y: rect.height-cornerRadius), radius: cornerRadius)
            path.addLine(to: CGPoint(x: 0, y: rect.height-cornerRadius))
            path.addArc(center: CGPoint(
                x: cornerRadius, y: rect.height - cornerRadius),
                radius: cornerRadius,
                startAngle: Angle(degrees: 180),
                endAngle: Angle(degrees: 90),
                clockwise: true)
            path.addLine(to: CGPoint(x: rect.width-cornerRadius, y: rect.height))
            path.addArc(center: CGPoint(
                x: rect.width-cornerRadius, y: rect.height - cornerRadius),
                radius: cornerRadius,
                startAngle: Angle(degrees: 90),
                endAngle: Angle(degrees: 0),
                clockwise: true)
            
            path.addArc(tangent1End: CGPoint(x: rect.width, y: rect.height*0.4), tangent2End: CGPoint(x: start_x, y: start_y), radius: cornerRadius)

            path.closeSubpath()
        }
    }
}

//#Preview {
//    CellBGShape()
//}


#Preview {
    CityCellView(model: WeatherModel(location: "New York", temperature: Temperature(current: 23, max: 24, min: 20), wind: Wind(windSpeed: 4, direction: 45), humidity: 23.0,description: "",iconCode: ""))
}
