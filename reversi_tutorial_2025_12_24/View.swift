import SwiftUI
import Combine

extension Stone {
    var color: Color {
        switch self {
        case .black: return .black
        case .white: return .white
        case .none:  return .clear
        }
    }
}

struct Cell: View {
    let stone: Stone

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.green)
                .border(.black, width: 1)

            Circle()
                .fill(stone.color)
                .padding(4)
        }
        .contentShape(Rectangle())
    }
}

struct BoardView: View {

    @StateObject private var presenter = GamePresenter()
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 8)

    var body: some View {
        ZStack {
            VStack(spacing: 12) {
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(0..<64, id: \.self) { i in
                        let y = i / 8
                        let x = i % 8

                        Cell(stone: presenter.board[y][x])
                            .aspectRatio(1, contentMode: .fit)
                            .onTapGesture { presenter.tap(y: y, x: x) }
                    }
                }

                Button("Reset") { presenter.reset() }
            }
            .padding()


            if let popup = presenter.popup {
                switch popup {
                case .pass:
                    PassPopupView(
                        onOK: { presenter.dismissPopup() }
                    )
                case .gameOver(let winnerText):
                    GameOverPopupView(
                        winnerText: winnerText,
                        onOK: { presenter.dismissPopup() },
                        onRematch: { presenter.reset() }
                    )
                }
            }
        }
    }
}


struct PassPopupView: View {
    let onOK: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.35).ignoresSafeArea()

            VStack(spacing: 16) {
                Text("置ける場所がありません！\nパス")
                    .multilineTextAlignment(.center)

                Button("OK", action: onOK)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(Color.blue.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding(24)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
            .padding(40)
        }
    }
}

struct GameOverPopupView: View {
    let winnerText: String
    let onOK: () -> Void
    let onRematch: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.35).ignoresSafeArea()

            VStack(spacing: 16) {
                Text("Win!! \(winnerText)")
                    .font(.headline)

                HStack(spacing: 12) {
                    Button("OK", action: onOK)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.gray.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 10))

                    Button("再戦", action: onRematch)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.blue.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .padding(24)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
            .padding(40)
        }
    }
}

#Preview { BoardView() }
