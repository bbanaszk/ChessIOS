//
//  StockfishPractice.swift
//  ChessUpdated
//
//  Created by Borys Banaszkiewicz on 8/13/24.
//

import SwiftUI
import Foundation

struct StockfishPractice: View {
//    @State private var command: String = ""
//    @State private var response: String = ""
//    private var stockfishWrapper = StockfishWrapper()
//    
    var body: some View {
//        VStack {
            Text("Stockfish Test Interface")
//                .font(.largeTitle)
//                .padding()
//            
//            TextField("Enter Command", text: $command)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding()
//                .autocapitalization(.none)
//                .disableAutocorrection(true)
//            
//            Button("Send Command") {
//                Task {
//                    response = await stockfishWrapper.sendCommandAsync(command)
//                    print("Response: \(response)")
//                }
//            }
//            Text("Response")
//                .font(.headline)
//                .padding()
//            
//            ScrollView {
//                Text(response)
//                    .padding()
//                    .border(Color.gray, width: 1)
//                    .cornerRadius(10)
//            }
//            .padding()
//        }
//        .padding()
//        .task {
//            await stockfishWrapper.startEngineAsync()
//        }
    }
    //rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1
//////    uci;isready;rnbqkbnr/pppppppp/8/8/3P4/8/PPP1PPPP/RNBQKBNR b KQkq d3 1 1;go depth 2
}

//extension StockfishWrapper {
//    func sendCommandAsync(_ command: String, expectResponse: Bool = true) async -> String {
//        return await withCheckedContinuation { continuation in
//            self.sendCommand(command, expectResponse: expectResponse) { response in
//                if let response = response {
//                    continuation.resume(returning: response)
//                } else {
//                    continuation.resume(returning: "")
//                }
//            }
//        }
//    }
//    
//    func startEngineAsync() async {
//        self.startEngine()
//        print("UCI Response: \(await sendCommandAsync("uci"))")
//        print("Ready Response: \(await sendCommandAsync("isready"))")
//        print("Empty Response: \(await sendCommandAsync("position startpos", expectResponse: false))")
//        print("Engine started and ready.")
//        
//        print("First move Response: \(await sendCommandAsync("go depth 5"))")
//    }
//}

#Preview {
    StockfishPractice()
}
