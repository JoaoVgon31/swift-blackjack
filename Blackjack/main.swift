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

/*
 Baralhos 21
    -> 52 cartas
        -> 13 cartas diferentes
        -> 4 naipes de cada quarta
            -> naipe não faz diferença
    -> 10, J, Q, K valem 10
    -> números de 2 a 9 valem seus números
    -> A vale 1 ou 11
        -> jogador escolhe?
        -> somente com outra carta de valor 10 na mão inicial?
 
 Usar conjunto com cada carta, pegar valor pela posição + 1 limitado a 10
 Gerar baralho a partir do dicionário repetindo cada entrada 4 vezes
 A marcado como valor 1, valor 11 com checagem em casos especiais
 */

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

func takeCard(from cards: inout Array<String>, for hand: inout Array<String>) {
    let position = Int.random(in: 0..<cards.count)
    hand.append(cards[position])
    cards.remove(at: position)
}

var gameCards = generateGameCards()
var playerHand = [String]()
var enemyHand = [String]()
takeCard(from: &gameCards, for: &playerHand)
takeCard(from: &gameCards, for: &playerHand)

print(gameCards)
print(playerHand)
print(getCardValue(card: "K"))
