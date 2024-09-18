//
//  GetMoves.swift
//  ChessUpdated
//
//  Created by Borys Banaszkiewicz on 8/10/24.
//

import Foundation

struct GetMoves {
    var board = Board.shared
    
    func getLegalMoves(for piece: String, at position: Position) -> Set<Position> {
        switch piece {
        case "r", "R":
            return rookMoves(at: position)
        case "b", "B":
            return bishopMoves(at: position)
        case "n", "N":
            return knightMoves(at: position)
        case "p", "P":
            return pawnMoves(at: position)
        case "q", "Q":
            return queenMoves(at: position)
        case "k", "K":
            return kingMoves(at: position)
        default:
            break
        }
        
        return Set()
    }
    
    func rookMoves(at position: Position) -> Set<Position> {
        guard !board.boardCopy[position.x][position.y].isEmpty else { return Set() }
        
        let (row, col) = position.destructure()
        let color = board.boardCopy[row][col].isLowercase ? "black" : "white"
        
        var leftHorizontal = Set<Position>()
        for i in 1..<8 {
            if 0 <= col - i && col - i < 8 {
                let otherColor = board.boardCopy[row][col - i].isLowercase ? "black" : "white"
                if board.boardCopy[row][col - i].isEmpty {
                    leftHorizontal.insert(Position(x: row, y: col - i))
                } else if color != otherColor {
                    leftHorizontal.insert(Position(x: row, y: col - i))
                    break
                } else {
                    break
                }
            }
        }
        
        var rightHorizontal = Set<Position>()
        for i in 1..<8 {
            if 0 <= col + i && col + i < 8 {
                let otherColor = board.boardCopy[row][col + i].isLowercase ? "black" : "white"
                if board.boardCopy[row][col + i].isEmpty {
                    rightHorizontal.insert(Position(x: row, y: col + i))
                } else if color != otherColor {
                    rightHorizontal.insert(Position(x: row, y: col + i))
                    break
                } else {
                    break
                }
            }
        }
        
        var verticalTop = Set<Position>()
        for i in 1..<8 {
            if 0 <= row - i && row - i < 8 {
                let otherColor = board.boardCopy[row - i][col].isLowercase ? "black" : "white"
                if board.boardCopy[row - i][col].isEmpty {
                    verticalTop.insert(Position(x: row - i, y: col))
                } else if color != otherColor {
                    verticalTop.insert(Position(x: row - i, y: col))
                    break
                } else {
                    break
                }
            }
        }
        
        var verticalDown = Set<Position>()
        for i in 1..<8 {
            if 0 <= row + i && row + i < 8 {
                let otherColor = board.boardCopy[row + i][col].isLowercase ? "black" : "white"
                if board.boardCopy[row + i][col].isEmpty {
                    verticalDown.insert(Position(x: row + i, y: col))
                } else if color != otherColor {
                    verticalDown.insert(Position(x: row + i, y: col))
                    break
                } else {
                    break
                }
            }
        }

        return leftHorizontal.union(rightHorizontal).union(verticalTop).union(verticalDown)
    }
    
    func bishopMoves(at position: Position) -> Set<Position> {
        guard !board.boardCopy[position.x][position.y].isEmpty else { return Set() }
        
        let (row, col) = position.destructure()
        let color = board.boardCopy[row][col].isLowercase ? "black" : "white"
        
        var topLeftDiagonal = Set<Position>()
        for i in 1..<8 {
            if 0 <= col - i && col - i < 8 && 0 <= row - i && row - i < 8 {
                let otherColor = board.boardCopy[row - i][col - i].isLowercase ? "black" : "white"
                if board.boardCopy[row - i][col - i].isEmpty {
                    topLeftDiagonal.insert(Position(x: row - i, y: col - i))
                } else if color != otherColor {
                    topLeftDiagonal.insert(Position(x: row - i, y: col - i))
                    break
                } else {
                    break
                }
            }
        }

        var bottomLeftDiagonal = Set<Position>()
        for i in 1..<8 {
            if 0 <= col - i && col - i < 8 && 0 <= row + i && row + i < 8 {
                let otherColor = board.boardCopy[row + i][col - i].isLowercase ? "black" : "white"
                if board.boardCopy[row + i][col - i].isEmpty {
                    bottomLeftDiagonal.insert(Position(x: row + i, y: col - i))
                } else if color != otherColor {
                    bottomLeftDiagonal.insert(Position(x: row + i, y: col - i))
                    break
                } else {
                    break
                }
            }
        }

        var topRightDiagonal = Set<Position>()
        for i in 1..<8 {
            if 0 <= col + i && col + i < 8 && 0 <= row - i && row - i < 8 {
                let otherColor = board.boardCopy[row - i][col + i].isLowercase ? "black" : "white"
                if board.boardCopy[row - i][col + i].isEmpty {
                    topRightDiagonal.insert(Position(x: row - i, y: col + i))
                } else if color != otherColor {
                    topRightDiagonal.insert(Position(x: row - i, y: col + i))
                    break
                } else {
                    break
                }
            }
        }

        var bottomRightDiagonal = Set<Position>()
        for i in 1..<8 {
            if 0 <= col + i && col + i < 8 && 0 <= row + i && row + i < 8 {
                let otherColor = board.boardCopy[row + i][col + i].isLowercase ? "black" : "white"
                if board.boardCopy[row + i][col + i].isEmpty {
                    bottomRightDiagonal.insert(Position(x: row + i, y: col + i))
                } else if color != otherColor {
                    bottomRightDiagonal.insert(Position(x: row + i, y: col + i))
                    break
                } else {
                    break
                }
            }
        }

        return topLeftDiagonal.union(topRightDiagonal).union(bottomLeftDiagonal).union(bottomRightDiagonal)
    }
    
    func knightMoves(at position: Position) -> Set<Position> {
        guard !board.boardCopy[position.x][position.y].isEmpty else { return Set() }
        
        let (row, col) = position.destructure()
        let color = board.boardCopy[row][col].isLowercase ? "black" : "white"
        
        let moves = [
            Position(x: row - 2, y: col - 1), Position(x: row - 1, y: col - 2),
            Position(x: row + 1, y: col - 2), Position(x: row + 2, y: col - 1),
            Position(x: row + 2, y: col + 1), Position(x: row + 1, y: col + 2),
            Position(x: row - 1, y: col + 2), Position(x: row - 2, y: col + 1)
        ]
        var knightMoves = Set<Position> ()
        for move in moves {
            if move.x >= 0 && move.x < 8 && move.y >= 0 && move.y < 8 {
                let otherColor = board.boardCopy[move.x][move.y].isLowercase ? "black" : "white"
                if board.boardCopy[move.x][move.y].isEmpty {
                    knightMoves.insert(move)
                } else if color != otherColor {
                    knightMoves.insert(move)
                }
            }
        }
        
        return knightMoves
    }
    
    func pawnMoves(at position: Position) -> Set<Position> {
        guard !board.boardCopy[position.x][position.y].isEmpty else { return Set() }
        let (row, col) = position.destructure()
        
        let color = board.boardCopy[row][col].isLowercase ? "black" : "white"
        var pawnMoves = Set<Position>()
        
        //no possible enpassant for the first move (when lastMove is (-1, -1))
        if board.lastMoveEnd != Position(x: -1, y: -1) && board.lastMoveStart != Position(x: -1, y: -1) {
            let lastPieceMoved = board.boardCopy[board.lastMoveEnd.x][board.lastMoveEnd.y]
            
            // check for en passant. First, check if last move was a pawn
            if (lastPieceMoved == "p" || lastPieceMoved == "P") {
                // check if last move was 2 squares
                if (abs(board.lastMoveEnd.x - board.lastMoveStart.x) == 2) {
                    // check if pawn on last move is in same row as the current pawn
                    if (board.lastMoveEnd.x == position.x) {
                        // check if the pawn on last move was only 1 position away from current pawn
                        if (abs(position.y - board.lastMoveEnd.y) == 1) {
                            // check if the pawn on last move is not the same color as the current pawn
                            if board.boardCopy[row][col] != board.boardCopy[board.lastMoveEnd.x][board.lastMoveEnd.y] {
                                // conditions above mean that there is a valid enPassant capture
                                if color == "white" {
                                    pawnMoves.insert(Position(x: board.lastMoveEnd.x - 1, y: board.lastMoveEnd.y))
                                } else {
                                    pawnMoves.insert(Position(x: board.lastMoveEnd.x + 1, y: board.lastMoveEnd.y))
                                }
                            }
                        }
                    }
                }
            }
        }

        if color == "white" {
            if 0 <= row - 1 && row - 1 < 8 && board.boardCopy[row - 1][col].isEmpty {
                pawnMoves.insert(Position(x: row - 1, y: col))
            }
            if row == 6 && board.boardCopy[row - 1][col].isEmpty && board.boardCopy[row - 2][col].isEmpty {
                pawnMoves.insert(Position(x: row - 2, y: col))
            }
            // Capture moves for the white pawn
            if 0 <= row - 1 && row - 1 < 8 && 0 <= col - 1 && col - 1 < 8 && !board.boardCopy[row - 1][col - 1].isEmpty {
                let otherColor = board.boardCopy[row - 1][col - 1].isLowercase ? "black" : "white"
                if color != otherColor {
                    pawnMoves.insert(Position(x: row - 1, y: col - 1))
                }
            }
            if 0 <= row - 1 && row - 1 < 8 && 0 <= col + 1 && col + 1 < 8 && !board.boardCopy[row - 1][col + 1].isEmpty {
                let otherColor = board.boardCopy[row - 1][col + 1].isLowercase ? "black" : "white"
                if color != otherColor {
                    pawnMoves.insert(Position(x: row - 1, y: col + 1))
                }
            }
        } else {
            if 0 <= row + 1 && row + 1 < 8 && board.boardCopy[row + 1][col].isEmpty {
                pawnMoves.insert(Position(x: row + 1, y: col))
            }
            if row == 1 && board.boardCopy[row + 1][col].isEmpty && board.boardCopy[row + 2][col].isEmpty {
                pawnMoves.insert(Position(x: row + 2, y: col))
            }
            // Capture moves for the black pawn
            if 0 <= row + 1 && row + 1 < 8 && 0 <= col - 1 && col - 1 < 8 && !board.boardCopy[row + 1][col - 1].isEmpty {
                let otherColor = board.boardCopy[row + 1][col - 1].isLowercase ? "black" : "white"
                if color != otherColor {
                    pawnMoves.insert(Position(x: row + 1, y: col - 1))
                }
            }
            if 0 <= row + 1 && row + 1 < 8 && 0 <= col + 1 && col + 1 < 8 && !board.boardCopy[row + 1][col + 1].isEmpty {
                let otherColor = board.boardCopy[row + 1][col + 1].isLowercase ? "black" : "white"
                if color != otherColor {
                    pawnMoves.insert(Position(x: row + 1, y: col + 1))
                }
            }
        }

        return pawnMoves
    }
    
    func queenMoves(at position: Position) -> Set<Position> {
        guard !board.boardCopy[position.x][position.y].isEmpty else { return Set() }
        
        let (row, col) = position.destructure()
        let color = board.boardCopy[row][col].isLowercase ? "black" : "white"
        
        var leftHorizontal = Set<Position>()
        for i in 1..<8 {
            if 0 <= col - i && col - i < 8 {
                let otherColor = board.boardCopy[row][col - i].isLowercase ? "black" : "white"
                if board.boardCopy[row][col - i].isEmpty {
                    leftHorizontal.insert(Position(x: row, y: col - i))
                } else if color != otherColor {
                    leftHorizontal.insert(Position(x: row, y: col - i))
                    break
                } else {
                    break
                }
            }
        }
        
        var rightHorizontal = Set<Position>()
        for i in 1..<8 {
            if 0 <= col + i && col + i < 8 {
                let otherColor = board.boardCopy[row][col + i].isLowercase ? "black" : "white"
                if board.boardCopy[row][col + i].isEmpty {
                    rightHorizontal.insert(Position(x: row, y: col + i))
                } else if color != otherColor {
                    rightHorizontal.insert(Position(x: row, y: col + i))
                    break
                } else {
                    break
                }
            }
        }
        
        var verticalTop = Set<Position>()
        for i in 1..<8 {
            if 0 <= row - i && row - i < 8 {
                let otherColor = board.boardCopy[row - i][col].isLowercase ? "black" : "white"
                if board.boardCopy[row - i][col].isEmpty {
                    verticalTop.insert(Position(x: row - i, y: col))
                } else if color != otherColor {
                    verticalTop.insert(Position(x: row - i, y: col))
                    break
                } else {
                    break
                }
            }
        }
        
        var verticalDown = Set<Position>()
        for i in 1..<8 {
            if 0 <= row + i && row + i < 8 {
                let otherColor = board.boardCopy[row + i][col].isLowercase ? "black" : "white"
                if board.boardCopy[row + i][col].isEmpty {
                    verticalDown.insert(Position(x: row + i, y: col))
                } else if color != otherColor {
                    verticalDown.insert(Position(x: row + i, y: col))
                    break
                } else {
                    break
                }
            }
        }

        var topLeftDiagonal = Set<Position>()
        for i in 1..<8 {
            if 0 <= col - i && col - i < 8 && 0 <= row - i && row - i < 8 {
                let otherColor = board.boardCopy[row - i][col - i].isLowercase ? "black" : "white"
                if board.boardCopy[row - i][col - i].isEmpty {
                    topLeftDiagonal.insert(Position(x: row - i, y: col - i))
                } else if color != otherColor {
                    topLeftDiagonal.insert(Position(x: row - i, y: col - i))
                    break
                } else {
                    break
                }
            }
        }

        var bottomLeftDiagonal = Set<Position>()
        for i in 1..<8 {
            if 0 <= col - i && col - i < 8 && 0 <= row + i && row + i < 8 {
                let otherColor = board.boardCopy[row + i][col - i].isLowercase ? "black" : "white"
                if board.boardCopy[row + i][col - i].isEmpty {
                    bottomLeftDiagonal.insert(Position(x: row + i, y: col - i))
                } else if color != otherColor {
                    bottomLeftDiagonal.insert(Position(x: row + i, y: col - i))
                    break
                } else {
                    break
                }
            }
        }

        var topRightDiagonal = Set<Position>()
        for i in 1..<8 {
            if 0 <= col + i && col + i < 8 && 0 <= row - i && row - i < 8 {
                let otherColor = board.boardCopy[row - i][col + i].isLowercase ? "black" : "white"
                if board.boardCopy[row - i][col + i].isEmpty {
                    topRightDiagonal.insert(Position(x: row - i, y: col + i))
                } else if color != otherColor {
                    topRightDiagonal.insert(Position(x: row - i, y: col + i))
                    break
                } else {
                    break
                }
            }
        }

        var bottomRightDiagonal = Set<Position>()
        for i in 1..<8 {
            if 0 <= col + i && col + i < 8 && 0 <= row + i && row + i < 8 {
                let otherColor = board.boardCopy[row + i][col + i].isLowercase ? "black" : "white"
                if board.boardCopy[row + i][col + i].isEmpty {
                    bottomRightDiagonal.insert(Position(x: row + i, y: col + i))
                } else if color != otherColor {
                    bottomRightDiagonal.insert(Position(x: row + i, y: col + i))
                    break
                } else {
                    break
                }
            }
        }

        return leftHorizontal.union(rightHorizontal).union(verticalTop).union(verticalDown).union(topLeftDiagonal).union(topRightDiagonal).union(bottomLeftDiagonal).union(bottomRightDiagonal)
    }
    
    func kingMoves(at position: Position) -> Set<Position> {
        guard !board.boardCopy[position.x][position.y].isEmpty else { return Set() }
        let (row, col) = position.destructure()
        
        let color = board.boardCopy[row][col].isLowercase ? "black" : "white"
        var kingMoves = Set<Position>()
        
        for i in -1..<2 {
            for j in -1..<2 {
                if 0 <= row + i && row + i < 8 && 0 <= col + j && col + j < 8 && (i != 0 || j != 0) {
                    let otherColor = board.boardCopy[row + i][col + j].isLowercase ? "black" : "white"
                    if board.boardCopy[row + i][col + j].isEmpty || (color != otherColor) {
                        kingMoves.insert(Position(x: row + i, y: col + j))
                    }
                }
            }
        }

        if color == "white" && !board.whiteKingMoved {
            if board.boardCopy[7][5].isEmpty && board.boardCopy[7][6].isEmpty {
                if board.boardCopy[7][7] == "R" && !board.whiteRookH8Moved {
                    if !CheckConditions(kingColor: color, kingPosition: position).kingInCheckCastle(color: color, kingPath: Set([Position(x: 7, y: 6), Position(x: 7, y: 5)])) {
                        kingMoves.insert(Position(x: 7, y: 5))
                        kingMoves.insert(Position(x: 7, y: 6))
                        board.castleRightWhiteKingSide = true
                    } else {
                        board.castleRightWhiteKingSide = false
                    }
                }
            }
            if board.boardCopy[7][3].isEmpty && board.boardCopy[7][2].isEmpty && board.boardCopy[7][1].isEmpty {
                if board.boardCopy[7][0] == "R" && !board.whiteRookA8Moved {
                    if !CheckConditions(kingColor: color, kingPosition: position).kingInCheckCastle(color: color, kingPath: Set([Position(x: 7, y: 3), Position(x: 7, y: 2), Position(x: 7, y: 1)])) {
                        kingMoves.insert(Position(x: 7, y: 3))
                        kingMoves.insert(Position(x: 7, y: 2))
                        board.castleRightWhiteQueenSide = true
                    } else {
                        board.castleRightWhiteQueenSide = false
                    }
                }
            }
        } else if color == "black" && !board.blackKingMoved {
            if board.boardCopy[0][5].isEmpty && board.boardCopy[0][6].isEmpty {
                if board.boardCopy[0][7] == "r" && !board.blackRookH1Moved {
                    if !CheckConditions(kingColor: color, kingPosition: position).kingInCheckCastle(color: color, kingPath: Set([Position(x: 0, y: 6), Position(x: 0, y: 5)])) {
                        kingMoves.insert(Position(x: 0, y: 5))
                        kingMoves.insert(Position(x: 0, y: 6))
                        board.castleRightBlackKingSide = true
                    } else {
                        board.castleRightBlackKingSide = false
                    }
                }
            }
            if board.boardCopy[0][3].isEmpty && board.boardCopy[0][2].isEmpty && board.boardCopy[0][1].isEmpty {
                if board.boardCopy[0][0] == "r" && !board.blackRookA1Moved {
                    if !CheckConditions(kingColor: color, kingPosition: position).kingInCheckCastle(color: color, kingPath: Set([Position(x: 0, y: 3), Position(x: 0, y: 2), Position(x: 0, y: 1)])) {
                        kingMoves.insert(Position(x: 0, y: 3))
                        kingMoves.insert(Position(x: 0, y: 2))
                        board.castleRightBlackQueenSide = true
                    } else {
                        board.castleRightBlackQueenSide = false
                    }
                }
            }
        }
//        return kingMoves
//        // get other kings position and their legal moves so that the kings cant go on same square
        let opposingKingPosition = color == "white" ? board.blackKingPosition : board.whiteKingPosition
        var opposingKingMoves = Set<Position>()
        
        for i in -1...1 {
            for j in -1...1 {
                if ((opposingKingPosition.x + i) < 0) || ((opposingKingPosition.x + i) > 7) || ((opposingKingPosition.y + j) < 0) || ((opposingKingPosition.y + j) > 7) {
                    continue
                }
                opposingKingMoves.insert(Position(x: opposingKingPosition.x + i, y: opposingKingPosition.y + j))
            }
        }
        
        var legalMoves = Set<Position>()
        for move in kingMoves {
            // skip the moves that collide with the other kings moves
            if opposingKingMoves.contains(where: { $0 == move }) {
                continue
            }
            legalMoves.insert(move)
        }

        return legalMoves
    }
}

extension String {
    var isLowercase: Bool {
        return !self.isEmpty && self == self.lowercased()
    }
}
