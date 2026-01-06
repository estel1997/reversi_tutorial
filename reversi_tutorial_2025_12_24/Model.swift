import Foundation

struct Coord: Hashable {
    let y: Int
    let x: Int
}

enum Stone: Equatable {
    case black, white, none

    func opposite() -> Stone {
        switch self {
        case .black: return .white
        case .white: return .black
        case .none:  return .none
        }
    }
}

struct GameModel {
    static let size = 8

    let directions: [(dy: Int, dx: Int)] = [
        (-1, 0), (1, 0), (0, -1), (0, 1),
        (-1, -1), (-1, 1), (1, -1), (1, 1)
    ]

    func inBounds(_ y: Int, _ x: Int) -> Bool {
        (0..<Self.size).contains(y) && (0..<Self.size).contains(x)
    }

    func stonesToFlip(board: [[Stone]], y: Int, x: Int, player: Stone) -> [Coord] {
        guard board[y][x] == .none else { return [] }

        let opponent = player.opposite()
        var result: [Coord] = []

        for (dy, dx) in directions {
            var cy = y + dy
            var cx = x + dx
            var line: [Coord] = []

            while inBounds(cy, cx), board[cy][cx] == opponent {
                line.append(Coord(y: cy, x: cx))
                cy += dy
                cx += dx
            }

            if !line.isEmpty, inBounds(cy, cx), board[cy][cx] == player {
                result.append(contentsOf: line)
            }
        }
        return result
    }

    func hasLegalMove(board: [[Stone]], player: Stone) -> Bool {
        for y in 0..<Self.size {
            for x in 0..<Self.size {
                if board[y][x] == .none,
                   !stonesToFlip(board: board, y: y, x: x, player: player).isEmpty {
                    return true
                }
            }
        }
        return false
    }

    func applyMove(board: inout [[Stone]], y: Int, x: Int, player: Stone) -> Bool {
        let flips = stonesToFlip(board: board, y: y, x: x, player: player)
        guard !flips.isEmpty else { return false }

        board[y][x] = player
        for c in flips { board[c.y][c.x] = player }
        return true
    }

    func initialBoard() -> [[Stone]] {
        var b = Array(repeating: Array(repeating: Stone.none, count: Self.size), count: Self.size)
        b[3][3] = .white
        b[3][4] = .black
        b[4][3] = .black
        b[4][4] = .white
        return b
    }

    func count(board: [[Stone]], stone: Stone) -> Int {
        board.flatMap { $0 }.filter { $0 == stone }.count
    }
}
