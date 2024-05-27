//
//  GameResult.swift
//  BoxingMayhem
//
//  Created by Kurnia Kharisma Agung Samiadjie on 27/05/24.
//

import SwiftUI

struct GameResult: View {
    var info: CharInfo
    @EnvironmentObject var gameService: GameService
    @State var state = "player-pose"
    @State var xPos = UIScreen.main.bounds.width / 2
    @State var yPos = UIScreen.main.bounds.height - (UIScreen.main.bounds.height * 0.24)
    @State var animationFrame = 1
    @State var isIncrement = true
    @State var sequence = "0"

    func updateState() {
        if isIncrement {
            animationFrame += 1
        } else {
            animationFrame -= 1
        }

        if animationFrame == 1 {
            isIncrement = true
        } else if animationFrame == 3 {
            isIncrement = false
        }
    }

    func updateFrame() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: {
            _ in

            updateState()

            if state == "knock" {
                return
            }

            if animationFrame == 1 {
                xPos = Device.width / 2 - 10
//                yPos = device.height - 200 - (device.height / 10 - 30)
                yPos = Device.height - (Device.height * 0.24) - 10

            } else if animationFrame == 2 {
                xPos = Device.width / 2
//                yPos = device.height - 200 - (device.height / 10 - 20)
                yPos = Device.height - (Device.height * 0.24)

            } else {
                xPos = Device.width / 2 + 10
//                yPos = device.height - 200 - (device.height / 10 - 30)
                yPos = Device.height - (Device.height * 0.24) - 10

                isIncrement = false
            }

        })
    }

    var body: some View {
        ZStack {
            Image(state)
                .frame(height: Device.height * 0.40)
                .position(x: xPos, y: yPos)
                .ignoresSafeArea(edges: .all)
                .onAppear {
                    updateFrame()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        state = "player-win"
                    }
                }
            Button(action: {
                gameService.gameState = "lobby"
            }) {
                Text("Knock")
            }
        }
    }
}

#Preview {
    GameResult(info: CharInfo.player)
        .environmentObject(GameService())
}
