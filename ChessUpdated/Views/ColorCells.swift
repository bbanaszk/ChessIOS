//
//  ColorCells.swift
//  ChessUpdated
//
//  Created by Borys Banaszkiewicz on 8/9/24.
//

import SwiftUI

extension ShapeStyle where Self == Color {
    static var squareStandard: Color {
        Color(red: 0.22, green: 0.25, blue: 0.3)
    }
    static var squareSelected: Color {
        Color.blue
    }
    static var squareLastMove: Color {
        Color("lastMove")
    }
    static var squareSuggestedMove: Color {
        Color("suggestedMove")
    }
    static var squareLegalMove: Color {
        Color(red: 0.1, green: 0.15, blue: 0.2)
    }
    static var squareLegalCapture: Color {
        Color.red
    }
    static var darkBackground: Color {
        Color(red: 0.1, green: 0.1, blue: 0.2)
    }
    
    static var lightSquare: Color {
        Color.white
    }
    
    static var darkSquare: Color {
        Color.orange
    }
}

struct ColorCells: View {
    var body: some View {
        VStack(spacing: 15) {
            Button("squareStandard color") {
                
            }
            .foregroundColor(.squareStandard)
            .font(.title.bold())
            
            Button("squareSelected color") {
                
            }
            .foregroundColor(.squareSelected)
            .font(.title.bold())
            
            Button("squareLastMove color") {
                
            }
            .foregroundColor(.squareLastMove)
            .font(.title.bold())
            
            Button("squareLegalMove color") {
                
            }
            .foregroundColor(.squareLegalMove)
            .font(.title.bold())
            
            Button("squareLegalCapture color") {
                
            }
            .foregroundColor(.squareLegalCapture)
            .font(.title.bold())
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ColorCells()
}
