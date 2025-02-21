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
    var frameWidth = Device.width * 0.35
    var frameHeight = 30.0

    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray)
                .frame(width: frameWidth, height: frameHeight)
            RoundedRectangle(cornerRadius: 10)
                .fill(generateLinearGradient(charInfo.type))
                .frame(width: CGFloat(Int(frameWidth) * (charInfo.type == "player" ? gameService.playerHealth : gameService.opponentHealth) / 100), height: frameHeight)
                .animation(.spring())
        }
    }

    func generateLinearGradient(_ type: String) -> LinearGradient {
        type == "player" ? LinearGradient(gradient: Gradient(colors: [.red, .yellow]), startPoint: .topLeading, endPoint: .bottomTrailing) :
            LinearGradient(gradient: Gradient(colors: [.blue, .green]), startPoint: .bottomTrailing, endPoint: .topLeading)
    }
}

#Preview {
    HealthBar(charInfo: CharInfo.opponent)
        .environmentObject(GameService())
}
