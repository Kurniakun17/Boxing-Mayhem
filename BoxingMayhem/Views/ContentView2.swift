//
//  ContentView2.swift
//  BoxingMayhem
//
//  Created by Kurnia Kharisma Agung Samiadjie on 26/05/24.
//

import SwiftUI

struct ContentView2: View {
    @StateObject var gameService = GameService()
    var body: some View {
        NavigationView {
            VideoPreview()
                .frame(width: 320, height: 180)
                .background(.black)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .environmentObject(gameService)
//            .rotationEffect(.degrees(90))
//            .ignoresSafeArea(.all)
    }
}

#Preview {
    ContentView2()
}
