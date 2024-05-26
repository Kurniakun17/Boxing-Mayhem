//
//  HealthBar.swift
//  BoxingMayhem
//
//  Created by Kurnia Kharisma Agung Samiadjie on 27/05/24.
//

import SwiftUI

struct HealthBar: View {
    var charInfo: CharInfo
    @State var health = 100
    @EnvironmentObject var gameService: GameService

    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.gray)
                .frame(width: 500, height: 50)
            RoundedRectangle(cornerRadius: 20)
//                .fill(charInfo.type == "player" ? Color.red : Color.blue)
                .fill(charInfo.type == "player" ? LinearGradient(gradient: Gradient(colors: [.red, .yellow]), startPoint: .topLeading, endPoint: .bottomTrailing) :
                    LinearGradient(gradient: Gradient(colors: [.blue, .green]), startPoint: .bottomTrailing, endPoint: .topLeading)
                )
                .frame(width: CGFloat(500 * (charInfo.type == "player" ? gameService.playerHealth : gameService.opponentHealth) / 100), height: 50)
                .animation(.spring())
        }
    }
}

#Preview {
    HealthBar(charInfo: CharInfo.opponent)
        .environmentObject(GameService())
}
