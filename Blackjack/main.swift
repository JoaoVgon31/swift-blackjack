//
//  main.swift
//  Blackjack
//
//  Created by João Vitor Gonçalves Oliveira on 17/03/23.
//

import Foundation

enum InputError: Error {
    case invalid
    case NAN
}

func readIntInput() throws -> Int {
    if let input = readLine() {
        if let intInput = Int(input) {
            return intInput
        } else {
            throw InputError.NAN
        }
    } else {
        throw InputError.invalid
    }
}

func readValidOption(options: ClosedRange<Int>) -> Int {
    while true {
        if let input = try? readIntInput() {
            if options.contains(input) {
                return input
            }
        }
    }
}

class Player {
    var name: String = "Participante"
    var hand: Array<String> = []
    var cardsTotal: Int = 0
    var stopped: Bool = false
    
    func readPlayerName() {
        if let input = readLine() {
            self.name = input
        }
    }
    
    func takeCard(from cards: inout Array<String>) {
        let position = Int.random(in: 0..<cards.count)
        self.hand.append(cards[position])
        self.cardsTotal += getCardValue(card: cards[position])
        cards.remove(at: position)
    }
    
    func makePlay(gameCards cards: inout Array<String>) {
        if !self.stopped {
            print("\n__________Vez de \(self.name)__________")
            print("\nMão de \(self.name): \(self.hand)")
            print("Valor total cartas \(self.name): \(self.cardsTotal)")
            print("\nSelecione uma das opções:\n1.Pegar uma carta \n2.Parar")
            let selectedOption = readValidOption(options: 1...2)
            
            if selectedOption == 1 {
                self.takeCard(from: &cards)
                print("\nMão de \(self.name): \(self.hand)")
                print("Valor total cartas \(self.name): \(self.cardsTotal)")
            } else if selectedOption == 2 {
                self.stopped = true
            }
        }
    }
}

let cards = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "Q", "J", "K"]

func generateGameCards(quantityOfDecks: Int = 1) -> Array<String> {
    var generatedCards = [String]()
    for _ in 1...quantityOfDecks {
        for card in cards {
            for _ in 1...4 {
                generatedCards.append(card);
            }
        }
    }
    return generatedCards
}

func getCardValue(card: String) -> Int {
    let position = cards.firstIndex(of: card) ?? -1
    if position >= 9 {
        return 10
    } else {
        return position + 1
    }
}

func dealInitialHands(from cards: inout Array<String>, for players: Array<Player>) {
    for player in players {
        player.takeCard(from: &cards)
        player.takeCard(from: &cards)
    }
}

func gameEnded(_ player1: Player,_ player2: Player) -> Bool {
    if player1.stopped && player2.stopped || player1.cardsTotal > 21 || player2.cardsTotal > 21 {
        if player1.cardsTotal > player2.cardsTotal && player1.cardsTotal <= 21 || player2.cardsTotal > 21 {
            print("\n\(player1.name) ganhou o jogo com \(player1.cardsTotal)")
            print("\(player2.name) perdeu o jogo com \(player2.cardsTotal)")
        } else if player1.cardsTotal < player2.cardsTotal && player2.cardsTotal <= 21 || player1.cardsTotal > 21 {
            print("\n\(player2.name) ganhou o jogo com \(player2.cardsTotal)")
            print("\(player1.name) perdeu o jogo com \(player1.cardsTotal)")
        } else {
            print("\nJogo empatou")
        }
        return true
    }
    return false
}

var gameCards = generateGameCards()
let player1 = Player()
let player2 = Player()
print("Informe o nome das duas pessoas que irão jogar:")
player1.readPlayerName()
player2.readPlayerName()

dealInitialHands(from: &gameCards, for: [player1, player2])
print("\nMão de \(player1.name): \(player1.hand)")
print("Valor total cartas \(player1.name): \(player1.cardsTotal)")
print("\nMão de \(player2.name): \(player2.hand)")
print("Valor total cartas \(player2.name): \(player2.cardsTotal)")

while true {
    player1.makePlay(gameCards: &gameCards)
    if gameEnded(player1, player2) { break }
    player2.makePlay(gameCards: &gameCards)
    if gameEnded(player1, player2) { break }
}
