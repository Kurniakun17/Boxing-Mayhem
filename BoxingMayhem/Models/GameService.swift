//
//  SwiftUIView.swift
//  BoxingMayhem
//
//  Created by Kurnia Kharisma Agung Samiadjie on 25/05/24.
//
import Foundation
import SwiftUI

class GameService: ObservableObject {
    @Published var playerState = "none"
    @Published var playerFlipped = false
    @Published var opponentState = "none"
    @Published var opponentFlipped = false
    @Published var playerHealth = 100
    @Published var opponentHealth = 100
    @Published var winner = ""
    @Published var movementSet = ["jab", "hook", "uppercut"]
    @Published var knockedCounter = "1"
    @Published var stateDelay = 0

    var movementTimer: Timer?

    func opponentStartMove() {
        movementTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true, block: { timer in
            timer.tolerance = 1

//            Generate Random Move on Opponent
            let tempMovement: String = self.movementSet.randomElement() ?? "none"
            self.updateOpponentState(newState: tempMovement)
        })
    }

    func stopOpponentMove() {
        movementTimer?.invalidate()
    }

    func playerResetToNone() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            self.playerState = "none"
            self.playerFlipped = false
        }
    }
    
    func stateDelayReset() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            self.stateDelay = 0
        }
    }

    func opponentResetToNone() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            self.opponentState = "none"
            self.opponentFlipped = false
        }
    }

    func updatePlayerState(newState: String) {
        playerState = newState
        let randomBool = Bool.random()
        playerFlipped = randomBool

//        Back to None
        playerResetToNone()

//        Check if the player punch is valid
        if newState != "none" && opponentState == "none" {
            opponentHealth -= 25
            let isKnocked = updateHealth()

            if isKnocked {
                return
            }

            opponentState = "punched"
            opponentFlipped = randomBool
            opponentResetToNone()
//            if movementTimer == nil {
//                opponentStartMove()
//            }
        }
    }

    func updateOpponentState(newState: String) {
        opponentState = newState
        let randomBool = Bool.random()
        opponentFlipped = randomBool

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.opponentState = "none"
            self.opponentFlipped = false
        }

        if newState != "none" && playerState == "none" {
            playerHealth -= 25
            let isKnocked = updateHealth()

            if isKnocked {
                return
            }
            playerState = "punched"
            playerFlipped = randomBool

            playerResetToNone()
        }
    }

    func updateHealth() -> Bool {
        if playerHealth <= 0 {
            playerState = "knock"
            stopOpponentMove()
            return true
        }

        if opponentHealth <= 0 {
            opponentState = "knock"
            stopOpponentMove()
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                self.opponentHealth = 75
                self.opponentState = "none"
                self.knockedCounter = "1"
                self.winner = "player"
            }
            return true
        }

        return false
    }
}
