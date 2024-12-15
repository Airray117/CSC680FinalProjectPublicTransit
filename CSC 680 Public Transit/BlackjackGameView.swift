//
//  BlackjackGameView.swift
//  CSC 680 Public Transit
//
//  Created by Raymond Liu on 10/31/24.
//

import SwiftUI

class BlackjackGame: ObservableObject
{
    @Published var playerHand: [Int] = []
    @Published var dealerHand: [Int] = []
    @Published var gameStatus: String = ""

    init()
    {
        newGame()
    }

    func newGame()
    {
        playerHand = [drawCard(), drawCard()]
        dealerHand = [drawCard()]
        gameStatus = ""
    }

    func drawCard() -> Int
    {
        Int.random(in: 1...11)
    }

    func hit()
    {
        playerHand.append(drawCard())
        checkGameStatus()
    }

    func stand()
    {
        while dealerHand.reduce(0, +) < 17
        {
            dealerHand.append(drawCard())
        }
        checkGameStatus()
    }

    func checkGameStatus()
    {
        let playerScore = playerHand.reduce(0, +)
        let dealerScore = dealerHand.reduce(0, +)

        if playerScore > 21
        {
            gameStatus = "Bust! Dealer Wins"
        }
        else if dealerScore > 21
        {
            gameStatus = "Dealer Busts! You Win"
        }
        else if dealerScore >= 17
        {
            if playerScore > dealerScore
            {
                gameStatus = "You Win!"
            }
            else if playerScore == dealerScore
            {
                gameStatus = "It's a Tie!"
            }
            else
            {
                gameStatus = "Dealer Wins"
            }
        }
    }
}

struct BlackjackGameView: View {
    @StateObject private var game = BlackjackGame()

    var body: some View
    {
        VStack
        {
            Text("Dealer's Hand: \(game.dealerHand.reduce(0, +))")
                .font(.headline)
            HStack {
                ForEach(game.dealerHand, id: \.self) { card in
                    Text("\(card)")
                }
            }

            Spacer().frame(height: 20)

            Text("Your Hand: \(game.playerHand.reduce(0, +))")
                .font(.headline)
            HStack {
                ForEach(game.playerHand, id: \.self) { card in
                    Text("\(card)")
                }
            }

            Spacer().frame(height: 20)

            Text(game.gameStatus)
                .font(.title2)
                .foregroundColor(.red)

            Spacer().frame(height: 20)

            HStack {
                Button(action: { game.hit() })
                {
                    Text("Hit")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                Button(action: { game.stand() })
                {
                    Text("Stand")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }

            Spacer()

            Button(action: { game.newGame() })
            {
                Text("New Game")
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}

struct BlackjackGameView_Previews: PreviewProvider
{
    static var previews: some View
    {
        BlackjackGameView()
    }
}
