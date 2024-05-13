//
//  AVFSpeech.swift
//  wanderhub
//
//  Created by Alexey Kovalenko on 3/30/24.
//

import UIKit
import AVKit
import SwiftUI

struct Talk: View {
//    var inputMessage = "The Eiffel Tower is a wrought-iron lattice tower located on the Champ de Mars in Paris, France. It is named after the engineer Gustave Eiffel, whose company designed and built the tower. Constructed from 1887 to 1889 as the entrance to the 1889 World's Fair, it was initially criticized by some of France's leading artists and intellectuals for its design but has become a global cultural icon of France and one of the most recognizable structures in the world. The Eiffel Tower is 330 meters (1,083 feet) tall, about the same height as an 81-story building. Its base is square, measuring 125 meters (410 feet) on each side. During its construction, the Eiffel Tower surpassed the Washington Monument to become the tallest man-made structure in the world, a title it held for 41 years until the Chrysler Building in New York City was finished in 1930. Originally intended to last only 20 years, the Eiffel Tower was saved by its usefulness as a radiotelegraph station. Today, it is a major tourist attraction, with millions of visitors ascending the tower each year to enjoy its panoramic views of Paris."
    
    var inputMessage = "The Eiffel Tower is a big metal tower in Paris, France. It was built in 1889 for a big fair called the World's Fair to show off France's engineering skills. It's named after Gustave Eiffel, the engineer whose company designed and built it. When it was first built, it was the tallest building in the world. It's 324 meters tall, that's like stacking about 81 stories of a building on top of each other! People from all over the world come to see it, making it one of the most visited monuments that you have to pay to enter. At first, not everyone liked it, but now it's a famous symbol of France. It has lights that make it sparkle at night, and you can go up to see a beautiful view of Paris."
    
    @State private var speechSynthesizer = AVSpeechSynthesizer() // Initialize here to avoid multiple instances
    
    var body: some View {
        Button("Click Me") {
            speak(input: inputMessage)
        }
        .buttonStyle(.borderedProminent)
        .onAppear {
            setupAudioSession()
            listHighQualityVoiceIdentifiers() // Optionally list available high-quality voices
        }
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .duckOthers)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("AudioSession error: \(error)")
        }
    }
    
    private func speak(input: String) {
        let speechUtterance = AVSpeechUtterance(string: input)
        speechUtterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.voice.premium.en-US.Zoe") // You might prefer a specific identifier
        speechUtterance.rate = 0.45 // Adjust speech rate, range: 0.0(min) to 1.0(max)
        speechUtterance.pitchMultiplier = 1.0 // Adjust pitch, range: 0.5(min) to 2.0(max)
        speechUtterance.volume = 1.0 // Adjust volume, range: 0.0(min) to 1.0(max)
        
        speechSynthesizer.speak(speechUtterance)
    }
    
    private func listHighQualityVoiceIdentifiers() {
        let voices = AVSpeechSynthesisVoice.speechVoices().filter { $0.quality == .premium }
        for voice in voices {
            print("Identifier: \(voice.identifier), Language: \(voice.language), Name: \(voice.name)")
        }
    }
}
