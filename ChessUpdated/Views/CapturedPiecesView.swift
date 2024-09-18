
import SwiftUI

struct CapturedPiecesView: View {
    var capturedPieces: [String: Int]
    var color: String
    
    @Binding var points: Int
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                .fill(.secondary.opacity(0.5))
                .brightness(0.5)
                
                .frame(width: 350, height: 35, alignment: .leading)
            Text(points == 0 ? "" : points > 0 && color == "white" ? "+\(points)" : points < 0 && color == "black" ? "+\(abs(points))" : "")
                .frame(maxWidth: 300, alignment: .trailing)
            
            HStack(spacing: -15) {
                let order = ["q", "r", "b", "n", "p", "Q", "R", "B", "N", "P"]
                
                ForEach(order, id: \.self) { type in
                    if let count = capturedPieces[type], count > 0 {
                        ForEach(0..<count, id: \.self) { _ in
                            if let img = UIImage(named: type) {
                                Image(uiImage: img)
                                    .resizable()
                                    .frame(width: 35, height: 35)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
