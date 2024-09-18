//
//  Untitled.swift
//  ChessUpdated
//
//  Created by Borys Banaszkiewicz on 8/16/24.
//

import SwiftUI

struct SettingsView: View {
    @Binding var showingSettings: Bool
    @Binding var eloSetting: Double
    @Binding var engineStrength: Double
    @State private var isEditingElo = false
    @State private var isEditingStrength = false
    @State private var gameOver = false
    
    @State private var previousEloSetting = 1320.0
    @State private var previousEngineStrength = 0.0
    
    @Binding var useElo: Bool
    @Binding var useStrength: Bool
    @Binding var isBot: Bool
    @Binding var showAnalyzer: Bool
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                Toggle("Play against Bot", isOn: $isBot)
                Spacer()
            }
            .padding()
            HStack {
                Spacer()
                Toggle("Show analyzer", isOn: $showAnalyzer)
                Spacer()
            }
            .padding()
            HStack(spacing: 30) {
 
                Text("Use Strength")
                Spacer()
                Toggle("", isOn: $useElo)
                    .labelsHidden()
                Spacer()
                Text("Use ELO")

            }
            .padding()
            
            if useElo {
                VStack {
                    Text("Adjust ELO")
                    Slider(
                        value: $eloSetting,
                        in: 1320...3190,
                        step: 10,
                        onEditingChanged: { editing in
                            isEditingElo = editing
                            previousEloSetting = eloSetting
                        }
                    )
                    
                    HStack {
                        Text("ELO:")
                            .foregroundColor(.blue)
                        Text("\(Int(eloSetting))")
                            .foregroundColor(isEditingElo ? adjustColor(eloSetting, previousEloSetting) : .blue)
                    }
                }
                .padding(50)
            } else {
                VStack {
                    Text("Adjust Engine Strength")
                    Slider(
                        value: $engineStrength,
                        in: 0...20,
                        step: 1,
                        onEditingChanged: { editing in
                            isEditingStrength = editing
                            previousEngineStrength = engineStrength
                        }
                    )
                    HStack {
                        Text("Engine Strength:")
                            .foregroundColor(.blue)
                        Text("\(Int(engineStrength))")
                            .foregroundColor(isEditingStrength ? adjustColor(engineStrength, previousEngineStrength) : .blue)
                    }
                }
                .padding(50)
            }
            Spacer()
            VStack {
                Button("Done") {
                    showingSettings = false
                }
                .foregroundColor(.blue)
            }
        }
    }
    
    private func adjustColor(_ setting: Double, _ previousSetting: Double) -> Color {
        if setting > previousSetting {
            return .green
        } else if setting < previousSetting {
            return .red
        } else {
            return .blue
        }
    }
}


#Preview {
    ContentView()
}
