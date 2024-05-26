//
//  Game.swift
//  BoxingMayhem
//
//  Created by Kurnia Kharisma Agung Samiadjie on 26/05/24.
//

import SwiftUI

struct Game: View {
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

            Character(info: CharInfo.player, state: $gameService.playerState, isFlipped: $gameService.playerFlipped)

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

            Text("State: " + gameService.playerState)
                .padding(40)
                .foregroundStyle(.white)
                .fontWeight(.bold)
                .background(.blue)
                .font(.title)
                .cornerRadius(20)
                .position(x: 200, y: 100)

            if gameService.playerHealth <= 0 || gameService.opponentHealth <= 0 {
                KnockedCount()
            }

            if !gameService.gameStarted {
                StartGameCount()
            }

            if gameService.gameStarted {
//              add camera preview
            }
        }
        .environmentObject(gameService)
        .onAppear {
            print("Width: \(Device.width)")
            print("Height: \(Device.height)")
        }
//        .background(.blue)
//        NavigationLink {
//            VideoPreview()
//                .ignoresSafeArea(.all)
//        } label: {
//            Image("play.fill")
//                .resizable()
//                .frame(width: 50, height: 50)
//        }

//        VideoPreview()

//            .ignoresSafeArea(.all)
//                .rotationEffect(.degrees(90))
//                .background(.black)
    }
}

#Preview {
    Game()
}
