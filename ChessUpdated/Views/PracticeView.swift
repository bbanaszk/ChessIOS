//
//  PracticeView.swift
//  ChessUpdated
//
//  Created by Borys Banaszkiewicz on 8/10/24.
//

import SwiftUI

struct OuterView2: View {
    var body: some View {
        VStack {
            Text("Top")
            
            InnerView2()
                .background(.green)
            
            Text("Bottom")
        }
    }
}

struct InnerView2: View {
    @State private var offset = CGSize.zero
    
    var body: some View {
        HStack {
            Text("Left")
            
            GeometryReader { proxy in
                Button {
                    let x = CGFloat(offset.width + 100)
                    let y = CGFloat(offset.height + 100)
//                    withAnimation(.easeInOut(duration: 5.9)) {
                        offset = CGSize(width: x, height: y)
//                    }
                } label: {
                    Image("b")
                        .background(.blue)
                }
                
                .offset(x: offset.width, y: offset.height)
                .onTapGesture {
                    print("Global center: \(proxy.frame(in: .global).midX) x \(proxy.frame(in: .global).midY)")
                    print("Custom center: \(proxy.frame(in: .named("Custom")).midX) x \(proxy.frame(in: .named("Custom")).midY)")
                    print("Local center: \(proxy.frame(in: .local).midX) x \(proxy.frame(in: .local).midY)")
                    withAnimation(.easeInOut(duration: 5.9)) { offset = .zero }
//                    offset = .zero
                }
                
            }
            
            .background(.orange)
            
            Text("Right")
        }
    }
    func changeOffset(x: CGFloat, y: CGFloat) {
        offset = CGSize(width: x, height: y)
    }
}

struct PracticeView: View {
    
    var body: some View {
        OuterView2()
            .background(.red)
            .coordinateSpace(name: "Custom")
    }
    
    
}

#Preview {
    PracticeView()
}
