    //
    //  SwiftUIView.swift
    //  BoxingMayhem
    //
    //  Created by Kurnia Kharisma Agung Samiadjie on 21/02/25.
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
        @Published var playerStamina = 100
        @Published var opponentStamina = 100
        @Published var knockedCounter = "ko"
        @Published var stateDelay = 0
        @Published var gameState = "lobby"
        @Published var winner = ""
        
        private let movementSet = ["jab", "hook", "uppercut"]
        private var movementTimer: Timer?
        private let staminaRecoveryRate: Double = 5
        private let staminaRecoveryInterval: TimeInterval = 0.5
        private var staminaTimer: Timer?
        
        private let movementStaminaCost: [String: Int] = [
            "jab": 10,
            "hook": 20,
            "uppercut": 25,
        ]
        
        private let movementDamage: [String: Int] = [
            "jab": 4,
            "hook": 8,
            "uppercut": 10,
        ]
        
        init() {
            startStaminaRecovery()
        }
        
        private func startStaminaRecovery() {
            staminaTimer = Timer.scheduledTimer(withTimeInterval: staminaRecoveryInterval, repeats: true) { [weak self] _ in
                self?.recoverStamina()
            }
        }
        
        private func recoverStamina() {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                if self.playerState == "none" {
                    self.playerStamina = min(100, self.playerStamina + Int(self.staminaRecoveryRate))
                }
                if self.opponentState == "none" {
                    self.opponentStamina = min(100, self.opponentStamina + Int(self.staminaRecoveryRate))
                }
            }
        }
        
        private func hasEnoughStamina(for movement: String, isPlayer: Bool) -> Bool {
            let requiredStamina = movementStaminaCost[movement] ?? 0
            return isPlayer ? playerStamina >= requiredStamina : opponentStamina >= requiredStamina
        }
        
        private func consumeStamina(for movement: String, isPlayer: Bool) {
            let cost = movementStaminaCost[movement] ?? 0
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if isPlayer {
                    self.playerStamina = max(0, self.playerStamina - cost)
                } else {
                    self.opponentStamina = max(0, self.opponentStamina - cost)
                }
            }
        }
        
        func playerResetToNone() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
                self?.playerState = "none"
                self?.playerFlipped = false
            }
        }
        
        func opponentResetToNone() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
                self?.opponentState = "none"
                self?.opponentFlipped = false
            }
        }
        
        func startOpponentMove() {
            movementTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                let possibleMoves = movementSet.filter { self.hasEnoughStamina(for: $0, isPlayer: false) }
                guard !possibleMoves.isEmpty else { return }
                
                let tempMovement = possibleMoves.randomElement() ?? "none"
                self.updateOpponentState(newState: tempMovement)
            }
        }
        
        func stopOpponentMove() {
            movementTimer?.invalidate()
            staminaTimer?.invalidate()
        }
        
        func updatePlayerState(newState: String) {
            guard playerState == "none" else { return }
            guard hasEnoughStamina(for: newState, isPlayer: true) else {
                print("Not enough stamina for \(newState)")
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                self.playerState = newState
                self.playerFlipped = Bool.random()
                self.consumeStamina(for: newState, isPlayer: true)
                
                if newState != "none" && self.opponentState == "none" {
                    let damage = self.movementDamage[newState] ?? 0
                    self.opponentHealth -= damage
                    let isKnocked = self.updateHealth()
                    
                    if !isKnocked {
                        self.opponentState = "punched"
                        self.opponentFlipped = self.playerFlipped
                        self.opponentResetToNone()
                    }
                }
                
                self.playerResetToNone()
            }
        }
        
        func updateOpponentState(newState: String) {
            guard hasEnoughStamina(for: newState, isPlayer: false) else { return }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                self.opponentState = newState
                self.opponentFlipped = Bool.random()
                self.consumeStamina(for: newState, isPlayer: false)
                
                if newState != "none" && self.playerState == "none" {
                    let damage = self.movementDamage[newState] ?? 0
                    self.playerHealth -= damage
                    let isKnocked = self.updateHealth()
                    
                    if !isKnocked {
                        self.playerState = "punched"
                        self.playerFlipped = self.opponentFlipped
                        self.playerResetToNone()
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                    self?.opponentState = "none"
                    self?.opponentFlipped = false
                }
            }
        }
        
        func opponentGetUp() {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.opponentHealth = 75
                self.opponentStamina = 50
                self.opponentState = "none"
                self.knockedCounter = "ko"
            }
        }
        
        func updateHealth() -> Bool {
            if playerHealth <= 0 {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.playerState = "knock"
                    self.stopOpponentMove()
                    self.winner = "opponent"
                }
                return true
            }
            
            if opponentHealth <= 0 {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.opponentState = "punched"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                        self.opponentState = "knock"
                        self.winner = "player"
                    }
                }
                return true
            }
            
            return false
        }
        
        func resetGame() {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.playerHealth = 100
                self.opponentHealth = 100
                self.playerStamina = 100
                self.opponentStamina = 100
                self.playerState = "none"
                self.opponentState = "none"
                self.playerFlipped = false
                self.opponentFlipped = false
                self.knockedCounter = "ko"
                self.winner = ""
                self.startStaminaRecovery()
            }
        }
    }
