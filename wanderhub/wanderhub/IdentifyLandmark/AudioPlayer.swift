//
//  File.swift
//  wanderhub
//
//  Created by Alexey Kovalenko on 4/11/24.
//

import Foundation
import AVFoundation
import Observation

// this is a list of voices available
enum VoiceType: String {
    case undefined
    case waveNetFemale = "en-US-Wavenet-F"
    case waveNetMale = "en-US-Wavenet-D"
    case standardFemale = "en-US-Standard-E"
    case standardMale = "en-US-Standard-D"
}


//URL and API key to use Google
let ttsAPIUrl = "https://texttospeech.googleapis.com/v1/text:synthesize"
let APIKey = speechCred

//This class is basically the player from the lab + some functions that transform text to speech
@Observable
final class AudioPlayer: NSObject, AVAudioPlayerDelegate {
    var audio: Data! = nil
    var waiting_for_response = true
    
    @ObservationIgnored let playerUIState = PlayerUIState()
    @ObservationIgnored var playerState = PlayerState.start(.standby){
        didSet {playerUIState.propagate(playerState)}
    }
    
    
    private(set) var busy: Bool = false
    private var completionHandler: (() -> Void)?
    
    // This funciton will transform text to speech and start playback automatically.
    func txt2speech(text: String, voiceType: VoiceType = .standardMale, completion: @escaping () -> Void) {
        guard !self.busy else {
            print("Speech Service busy!")
            return
        }
        
        self.busy = true
        
        DispatchQueue.global(qos: .background).async {
            let postData = self.buildPostData(text: text, voiceType: voiceType)
            let headers = ["X-Goog-Api-Key": APIKey, "Content-Type": "application/json; charset=utf-8"]
            let response = self.makePOSTRequest(url: ttsAPIUrl, postData: postData, headers: headers)
            //print(response)
            // Get the `audioContent` (as a base64 encoded string) from the response.
            guard let audioContent = response["audioContent"] as? String else {
                print("Invalid response: \(response)")
                self.busy = false
                DispatchQueue.main.async {
                    completion()
                }
                return
            }
            
            // Decode the base64 string into a Data object
            guard let audioData = Data(base64Encoded: audioContent) else {
                self.busy = false
                DispatchQueue.main.async {
                    completion()
                }
                return
            }
            
            DispatchQueue.main.async {
                self.completionHandler = completion
                self.audio = audioData
                self.preparePlayer()
                //self.playTapped()
                self.waiting_for_response = false
            }
        }
    }
    
    // formats the post request and returns it
    private func buildPostData(text: String, voiceType: VoiceType) -> Data {
        
        var voiceParams: [String: Any] = [
            // All available voices here: https://cloud.google.com/text-to-speech/docs/voices
            "languageCode": "en-US"
        ]
        
        if voiceType != .undefined {
            voiceParams["name"] = voiceType.rawValue
        }
        
        let params: [String: Any] = [
            "input": [
                "text": text
            ],
            "voice": voiceParams,
            "audioConfig": [
                // All available formats here: https://cloud.google.com/text-to-speech/docs/reference/rest/v1beta1/text/synthesize#audioencoding
                "audioEncoding": "LINEAR16"
            ]
        ]

        // Convert the Dictionary to Data
        let data = try! JSONSerialization.data(withJSONObject: params)
        return data
    }
    
    // Just a function that makes a POST request to google.
    private func makePOSTRequest(url: String, postData: Data, headers: [String: String] = [:]) -> [String: AnyObject] {
        var dict: [String: AnyObject] = [:]
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.httpBody = postData

        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        
        // Using semaphore to make request synchronous
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
                dict = json
            }
            
            semaphore.signal()
        }
        
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
        return dict
    }
    
    
    
    
    private let audioSession = AVAudioSession.sharedInstance()
    private var audioPlayer: AVAudioPlayer! = nil
    
    override init() {
        super.init()
        do {
            try audioSession.setCategory(.playback)
            try audioSession.setActive(true)
        } catch {
            print("audioPlayer: failed to setup AVAudioSession")
        }
    }
    
    private func preparePlayer() {
        audioPlayer = try? AVAudioPlayer(data: audio)
        guard let audioPlayer else {
            print("preparePlayer: incompatible audio encoding.")
            return
        }
        audioPlayer.volume = 10.0
        audioPlayer.delegate = self
        audioPlayer.prepareToPlay()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playerState.transition(.stopTapped)
    }
    
    func playTapped() {
        guard let audioPlayer else {
            print("playTapped: no AudioPlayer!")
            return
        }
        playerState.transition(.playTapped)
        if audioPlayer.isPlaying {
            audioPlayer.pause()
        } else {
            audioPlayer.play()
        }
    }
    func rwndTapped() {
        audioPlayer.currentTime = max(0, audioPlayer.currentTime - 10.0) //seconds
    }
    
    func ffwdTapped() {
        audioPlayer.currentTime = min(audioPlayer.duration, audioPlayer.currentTime + 10.0) // seconds
    }
    
    func stopTapped() {
        guard let audioPlayer else {
            print("stop tapped: no AudioPlayer!")
            return
        }
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        playerState.transition(.stopTapped)
    }
    
    func doneTapped() {
        defer {
            if let _ = audio {
                playerState.transition(.doneTapped)
            }
        }
        if let _ = audioPlayer {
            stopTapped()
        }
    }
    
    
}


enum StartMode {
    case standby, play
}


enum PlayerState: Equatable {
    case start(StartMode)
    case playing(StartMode)
    case paused(StartMode)
    
    enum TransEvent {
        case playTapped, stopTapped, failed, doneTapped
    }
    
    
    mutating func transition(_ event: TransEvent) {
        if (event == .doneTapped) {
            self = .start(.standby)
            return
        }
        
        switch self {
            case .start(.play) where event == .playTapped:
                self = .playing(.play)
            case .start(.standby):
                switch event {
                    case .playTapped:
                        self = .playing(.standby)
                    default:
                        break
                }
        case .playing(let parent):
            switch event {
            case .playTapped:
                self = .paused(parent)
            case .stopTapped, .failed:
                self = .start(parent)
            default:
                break
            }
        case .paused(let grand):
            switch event {
            case .playTapped:
                self = .playing(grand)
            case .stopTapped:
                self = .start(.standby)
            default:
                break
            }
        default:
            break
        }
        
        
    }
}
