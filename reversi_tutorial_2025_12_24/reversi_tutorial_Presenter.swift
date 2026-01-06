import Foundation
import Combine

@MainActor
final class GamePresenter: ObservableObject {

    enum Popup {
        case pass
        case gameOver(winnerText: String)
    }

    @Published private(set) var board: [[Stone]]
    @Published private(set) var currentTurn: Stone = .black
    @Published var popup: Popup? = nil

    private let model = GameModel()

    init() {
        self.board = model.initialBoard()
    }

    func reset() {
        board = model.initialBoard()
        currentTurn = .black
        popup = nil
    }

    func dismissPopup() {
        popup = nil
    }

    func tap(y: Int, x: Int) {
        guard board[y][x] == .none else { return }

        let placed = model.applyMove(board: &board, y: y, x: x, player: currentTurn)
        guard placed else { return }

        advanceTurnAfterMove()
    }

    private func advanceTurnAfterMove() {
        let next = currentTurn.opposite()

        if model.hasLegalMove(board: board, player: next) {
            currentTurn = next
            return
        }

        if model.hasLegalMove(board: board, player: currentTurn) {

            popup = .pass
        } else {

            let b = model.count(board: board, stone: .black)
            let w = model.count(board: board, stone: .white)
            let winner: String
            if b > w { winner = "Player Black" }
            else if w > b { winner = "Player White" }
            else { winner = "Draw" }

            popup = .gameOver(winnerText: winner)
        }
    }
}
