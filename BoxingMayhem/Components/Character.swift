//
//  Player.swift
//  BoxingMayhem
//
//  Created by Kurnia Kharisma Agung Samiadjie on 22/05/24.
//

import SwiftUI

enum CharInfo {
    case player
    case opponent

    var type: String {
        switch self {
        case .player:
            return "player"
        case .opponent:
            return "opponent"
        }
    }
}

struct Character: View {
    var info: CharInfo
    @Binding var state: String
    @Binding var isFlipped: Bool
    @State var xPos = UIScreen.main.bounds.width / 2
    @State var yPos = UIScreen.main.bounds.height - 260
    @State var animationFrame = 1
    @State var isIncrement = true

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

    var body: some View {
        Image(info.type + "-" + state)
            .scaleEffect(x: isFlipped ? -1 : 1, y: 1)
            .frame(height: 100)
            .position(x: xPos, y: yPos)
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: {
                    _ in
                    if animationFrame == 1 {
                        xPos = UIScreen.main.bounds.width / 2 - 10
                        yPos = UIScreen.main.bounds.height - 270

                    } else if animationFrame == 2 {
                        xPos = UIScreen.main.bounds.width / 2
                        yPos = UIScreen.main.bounds.height - 280

                    } else {
                        xPos = UIScreen.main.bounds.width / 2 + 10
                        yPos = UIScreen.main.bounds.height - 270
                        isIncrement = false
                    }

                    updateState()
                })
            }
            .ignoresSafeArea(edges: .all)
    }
}

struct PlayerPreview: PreviewProvider {
    static var info = CharInfo.player
    static var previews: some View {
        Character(info: info, state: .constant("uppercut"), isFlipped: .constant(false))
    }
}
