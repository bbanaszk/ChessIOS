//
//  PiecesView.swift
//  ChessUpdated
//
//  Created by Borys Banaszkiewicz on 8/10/24.
//

import SwiftUI

struct PiecesView: View {
    @State private var offset = CGSize.zero
    @State private var hapticEffect = HapticEffect()
        
    var board: Board = .shared

    let localLegalMoves: Set<Position>
    let moveFrom: Position
    let moveTo: Position
    let selectedPiece: String
    let selectedRow: Int
    let selectedCol: Int
    let cellSize: CGFloat

    var onSelected: (Set<Position>) -> Void

    var displayPiece: String {
        if !selectedPiece.isEmpty {
            return "\(selectedPiece)"
        }
        return "clear"
    }

    var legalMoves: Set<Position> {
        if !selectedPiece.isEmpty {
            let move = GetMoves()
            return move.getLegalMoves(for: selectedPiece, at: Position(x: selectedRow, y: selectedCol))
        }
        return Set()
    }


    var body: some View {
        Button(action: {
            if localLegalMoves.contains(moveTo) {

                let x = CGFloat(moveTo.x - moveFrom.x) * cellSize
                let y = CGFloat(moveTo.y - moveFrom.y) * cellSize
                
                board.movePiece(from: moveFrom, to: moveTo)

                withAnimation(Animation.interpolatingSpring(stiffness: 140, damping: 35, initialVelocity: 14)) {
                    offset = CGSize(width: y, height: x)
                }
                onSelected(Set())
            } else {
                onSelected(legalMoves)
            };
        }) {
            Image(displayPiece)
                .resizable()
                .scaledToFit()
        }
        .onChange(of: board.suggestedMoveTo) {
            if board.isBot && board.suggestedMoveTo == Position(x: selectedRow, y: selectedCol) {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    attemptMove(from: board.suggestedMoveFrom, to: board.suggestedMoveTo)
                    board.suggestedMoveTo = Position(x: -1, y: -1)
                    board.suggestedMoveFrom = Position(x: -1, y: -1)
//                }
            }
        }
        .offset(x: offset.width, y: offset.height)
        .onChange(of: offset) {
            offset = .zero
            hapticEffect.moveHaptic()
        }
        .buttonStyle(PlainButtonStyle())
    }

    func attemptMove(from: Position, to: Position) {
        guard from != Position(x: -1, y: -1) && to != Position(x: -1, y: -1) else { return }
        
        let x = CGFloat(to.x - from.x) * cellSize
        let y = CGFloat(to.y - from.y) * cellSize
                
        self.board.movePiece(from: board.suggestedMoveFrom, to: board.suggestedMoveTo)
        
        
        withAnimation(Animation.interpolatingSpring(stiffness: 140, damping: 35, initialVelocity: 14)) {
            self.offset = CGSize(width: y, height: x)
        }
    }
}
