//
//  PromotionDialogOverlayView.swift
//  ChessUpdated
//
//  Created by Borys Banaszkiewicz on 8/16/24.
//

import SwiftUI

struct PromotionDialogOverlayView: View {
    let details: (String, (String) -> Void)
    let size: CGFloat
    var onSelect: (String) -> Void

    var body: some View {
        VStack {
            HStack {
                ForEach(["q", "r", "b", "k"], id: \.self) { type in
                    let newPiece = createPiece(type: type, color: details.0)
                    Button(action: {
                        onSelect(newPiece)
                    }) {
                        Image(uiImage: UIImage(named: "\(newPiece)")!)
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .frame(width: size * 0.5, height: size * 0.25)
        .position(x: size / 2, y: size / 2)
    }
    
    private func createPiece(type: String, color: String) -> String {
        switch type {
        case "q":
            return color == "white" ? "Q" : "q"
        case "r":
            return color == "white" ? "R" : "r"
        case "b":
            return color == "white" ? "B" : "b"
        case "k":
            return color == "white" ? "K" : "k"
        default:
            return color == "white" ? "Q" : "q"
        }
    }
}
