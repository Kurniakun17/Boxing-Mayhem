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

            updateSequence()
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

    func updateSequence() {
        if animationFrame == 1 {
            sequence = "0"

        } else if animationFrame == 3 {
            sequence = "1"
        }
    }

    var body: some View {
        Image(info.type + "-" + state + ((info.type == "opponent" && state == "none") || state == "knock" ? sequence : ""))
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: Device.height * 0.55)
            .scaleEffect(x: isFlipped ? -1 : 1, y: 1)
            .position(x: xPos, y: yPos)
            .onAppear {
                updateFrame()
            }
            .ignoresSafeArea(edges: .all)
    }
}

struct CharacterPreview: PreviewProvider {
    static var info = CharInfo.opponent
    static var previews: some View {
        Character(info: info, state: .constant("none"), isFlipped: .constant(false))
    }
}
