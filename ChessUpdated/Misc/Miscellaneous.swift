//
//  Miscellaneous.swift
//  ChessUpdated
//
//  Created by Borys Banaszkiewicz on 8/10/24.
//

import Foundation

struct Position: Equatable, Hashable, Codable {
    let x: Int
    let y: Int
    
    func destructure() -> (Int, Int) {
        return (x, y)
    }
}
//
//enum Moves {
//    case leftHorizontal, rightHorizontal, verticalTop, verticalDown, knight, topLeftDiagonal, bottomLeftDiagonal, topRightDiagonal, bottomRightDiagonal, pawnWhite, pawnBlack, king
//    
//    func pieceMoves(from position: Position) -> Set<Position> {
//        let row = position.x
//        let col = position.y
//        
//        switch self {
//        case .leftHorizontal:
//            return Set((1...7).compactMap { col - $0 >= 0 ? Position(x: row, y: col - $0) : nil })
//        case .rightHorizontal:
//            return Set((1...7).compactMap { col + $0 < 8 ? Position(x: row, y: col + $0) : nil })
//        case .verticalTop:
//            return Set((1...7).compactMap { row - $0 >= 0 ? Position(x: row - $0, y: col) : nil })
//        case .verticalDown:
//            return Set((1...7).compactMap { row + $0 < 8 ? Position(x: row + $0, y: col) : nil })
//        case .knight:
//            return Set([Position(x: row - 2, y: col - 1), Position(x: row - 1, y: col - 2),
//                        Position(x: row + 1, y: col - 2), Position(x: row + 2, y: col - 1),
//                        Position(x: row + 2, y: col + 1), Position(x: row + 1, y: col + 2),
//                        Position(x: row - 1, y: col + 2), Position(x: row - 2, y: col + 1)])
//        case .topLeftDiagonal:
//            return Set((1...7).compactMap { row - $0 >= 0 && col - $0 >= 0 ? Position(x: row - $0, y: col - $0) : nil })
//        case .bottomLeftDiagonal:
//            return Set((1...7).compactMap { row + $0 < 8 && col - $0 >= 0 ? Position(x: row + $0, y: col - $0) : nil })
//        case .topRightDiagonal:
//            return Set((1...7).compactMap { row - $0 >= 0 && col + $0 < 8 ? Position(x: row - $0, y: col + $0) : nil })
//        case .bottomRightDiagonal:
//            return Set((1...7).compactMap { row + $0 < 8 && col + $0 < 8 ? Position(x: row + $0, y: col + $0) : nil })
//        case .pawnWhite:
//            var pawnMoves = Set<Position>()
//            pawnMoves.insert(Position(x: row - 1, y: col))
//            if row == 6 {
//                pawnMoves.insert(Position(x: row - 2, y: col))
//            }
//            return pawnMoves
//        case .pawnBlack:
//            var pawnMoves = Set<Position>()
//            pawnMoves.insert(Position(x: row + 1, y: col))
//            if row == 1 {
//                pawnMoves.insert(Position(x: row + 2, y: col))
//            }
//            return pawnMoves
//        case .king:
//            return Set([
//                Position(x: row, y: col - 1), Position(x: row - 1, y: col - 1),
//                Position(x: row - 1, y: col), Position(x: row - 1, y: col + 1),
//                Position(x: row, y: col + 1), Position(x: row + 1, y: col - 1),
//                Position(x: row + 1, y: col), Position(x: row + 1, y: col + 1)
//            ])
//        }
//    }
//}

//case "r", "R":
//   return Moves.leftHorizontal.union(Moves.rightHorizontal).union(Moves.verticalTop).union(Moves.verticalDown)
//case "b", "B":
//   return Moves.topLeftDiagonal.union(Moves.topRightDiagonal).union(Moves.bottomLeftDiagonal).union(Moves.bottomRightDiagonal)
//case "n", "N":
//   return Moves.knight
//case "p":
//   return Moves.pawnBlack
//case "P":
//   return Moves.pawnWhite
//case "q", "Q":
//   return Moves.leftHorizontal.union(Moves.rightHorizontal).union(Moves.verticalTop).union(Moves.verticalDown).union(Moves.topLeftDiagonal).union(Moves.topRightDiagonal).union(Moves.bottomLeftDiagonal).union(Moves.bottomRightDiagonal)
//case "k", "K":
//   return Moves.king
