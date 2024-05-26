//
//  KnockedCount.swift
//  BoxingMayhem
//
//  Created by Kurnia Kharisma Agung Samiadjie on 26/05/24.
//

import SwiftUI

struct KnockedCount: View {
    @EnvironmentObject var gameService: GameService

    var body: some View {
        ZStack {
            Image(gameService.knockedCounter)
                .id(gameService.knockedCounter)
                .transition(.scale.animation(.bouncy))
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: 1.25, repeats: true, block: {
                        timer in
                        if gameService.knockedCounter == "ko" {
                            gameService.knockedCounter = "1"
                            return
                        }
                        
                        if gameService.knockedCounter == "10" {
                            timer.invalidate()
                            return
                        }

                        gameService.knockedCounter = String(Int(gameService.knockedCounter)! + 1)
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

struct KnockedCount_Previews: PreviewProvider {
    static var previews: some View {
        KnockedCount()
            .environmentObject(GameService())
    }
}
