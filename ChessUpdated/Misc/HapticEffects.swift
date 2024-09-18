//
//  HapticEffects.swift
//  ChessUpdated
//
//  Created by Borys Banaszkiewicz on 8/11/24.
//

import Foundation
import CoreHaptics

//@Observable
class HapticEffect: ObservableObject {
    @Published var engine: CHHapticEngine?
    
    func moveHaptic() {
        prepareHaptics()
        complexSuccess(intensityStepper: 0.7, sharpnessStepper: 0.5, eventStepper: 0.2)
    }
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    func complexSuccess(intensityStepper: Double, sharpnessStepper: Double, eventStepper: Double) {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        var events = [CHHapticEvent]()

        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(intensityStepper))
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(sharpnessStepper))
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: eventStepper)
        events.append(event)
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription)")
        }
    }
}
