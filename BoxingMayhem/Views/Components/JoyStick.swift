//
//  JoyStick.swift
//  BoxingMayhem
//
//  Created by Kurnia Kharisma Agung Samiadjie on 27/05/24.
//

import SwiftUI

struct JoyStick: View {
    @EnvironmentObject var gameService: GameService
    var body: some View {
        ZStack{
            VStack {
                HStack(spacing: 24) {
                    Button(action: {
                        gameService.updatePlayerState(newState: "jab")
                        print("clicked")
                    }) {
                        Text("Jab")
                            .foregroundStyle(.white)
                            .fontWeight(.bold)
                    }
                    .disabled(gameService.playerState != "none" ? true : false)
                    .padding(20)
                    .background(.black)
                    .cornerRadius(10)

                    Button(action: {
                        gameService.updatePlayerState(newState: "hook")
                    }) {
                        Text("Hook")
                            .foregroundStyle(.white)
                            .fontWeight(.bold)
                    }
                    .disabled(gameService.playerState != "none" ? true : false)
                    .padding(20)
                    .background(.black)
                    .cornerRadius(10)
                }

                Button(action: {
                    gameService.updatePlayerState(newState: "uppercut")
                }) {
                    Text("uppercut")
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                }
                .disabled(gameService.playerState != "none" ? true : false)
                .padding(20)
                .background(.black)
                .cornerRadius(10)
            }
            .position(x: Device.width - 200, y: Device.height - 100)
            .zIndex(99)
        }
    }
}

#Preview {
    JoyStick()
        .environmentObject(GameService())
}
