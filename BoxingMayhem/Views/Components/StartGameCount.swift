//
//  StartGameCountt.swift
//  BoxingMayhem
//
//  Created by Kurnia Kharisma Agung Samiadjie on 26/05/24.
//

import SwiftUI

struct StartGameCount: View {
    @EnvironmentObject var gameService: GameService
    @State var countDown = "3"

    var body: some View {
        ZStack {
            Image(countDown)
                .id(countDown)
                .transition(.scale.animation(.bouncy))
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {
                        timer in
                        if countDown == "1" {
                            countDown = "fight"
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                gameService.gameState = "fight"
                            }
                            timer.invalidate()

                            return
                        }

                        countDown = String(Int(countDown)! - 1)
                    })
                }
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .topLeading
        )

        .background(Color.black.opacity(0.2))
    }
}

#Preview {
    StartGameCount()
        .environmentObject(GameService())
}
