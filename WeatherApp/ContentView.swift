//
//  ContentView.swift
//  WeatherApp
//
//  Created by Kusal on 2024-01-22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView(content: {
            NavigationLink(destination: WeatherView()) {
                    Text("World")
            }
                
        })
    }
}

#Preview {
    ContentView()
}
