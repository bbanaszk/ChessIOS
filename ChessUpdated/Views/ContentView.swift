//
//  ContentView.swift
//  Sudoku
//
//  Created by Borys Banaszkiewicz on 8/7/24.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State private var command = ""
    
    var board = Board.shared
    
    @State private var moveFrom = Position(x: -1, y: -1)
    @State private var moveTo = Position(x: -1, y: -1)
    @State private var selectedRow = -1
    @State private var selectedCol = -1
    @State private var selectedPiece = ""
    @State private var legalMoves = Set<Position>()
    @State private var size: CGFloat = 0.0
    @State private var points = 0
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Spacer().frame(height: 100)
                CapturedPiecesView(capturedPieces: board.capturedPiecesWhite, color: "white", points: $points)
                ZStack {
                    GeometryReader { proxy in
                        let cellSize = min(proxy.size.width, proxy.size.height) / 8
                        HStack {
                            Grid(horizontalSpacing: 0, verticalSpacing: 0) {
                                ForEach(0..<8) { row in
                                    GridRow {
                                        ForEach(0..<8) { col in
                                            CellView(highlightState: highlightState(for: row, col: col), highlightMoves: highlightMoves(for: row, col: col), overlayMove: overlayMove(for: row, col: col))
                                                .frame(width: cellSize, height: cellSize)
                                        }
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        HStack {
                            Grid(horizontalSpacing: 0, verticalSpacing: 0) {
                                ForEach(0..<8, id: \.self) { row in
                                    GridRow {
                                        ForEach(0..<8, id: \.self) { col in
                                            PiecesView(localLegalMoves: legalMoves, moveFrom: Position(x: selectedRow, y: selectedCol), moveTo: Position(x: row, y: col), selectedPiece: board.board[row][col], selectedRow: row, selectedCol: col, cellSize: cellSize) { moves in
                                                updateSelection(row: row, col: col, moves: moves)
                                            }
                                            .frame(width: cellSize, height: cellSize)
                                        }
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .padding(5)
                }
                CapturedPiecesView(capturedPieces: board.capturedPiecesBlack, color: "black", points: $points)
                Spacer()
                    .frame(maxWidth: .infinity, maxHeight: 150)
            }
            .navigationTitle("Chess")
        }
        .preferredColorScheme(.dark)
        .dynamicTypeSize(...DynamicTypeSize.xxLarge)
        .onChange(of: legalMoves) {
            legalMoves = validateMoves(moves: legalMoves, at: Position(x: selectedRow, y: selectedCol))
        }
        .onChange(of: board.capturedPiecesBlack) {
            points = board.getPoints()
        }
        .onChange(of: board.capturedPiecesWhite) {
            points = board.getPoints()
        }
    }

    private func updateSelection(row: Int, col: Int, moves: Set<Position>) {
        moveFrom = Position(x: selectedRow, y: selectedCol)
        moveTo = Position(x: row, y: col)
        selectedRow = row
        selectedCol = col
        selectedPiece = board.board[row][col]
        legalMoves = moves
    }
    
    func highlightState(for row: Int, col: Int) -> CellView.HighlightState {
        if (row + col) % 2 == 0 {
            return .standardLight
        } else {
            return .standardDark
        }
    }
    
    func highlightMoves(for row: Int, col: Int) -> CellView.HighlightMoves {
        if !legalMoves.isEmpty && legalMoves.contains(Position(x: row, y: col)) {
            return .legalMoves
        } else {
            return .standard
        }
    }
    
    func overlayMove(for row: Int, col: Int) -> CellView.OverlayMove {
        if !board.isBot && ((board.suggestedMoveFrom != Position(x: -1, y: -1) && (board.suggestedMoveFrom == Position(x: row, y: col))) || (board.suggestedMoveTo != Position(x: -1, y: -1) && (board.suggestedMoveTo == Position(x: row, y: col)))) {
            return .suggestedMoves
        } else if board.lastMoveStart != Position(x: -1, y: -1) && (board.lastMoveStart == Position(x: row, y: col)) || (board.lastMoveEnd != Position(x: -1, y: -1) && (board.lastMoveEnd == Position(x: row, y: col))) {
            return .previousMove
        } else {
            return .standard
        }
    }
    
    func validateMoves(moves: Set<Position>, at: Position) -> Set<Position> {
        guard !selectedPiece.isEmpty && (selectedPiece.isLowercase && !board.whiteTurn || !selectedPiece.isLowercase && board.whiteTurn) else { return Set() }
        var validatedMoves = Set<Position>()
        let kingColor = selectedPiece.isLowercase ? "black" : "white"
        let kingPosition = kingColor == "black" ? board.blackKingPosition : board.whiteKingPosition
        
        let checkConditions = CheckConditions(kingColor: kingColor, kingPosition: kingPosition)
        
        for move in legalMoves {
            if let valid = checkConditions.validateMove(moveFrom: at, moveTo: move), valid == false {
                validatedMoves.insert(move)
            }
        }
        
        return validatedMoves
    }
}

#Preview {
    ContentView()
}
