//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Kusal on 2024-01-22.
//

import SwiftUI

struct WeatherView: View {
    
    @StateObject private var viewModel = WeatherViewModel()
    @State var searchText: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    @State var showCityWeather: Bool = false
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [Color(hex: "#2E335A"),Color(hex: "#1C1B33")], startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack{
                searchBar
                scrollView
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                HStack(content: {
                    Image(systemName: "chevron.compact.backward")
                        .foregroundColor(.gray)
                        .onTapGesture {
                            presentationMode.wrappedValue.dismiss()
                        }
                    Text("Weather")
                        .font(.title)
                        .foregroundStyle(.white)
                        .padding(.leading, 10)
                })
            }
        })
        .task {
            await viewModel.fetchInitialData()
        }
    }
    
    var searchBar: some View {
        ZStack{
            HStack{
                Image(systemName: "magnifyingglass")
                    .font(.title2)
                    .padding(.leading)
                    .foregroundColor(.white)

                
                TextField("Search", text: $searchText)
                    .padding(.trailing,10)
                    .foregroundColor(.white)
            }
        }
        .frame(height: 40)
        .frame(maxWidth: .infinity)
        .background(Color(hex: "#1F1D47"))
        .cornerRadius(20)
        .padding()
    }
    
    var scrollView: some View {
        ScrollView{
            VStack(spacing: 20){
                ForEach(viewModel.weatherData, id: \.self){data in
                    CityCellView(model: data)
                        .onTapGesture {
                            showCityWeather.toggle()
                        }
                        .sheet(isPresented: $showCityWeather, content: {
                        CityWeatherDetails(model: data)
            //                .presentationDetents([.medium])
                    })
                }
            }
            .padding(.top, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .scrollIndicators(.hidden)
        .padding()
        
    }
}

#Preview {
    WeatherView()
}

#Preview {
    ContentView()
}
