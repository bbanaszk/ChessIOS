//
//  AnimationPractice.swift
//  ChessUpdated
//
//  Created by Borys Banaszkiewicz on 8/11/24.
//

import SwiftUI

struct AnimationPractice: View {
    @State private var animationAmount = 1.0
    
    var body: some View {
        Button("Tap me") {
            animationAmount += 1
        }
        .padding(50)
        .background(.red)
        .foregroundStyle(.white)
        .clipShape(.circle)
        .scaleEffect(animationAmount)
        .animation(.default, value: animationAmount)
    }
}

#Preview {
    AnimationPractice()
}
