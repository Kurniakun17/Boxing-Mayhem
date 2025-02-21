//
//  Game.swift
//  BoxingMayhem
//
//  Created by Kurnia Kharisma Agung Samiadjie on 26/05/24.
//

import SwiftUI

struct Game: View {
    @Binding var isGamePlayed: Bool
    @StateObject var gameService = GameService()

    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .background(Color.blue.secondary)
                .ignoresSafeArea(.all)

            HStack(alignment: .top) {
                // Player health and stamina bars
                VStack(alignment: .leading, spacing: 8) {
                    HealthBar(charInfo: CharInfo.player)
                    StaminaBar(charInfo: CharInfo.player)
                    Text("State: " + gameService.playerState)
                        .padding(16)
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                        .background(.blue)
                        .cornerRadius(20)
                }
                Spacer()

                Image("vs")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 40)

                Spacer()
                // Opponent health and stamina bars
                VStack(alignment: .trailing, spacing: 8) {
                    HealthBar(charInfo: CharInfo.opponent)
                    StaminaBar(charInfo: CharInfo.opponent)
                }
            }
            .padding(24)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

            Character(info: CharInfo.opponent, state: $gameService.opponentState, isFlipped: $gameService.opponentFlipped)
                .position(x: Device.width/2, y: Device.height/2 - (Device.height/3))
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: gameService.winner == "", block: { _ in
                        if gameService.opponentHealth < 100, gameService.opponentHealth > 0 {
                            gameService.opponentHealth += 2
                        }
                    })
                }

            Character(info: CharInfo.player, state: $gameService.playerState, isFlipped: $gameService.playerFlipped)

            if gameService.playerHealth <= 0 || gameService.opponentHealth <= 0 {
                KnockedCount()
            }

            if gameService.gameState != "fight" {
                StartGameCount()
            } else {
                JoyStick()

                VideoPreview()
                    .ignoresSafeArea(.all)
                    .environmentObject(gameService)
            }
        }
        .environmentObject(gameService)
    }
}

struct StaminaBar: View {
    let charInfo: CharInfo
    @EnvironmentObject var gameService: GameService
    var frameWidth = Device.width * 0.4

    private var staminaValue: Int {
        charInfo == .player ? gameService.playerStamina : gameService.opponentStamina
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            // Reuse the existing HealthBar style but with different colors
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: frameWidth, height: 20)
                    .foregroundColor(.black.opacity(0.5))

                Rectangle()
                    .frame(width: CGFloat(staminaValue)/100 * frameWidth, height: 20)
                    .foregroundColor(.yellow) // Using yellow for stamina
            }
            .cornerRadius(10)
        }
    }
}

#Preview {
    Game(isGamePlayed: .constant(true))
}
