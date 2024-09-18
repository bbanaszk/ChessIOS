//
//  CellView.swift
//  Sudoku
//
//  Created by Borys Banaszkiewicz on 8/7/24.
//

import SwiftUI

struct CellView: View {
    enum HighlightState {
        case standardLight, standardDark
        
        var color: Color {
            switch self {
            case .standardLight:
                return .lightSquare
            case .standardDark:
                return .darkSquare
            }
        }
    }
    
    enum HighlightMoves {
        case standard, legalMoves
        
        var color: Color {
            switch self {
            case .standard:
                return .clear
            case .legalMoves:
                return Color.black.opacity(0.7)
            }
        }
    }
    
    enum OverlayMove {
        case previousMove, standard, suggestedMoves
        
        var color: Color {
            switch self {
            case .previousMove:
                return .squareLastMove
            case .standard:
                return .clear
            case .suggestedMoves:
                return .squareSuggestedMove
            }
        }
    }

    let highlightState: HighlightState
    let highlightMoves: HighlightMoves
    let overlayMove: OverlayMove
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(highlightState.color)
                
            Circle()
                .fill(highlightMoves.color)
                .containerRelativeFrame(.horizontal) { size, axis in
                    size * 0.05
                }
        }
        .overlay(overlayMove.color)
    }
}
