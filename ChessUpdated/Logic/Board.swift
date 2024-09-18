//
//  Board.swift
//  Sudoku
//
//  Created by Borys Banaszkiewicz on 8/7/24.
//

import Foundation
import SwiftUI
import Combine

@Observable class Board {
    private var chessEngine = ChessEngine()
    
    static let shared = Board()
    
    let size = 8
    var board = [[String]]()
    var previousBoardState = [[String]]()
    var boardCopy = [[String]]()
    var fenLog = [String]()
    
    var capturedPiecesWhite = [String : Int]()
    var capturedPiecesBlack = [String : Int]()
    var blackKingPosition: Position
    var whiteKingPosition: Position
    var lastMoveStart = Position(x: -1, y: -1)
    var lastMoveEnd = Position(x: -1, y: -1)
    
    var halfMove = 0
    var fullMove = 1
    var whiteTurn = true
    
    var whiteKingMoved = false
    var blackKingMoved = false
    var blackRookA1Moved = false
    var blackRookH1Moved = false
    var whiteRookA8Moved = false
    var whiteRookH8Moved = false
                                                
    var castleRightWhiteKingSide = true
    var castleRightWhiteQueenSide = true
    var castleRightBlackKingSide = true
    var castleRightBlackQueenSide = true
    
    var columnCoordinates = ["a", "b", "c", "d", "e", "f", "g", "h"]
    var rowCoordinates = ["8", "7", "6", "5", "4", "3", "2", "1"]
    
    var suggestedMoveFrom = Position(x: -1, y: -1)
    var suggestedMoveTo = Position(x: -1, y: -1)
    
    var isBot = true
    var useElo: Double?
    var useStrength: Double?
    
    var blackPoints = 0
    var whitePoints = 0
    
    init() {
        blackKingPosition = Position(x: 0, y: 4)
        whiteKingPosition = Position(x: 7, y: 4)
        
        createBoard()
        
        fenLog.append(generateFEN(isBot: isBot))
        observeBestMoveCoordinates()
    }
    
    private func createBoard() {
        let firstRow = ["r", "n", "b", "q", "k", "b", "n", "r"]
        let lastRow = ["R", "N", "B", "Q", "K", "B", "N", "R"]
        
        board.append(firstRow)
        
        for row in 1..<7 {
            var newCol = [String]()
            for _ in 0..<8 {
                newCol.append(row == 1 ? "p" : row == 6 ? "P" : "")
            }
            board.append(newCol)
        }
        board.append(lastRow)
        
        boardCopy = board
    }

    func movePiece(from: Position, to: Position) {
        guard from != Position(x: -1, y: -1) && to != Position(x: -1, y: -1) else { return }
        var capturedPiece = false
        let pawnPromoted = board[from.x][from.y].lowercased() == "p" && (to.x == 0 || to.x == 7) ? true : false
        
        previousBoardState = board
        
        if !board[to.x][to.y].isEmpty {
            // this means we have a capture
            board[to.x][to.y] = ""
            updateCapturedPieces()
            capturedPiece = true
        } else if board[to.x][to.y].isEmpty && board[from.x][from.y].lowercased() == "p" {
            // potential enpassant capture
            if abs(from.y - to.y) == 1 {
                // enpassant capture since pawn moving diagonally to an empty square
                if board[from.x][from.y] == "p" {
                    // black capturing white
                    board[to.x - 1][to.y] = ""
                } else {
                    // white capturing black
                    board[to.x + 1][to.y] = ""
                }
                updateCapturedPieces()
                capturedPiece = true
            }
        } else if board[from.x][from.y].lowercased() == "k" {
            
            if board[from.x][from.y].isLowercase {
                blackKingMoved = true
                castleRightBlackQueenSide = false
                castleRightBlackKingSide = false
            } else {
                whiteKingMoved = true
                castleRightWhiteQueenSide = false
                castleRightWhiteKingSide = false
            }
            
            if abs(from.y - to.y) > 1 {
                // have to swap rook positions, this is a castle.
                if (from.y - to.y) == -2 {
                    //kingside castle
                    let rook = board[from.x][7]
                    board[from.x][7] = ""
                    board[from.x][from.y + 1] = rook
                    
                    if rook.isLowercase {
                        blackRookH1Moved = true
                    } else {
                        whiteRookH8Moved = true
                    }
                } else {
                    // queenside castle
                    let rook = board[from.x][0]
                    board[from.x][0] = ""
                    board[from.x][from.y - 1] = rook
                    
                    if rook.isLowercase {
                        blackRookA1Moved = true
                    } else {
                        whiteRookA8Moved = true
                    }
                }
            }
        } else if board[from.x][from.y].lowercased() == "r" {
            // rook moved, need to flag that rook as moved and remove castle rights for that side
            if from == Position(x: 0, y: 0) {
                // A1 Rook moved
                blackRookA1Moved = true
                castleRightBlackQueenSide = false
            } else if from == Position(x: 0, y: 7) {
                // H1 Rook moved
                blackRookH1Moved = true
                castleRightBlackKingSide = false
            } else if from == Position(x: 7, y: 0) {
                // A8 Rook moved
                whiteRookA8Moved = true
                castleRightWhiteQueenSide = false
            } else if from == Position(x: 7, y: 7) {
                // H8 Rook moved
                whiteRookH8Moved = true
                castleRightWhiteKingSide = false
            }
        }
        
        let piece = board[from.x][from.y]
        board[from.x][from.y] = ""
        board[to.x][to.y] = piece
        
        if piece == "k" {
            blackKingPosition = to
        } else if piece == "K" {
            whiteKingPosition = to
        }
        
        lastMoveStart = from
        lastMoveEnd = to
        
        halfMove = capturedPiece || pawnPromoted ? 0 : halfMove + 1
        fullMove = piece.isLowercase ? fullMove + 1 : fullMove
        
        whiteTurn.toggle()
        
        boardCopy = board
        
        fenLog.append(generateFEN(isBot: isBot))
    }
    
    func generateFEN(isBot: Bool) -> String {
        var fen = ""
        var whiteKingSide = ""
        var whiteQueenSide = ""
        var blackKingSide = ""
        var blackQueenSide = ""
        var enPassant = ""
        
        for row in 0..<8 {
            var empty = 0
            var colFEN = ""
            for col in 0..<8 {
                if !board[row][col].isEmpty {
                    colFEN = empty == 0 ? colFEN + board[row][col] : colFEN + String(empty) + board[row][col]
                    empty = 0
                } else {
                    empty += 1
                }
            }
            if empty != 0 {
                fen += colFEN + String(empty) + "/"
            } else {
                fen += colFEN
                
                if row < 7 {
                    fen += "/"
                }
            }
        }
        
        if lastMoveEnd != Position(x: -1, y: -1) && lastMoveStart != Position(x: 1, y: 1) && (board[lastMoveEnd.x][lastMoveEnd.y].lowercased() == "p") && abs(lastMoveStart.x - lastMoveEnd.x) == 2 {
            if board[lastMoveEnd.x][lastMoveEnd.y] == "P" {
                enPassant += columnCoordinates[lastMoveEnd.y] + rowCoordinates[lastMoveEnd.x + 1] + " "
            } else {
                enPassant += columnCoordinates[lastMoveEnd.y] + rowCoordinates[lastMoveEnd.x - 1] + " "
            }
        }
        
        fen += whiteTurn ? " w " : " b "
        
        blackKingSide = castleRightBlackKingSide == true ? "k" : ""
        blackQueenSide = castleRightBlackQueenSide == true ? "q" : ""
        whiteKingSide = castleRightWhiteKingSide == true ? "K" : ""
        whiteQueenSide = castleRightWhiteQueenSide == true ? "Q" : ""
        
        let castleRights = whiteKingSide + whiteQueenSide + blackKingSide + blackQueenSide
        fen += castleRights.isEmpty ? "- " : castleRights + " "
        
        if enPassant.isEmpty {
            fen += "- "
        } else {
            fen += enPassant
        }
        
        fen += String(halfMove) + " " + String(fullMove)
        
        let sendFen = fen
        if isBot && !whiteTurn || !isBot {
            Task {
                await chessEngine.sendCommand("position fen \(sendFen);go movetime 2000")
            }
        }
        
        return fen
    }
    
    private func observeBestMoveCoordinates() {
        chessEngine.$bestMoveCoordinates
            .receive(on: DispatchQueue.main)
            .sink { [weak self] coordinates in
                guard let self = self else { return }
                self.handleBestMove(coordinates: coordinates)
            }
            .store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()
  
    private func handleBestMove(coordinates: ((Int, Int), (Int, Int))) {
        NSLog("Handling best move from (\(coordinates.0.0), \(coordinates.0.1)) to (\(coordinates.1.0), \(coordinates.1.1))")
        
        let from = Position(x: coordinates.0.0, y: coordinates.0.1)
        let to = Position(x: coordinates.1.0, y: coordinates.1.1)
        
        if (isBot && !whiteTurn) || !isBot {
            suggestedMoveFrom = from
            suggestedMoveTo = to
        }
    }
    
    func getPoints() -> Int {
        var blackPoints = 0
        capturedPiecesBlack.forEach { key, value in
            switch key {
            case "p":
                blackPoints += (value * 1)
            case "r":
                blackPoints += (value * 5)
            case "b":
                blackPoints += (value * 3)
            case "n":
                blackPoints += (value * 3)
            case "q":
                blackPoints += (value * 9)
            default:
                blackPoints += 0
            }
        }
        
        var whitePoints = 0
        capturedPiecesWhite.forEach { key, value in
            switch key {
            case "P":
                whitePoints += (value * 1)
            case "R":
                whitePoints += (value * 5)
            case "B":
                whitePoints += (value * 3)
            case "N":
                whitePoints += (value * 3)
            case "Q":
                whitePoints += (value * 9)
            default:
                whitePoints += 0
            }
        }
        
        return whitePoints - blackPoints
    }
    
    private func updateCapturedPieces() {
        capturedPiecesBlack = [
            "p" : 8,
            "r" : 2,
            "n" : 2,
            "b" : 2,
            "q" : 1
        ]
        capturedPiecesWhite = [
            "P" : 8,
            "R" : 2,
            "N" : 2,
            "B" : 2,
            "Q" : 1
        ]
        
        for row in 0..<8 {
            for col in 0..<8 {
                if board[row][col].lowercased() != "k" {
                    if board[row][col].isLowercase {
                        capturedPiecesBlack[board[row][col], default: 0] -= 1
                    } else {
                        capturedPiecesWhite[board[row][col], default: 0] -= 1
                    }
                }
            }
        }
    }
}
