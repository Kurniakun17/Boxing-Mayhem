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
        ZStack {
            //            Jab
            Button(action: {
                gameService.updatePlayerState(newState: "jab")
            }) {
                Text("Jab")
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
            }
            .disabled(gameService.playerState != "none" ? true : false)
            .padding(40)
            .background(.black)
            .font(.title)
            .cornerRadius(20)
            .position(x: UIScreen.main.bounds.width - 200, y: UIScreen.main.bounds.height - 200)

            //            Hook
            Button(action: {
                gameService.updatePlayerState(newState: "hook")
            }) {
                Text("Hook")
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
            }
            .disabled(gameService.playerState != "none" ? true : false)
            .padding(40)
            .background(.black)
            .font(.title)
            .cornerRadius(20)
            .position(x: UIScreen.main.bounds.width - 100, y: UIScreen.main.bounds.height - 350)

            //            Uppercut
            Button(action: {
                gameService.updatePlayerState(newState: "uppercut")
            }) {
                Text("uppercut")
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
            }
            .disabled(gameService.playerState != "none" ? true : false)
            .padding(40)
            .background(.black)
            .font(.title)
            .cornerRadius(20)
            .position(x: UIScreen.main.bounds.width - 300, y: UIScreen.main.bounds.height - 350)
        }
    }
}

