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
    @Published var knockedCounter = "ko"
    @Published var stateDelay = 0
    @Published var gameState = "lobby"
    @Published var movementSet = ["jab", "hook", "uppercut"]
    @Published var winner = ""

    private var movementTimer: Timer?

    //  MARK: - Character Reset

    func playerResetToNone() {
        //        Back to None
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.playerState = "none"
            self.playerFlipped = false
        }
    }

    func opponentResetToNone() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.opponentState = "none"
            self.opponentFlipped = false
        }
    }

    // MARK: - Opponent Movement

    func startOpponentMove() {
        movementTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let tempMovement = self.movementSet.randomElement() ?? "none"
            self.updateOpponentState(newState: tempMovement)
        }
    }

    func stopOpponentMove() {
        movementTimer?.invalidate()
    }

    // MARK: - State Updates

    func updatePlayerState(newState: String) {
        guard playerState == "none" else { return }
        playerState = newState
        playerFlipped = Bool.random()

        playerResetToNone()

        if newState != "none" && opponentState == "none" {
            opponentHealth -= 10
            let isKnocked = updateHealth()

            if !isKnocked {
                opponentState = "punched"
                opponentFlipped = playerFlipped
                opponentResetToNone()
            }
        }
    }

    func updateOpponentState(newState: String) {
        opponentState = newState
        opponentFlipped = Bool.random()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.opponentState = "none"
            self.opponentFlipped = false
        }

        if newState != "none" && playerState == "none" {
            playerHealth -= 25
            let isKnocked = updateHealth()

            if !isKnocked {
                playerState = "punched"
                playerFlipped = opponentFlipped
                playerResetToNone()
            }
        }
    }

    // MARK: - Health Updates

    func opponentGetUp() {
        opponentHealth = 75
        opponentState = "none"
        knockedCounter = "ko"
    }

    func updateHealth() -> Bool {
        if playerHealth <= 0 {
            playerState = "knock"
            stopOpponentMove()
            return true
        }

        if opponentHealth <= 0 {
            opponentState = "punched"
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                self.opponentState = "knock"
            }
            return true
        }

        return false
    }
}
