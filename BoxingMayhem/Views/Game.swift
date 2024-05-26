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
                .scaledToFill()
                .background(Color.blue.secondary)
                .ignoresSafeArea(.all)
            Character(info: CharInfo.opponent, state: $gameService.opponentState, isFlipped: $gameService.opponentFlipped)
                .position(x: Device.width/2, y: Device.height/2 - (Device.height/3))
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: gameService.winner == "", block: {
                        _ in
                        if gameService.opponentHealth < 100, gameService.opponentHealth > 0 {
                            gameService.opponentHealth += 2
                        }

                    })
                }

            Character(info: CharInfo.player, state: $gameService.playerState, isFlipped: $gameService.playerFlipped)

            Text("State: " + gameService.playerState)
                .padding(16)
                .foregroundStyle(.white)
                .fontWeight(.bold)
                .background(.blue)
                .font(.title)
                .cornerRadius(20)
                .position(x: 150, y: 150)

            JoyStick()

            HealthBar(charInfo: CharInfo.player)
                .position(x: 500/2 + 50, y: 70)

            Image("vs")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 199)
                .position(x: Device.width/2, y: 80)

            HealthBar(charInfo: CharInfo.opponent)
                .position(x: Device.width - 500/2 - 50, y: 70)

            if gameService.playerHealth <= 0 || gameService.opponentHealth <= 0 {
                KnockedCount()
            }

            if gameService.gameState != "fight" {
                StartGameCount()
            } else {
                VideoPreview()
            }
        }
        .environmentObject(gameService)
        .onAppear {
            print("Width: \(Device.width)")
            print("Height: \(Device.height)")
        }
    }
}

#Preview {
    Game(isGamePlayed: .constant(true))
}
