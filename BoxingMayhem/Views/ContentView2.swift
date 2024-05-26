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
            ZStack {
                VideoPreview()
//                    .rotationEffect(.degrees(90))
//                    .position(x: 180, y: 300)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .environmentObject(gameService)
//            .ignoresSafeArea(.all)
    }
}

#Preview {
    ContentView2()
}
