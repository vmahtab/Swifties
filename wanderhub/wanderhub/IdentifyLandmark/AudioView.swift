//
//  AudioView.swift
//  wanderhub
//
//  Created by Alexey Kovalenko on 4/11/24.
//

import SwiftUI
import Observation

// Feel free to add more into audio View so it can display the text, etc.
struct AudioView: View {
    @Binding var isPresented: Bool
    @Environment(AudioPlayer.self) private var audioPlayer
    let textToSpeechScript: String // Added property
    
    var body: some View {
        VStack {
            // view to be defined
            Spacer()
            HStack {
                if audioPlayer.waiting_for_response {
                    VStack{
                        Text("Text to Speech loading")
                        ProgressView()
                    }
                }
                else {
                    Spacer()
                        .frame(width: 43)
                    StopButton()
                    Spacer()
                        .frame(width: 50)
                    RwndButton()
                    Spacer()
                        .frame(width: 50)
                    PlayButton()
                    Spacer()
                        .frame(width: 60)
                    FfwdButton()
                    Spacer()
                }
//                Spacer()
//                DoneButton(isPresented: $isPresented)
            }
            Spacer()
        }
        
        
        
        .onAppear {
            audioPlayer.txt2speech(text: textToSpeechScript) {
                print("sone speaking")
            }
        }
        .onDisappear {
            audioPlayer.doneTapped()
        }
    }
}



@Observable
final class PlayerUIState {
    
    
    var playCtlDisabled = true
    var playDisabled = true
    var playIcon = Image(systemName: "play")
    
    var doneIcon = Image(systemName: "xmark.square") // initial value
    
    private func reset() {
        
        
        playCtlDisabled = true
        
        playIcon = Image(systemName: "play")
        
        
    }
    
    private func playCtlEnabled(_ enabled: Bool) {
        playCtlDisabled = !enabled
    }
    
    private func playEnabled(_ enabled: Bool) {
        playIcon = Image(systemName: "play")
        playDisabled = !enabled
    }
    
    private func pauseEnabled(_ enabled: Bool) {
        playIcon = Image(systemName: "pause")
        playDisabled = !enabled
    }
    
    
    func propagate(_ playerState: PlayerState) {
        switch (playerState) {
        case .start(.play):
            playEnabled(true)
            playCtlEnabled(false)
            doneIcon = Image(systemName: "xmark.square")
        case .start(.standby):
            playEnabled(true)
            playCtlEnabled(false)
        case .paused:
            playIcon = Image(systemName: "play")
        case .playing:
            pauseEnabled(true)
            playCtlEnabled(true)
        }
    }
}


struct DoneButton: View {
    @Binding var isPresented: Bool
    @Environment(AudioPlayer.self) private var audioPlayer
    
    var body: some View {
        Button {
            audioPlayer.doneTapped()
            isPresented.toggle()
        } label: {
            audioPlayer.playerUIState.doneIcon.scaleEffect(2.0).padding(.trailing, 40)
        }
    }
}

//Implement StopButtion
struct StopButton: View {
    @Environment(AudioPlayer.self) private var audioPlayer
    
    var body: some View {
        Button {
            audioPlayer.stopTapped()
        } label: {
            Image(systemName: "stop")
                .scaleEffect(2.0)
                .padding(.trailing, 20)
        }
        .disabled(audioPlayer.playerUIState.playCtlDisabled)
    }
}

//Implement RwndButton
struct RwndButton: View {
    @Environment(AudioPlayer.self) private var audioPlayer
    
    var body: some View {
        Button {
            audioPlayer.rwndTapped()
        } label : {
            Image(systemName: "gobackward.10")
                .scaleEffect(2.0)
                .padding(.trailing, 20)
        }
        .disabled(audioPlayer.playerUIState.playCtlDisabled)
    }
}

//Implement FfwdButton
struct FfwdButton: View {
    @Environment(AudioPlayer.self) private var audioPlayer
    
    var body: some View {
        Button {
            audioPlayer.ffwdTapped()
        } label : {
            Image(systemName: "goforward.10")
                .scaleEffect(2.0)
                .padding(.trailing, 20)
        }
        .disabled(audioPlayer.playerUIState.playCtlDisabled)
    }
}

//Implement PlayButton
struct PlayButton: View {
    @Environment(AudioPlayer.self) private var audioPlayer
    
    var body: some View {
        if audioPlayer.waiting_for_response {
            ProgressView()
        } else {
            Button {
                audioPlayer.playTapped()
            } label: {
                audioPlayer.playerUIState.playIcon
                    .scaleEffect(2.0)
                    .padding(.trailing, 20)
            }
        }
    }
}
