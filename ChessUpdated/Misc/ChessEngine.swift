import Foundation
import Combine

//class ChessEngine: ObservableObject {
//    private let stockfishWrapper = StockfishWrapper()
//
//    var response: String = ""
//    var bestMove: String = ""
//    @Published var bestMoveCoordinates: ((Int, Int), (Int, Int)) = ((-1, -1), (-1, -1))
//    
//    private var engineQueue = DispatchQueue(label: "com.chessEngine.queue", qos: .userInitiated)
//    
//    var onResponse: ((String) -> Void)?
//    
//    private enum EngineState {
//        case idle, waitingForUciOk, waitingForReadyOk, ready
//    }
//    
//    private var engineState: EngineState = .idle
//    
//    init() {
//        engineQueue.async { [weak self] in
//            self?.stockfishWrapper.startEngine()
//            self?.stockfishWrapper.onResponse = { [weak self] output in
//                guard let self = self else { return }
//                if let output = output {
//                    self.engineQueue.async {
//                        self.handleResponse(output)
//                        DispatchQueue.main.async {
//                            self.onResponse?(output)
//                        }
//                    }
//                }
//            }
//            self?.sendUciCommand()
//        }
//    }
//
//    private func sendUciCommand() {
//        engineState = .waitingForUciOk
//        sendCommand("uci")
//    }
//    
//    private func sendIsReadyCommand() {
//        engineState = .waitingForReadyOk
//        sendCommand("isready")
//    }
//
//    func sendCommand(_ command: String) {
//        engineQueue.async { [weak self] in
//            self?.sendCommandToEngine(command)
//        }
//    }
//    
//    private func sendCommandToEngine(_ command: String) {
//        stockfishWrapper.sendCommand(command)
//    }
//    
//    private func handleResponse(_ response: String) {
//        self.response += response
//        parseResponse(response)
//    }
//    
//    private func parseResponse(_ response: String) {
//        NSLog("Received response: \(response)")
//        if !response.isEmpty {
//            let moves = response.split(separator: ", ")
//            self.bestMove = moves[0].trimmingCharacters(in: .whitespacesAndNewlines)
//        }
//
//        let coordinates = convertChessNotation(self.bestMove)
//        DispatchQueue.main.async { [weak self] in
//            self?.bestMoveCoordinates = coordinates
//        }
//    }
//    
//    func convertChessNotation(_ move: String) -> ((row: Int, col: Int), (row: Int, col: Int)) {
//        guard move.count == 4 else { return ((-1, -1), (-1, -1)) }
//
//        let fileToCol: [Character: Int] = [
//            "a": 0, "b": 1, "c": 2, "d": 3,
//            "e": 4, "f": 5, "g": 6, "h": 7
//        ]
//
//        let rankToRow: [Character: Int] = [
//            "1": 7, "2": 6, "3": 5, "4": 4,
//            "5": 3, "6": 2, "7": 1, "8": 0
//        ]
//
//        let startFile = move[move.startIndex]
//        let startRank = move[move.index(after: move.startIndex)]
//        let endFile = move[move.index(move.startIndex, offsetBy: 2)]
//        let endRank = move[move.index(before: move.endIndex)]
//
//        if let startCol = fileToCol[startFile], let startRow = rankToRow[startRank],
//           let endCol = fileToCol[endFile], let endRow = rankToRow[endRank] {
//            return ((startRow, startCol), (endRow, endCol))
//        }
//
//        return ((-1, -1), (-1, -1))
//    }
//}

class ChessEngine: ObservableObject {
    private let stockfishWrapper = StockfishWrapper()

    var response: String = ""
    var bestMove: String = ""
    @Published var bestMoveCoordinates: ((Int, Int), (Int, Int)) = ((-1, -1), (-1, -1))
        
    var onResponse: ((String) -> Void)?
        
    init() {
        stockfishWrapper.startEngine()
        stockfishWrapper.onResponse = { [weak self] output in
            guard let self = self else { return }
            if let output = output {
                    self.handleResponse(output)
                    self.onResponse?(output)
            }
        }
        sendInitCommand()
    }

    private func sendInitCommand() {
        Task {
            await sendCommand("uci")
            await sendCommand("isready")
        }
    }

    func sendCommand(_ command: String) async {
        await self.sendCommandToEngine(command)
    }
    
    private func sendCommandToEngine(_ command: String) async {
        stockfishWrapper.sendCommand(command)
    }
    
    private func handleResponse(_ response: String) {
        parseResponse(response)
    }
    
    private func parseResponse(_ response: String) {
        NSLog("Received response: \(response)")
        if !response.isEmpty {
            let moves = response.split(separator: ", ")
            self.bestMove = moves[0].trimmingCharacters(in: .whitespacesAndNewlines)
        }

        let coordinates = convertChessNotation(self.bestMove)
        self.bestMoveCoordinates = coordinates
    }
    
    func convertChessNotation(_ move: String) -> ((row: Int, col: Int), (row: Int, col: Int)) {
        guard move.count == 4 else { return ((-1, -1), (-1, -1)) }

        let fileToCol: [Character: Int] = [
            "a": 0, "b": 1, "c": 2, "d": 3,
            "e": 4, "f": 5, "g": 6, "h": 7
        ]

        let rankToRow: [Character: Int] = [
            "1": 7, "2": 6, "3": 5, "4": 4,
            "5": 3, "6": 2, "7": 1, "8": 0
        ]

        let startFile = move[move.startIndex]
        let startRank = move[move.index(after: move.startIndex)]
        let endFile = move[move.index(move.startIndex, offsetBy: 2)]
        let endRank = move[move.index(before: move.endIndex)]

        if let startCol = fileToCol[startFile], let startRow = rankToRow[startRank],
           let endCol = fileToCol[endFile], let endRow = rankToRow[endRank] {
            return ((startRow, startCol), (endRow, endCol))
        }

        return ((-1, -1), (-1, -1))
    }
}
