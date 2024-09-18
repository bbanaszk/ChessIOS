//
//  CheckConditions.swift
//  ChessUpdated
//
//  Created by Borys Banaszkiewicz on 8/13/24.
//

import Foundation

class CheckConditions {
    var board = Board.shared
    var tempBoard = [[String]]()
    let kingColor: String
    var kingPosition: Position
    
    init(kingColor: String, kingPosition: Position) {
        self.kingColor = kingColor
        self.kingPosition = kingPosition
    }
    
    func validateMove(moveFrom: Position, moveTo: Position) -> Bool? {
        guard ((moveFrom != Position(x: -1, y: -1)) && (moveTo != Position(x: -1, y: -1))) else { return nil }
        let color = board.boardCopy[moveFrom.x][moveFrom.y].isLowercase ? "black" : "white"
        
        tempBoard = board.boardCopy.map { $0 }
        board.boardCopy[moveFrom.x][moveFrom.y] = ""
        board.boardCopy[moveTo.x][moveTo.y] = tempBoard[moveFrom.x][moveFrom.y]
        
        for row in 0..<8 {
            for col in 0..<8 {
                if kingColor == "white" && board.boardCopy[row][col] == "K" || kingColor == "black" && board.boardCopy[row][col] == "k" {
                    kingPosition = Position(x: row, y: col)
                    break
                }
            }
        }
        
        let check = kingInCheck(opponentColor: color == "white" ? "black" : "white")
        
        board.boardCopy = tempBoard
        
        return check
    }
    
    private func kingInCheck(opponentColor: String) -> Bool {
        let moves = getOpponentMoves(opponent: opponentColor)
        return moves.contains(where: { $0 == kingPosition })
    }
    
    private func getOpponentMoves(opponent color: String) -> Set<Position> {
        var moves = Set<Position>()
        for row in 0..<8 {
            for col in 0..<8 {

                let piece = board.boardCopy[row][col]
                
                if (piece.isLowercase && color == "black") || (!piece.isLowercase && color == "white") {
                    switch piece {
                    case "r", "R":
                        moves.formUnion(GetMoves(board: board).rookMoves(at: Position(x: row, y: col)))
                    case "b", "B":
                        moves.formUnion(GetMoves(board: board).bishopMoves(at: Position(x: row, y: col)))
                    case "n", "N":
                        moves.formUnion(GetMoves(board: board).knightMoves(at: Position(x: row, y: col)))
                    case "p", "P":
                        moves.formUnion(GetMoves(board: board).pawnMoves(at: Position(x: row, y: col)))
                    case "q", "Q":
                        moves.formUnion(GetMoves(board: board).queenMoves(at: Position(x: row, y: col)))
                    default:
                        continue
                    }
                }
            }
        }
        return moves
    }
    
    func kingInCheckCastle(color: String, kingPath: Set<Position>) -> Bool {
        let moves = getOpponentMoves(opponent: color == "white" ? "black" : "white")

        for path in kingPath {
            if moves.contains(where: { $0 == path }) || moves.contains(where: { $0 == kingPosition }) {
                return true
            }
        }
        return false
    }
}
