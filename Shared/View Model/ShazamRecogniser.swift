//
//  ShazamRecogniser.swift
//  ShazamRecogniser
//
//  Created by Hugo Mason on 26/08/2021.
//

import SwiftUI
import ShazamKit
import AVKit

class ShazamRecogniser: NSObject, ObservableObject, SHSessionDelegate {
    
    @Published var session = SHSession()
    
    // audio delegate
    @Published var audioEngine = AVAudioEngine()
    
    // error
    @Published var errorMsg = ""
    @Published var showError = false
    
    // recording status
    @Published var isRecording = false
    
    // found track
    @Published var matchedTrack: Track!
    
    override init() {
        super.init()
        // setting delegate
        session.delegate = self
    }
    
    func session(_ session: SHSession, didFind match: SHMatch) {
        // match found
        if let firstItem = match.mediaItems.first {
            
            print(Track(title: firstItem.title ?? "",
                                       artist: firstItem.artist ?? "",
                                       artwork: firstItem.artworkURL ?? URL(string: "")!,
                                       genres: firstItem.genres,
                                       appleMusicURL: firstItem.appleMusicURL ?? URL(string: "")!))
                  
            DispatchQueue.main.async {
                self.matchedTrack = Track(title: firstItem.title ?? "",
                                          artist: firstItem.artist ?? "",
                                          artwork: firstItem.artworkURL ?? URL(string: "")!,
                                          genres: firstItem.genres,
                                          appleMusicURL: firstItem.appleMusicURL ?? URL(string: "")!)
                self.stopRecording()
            }
        }
    }
    
    func session(_ session: SHSession, didNotFindMatchFor signature: SHSignature, error: Error?) {
        // no match...
        DispatchQueue.main.async {
            self.errorMsg = error?.localizedDescription ?? "No music found..."
            self.showError.toggle()
            // stopping audio recording
            self.stopRecording()
        }
    }
    
    func stopRecording() {
        audioEngine.stop()
        withAnimation {
            isRecording = false
        }
    }
    
    // fetch music
    func listenMusic() {
        let audioSession = AVAudioSession.sharedInstance()
        
        // checking fro permission
        audioSession.requestRecordPermission { status in
            
            if status {
                self.recordAudio()
            }
            else {
                self.errorMsg = "Please allow microphone access"
                self.showError.toggle()
            }
        }
    }
    
    func recordAudio() {
        
        // checking if already recording
        // then stopping it
        if audioEngine.isRunning {
            self.stopRecording()
            return
        }
        
        // recording audio
        // first create a node
        // then listen to it
        let inputNode = audioEngine.inputNode
        // format
        let format = inputNode.outputFormat(forBus: .zero)
        
        // removing tap if already installed
        inputNode.removeTap(onBus: .zero)
        
        // installing tap
        inputNode.installTap(onBus: .zero, bufferSize: 1024, format: format) { buffer, time in
            // it will listen to music continuously
            // start shazam sesssion
            self.session.matchStreamingBuffer(buffer, at: time)
        }
        
        // starting audio  service
        audioEngine.prepare()
        do {
            try audioEngine.start()
            print("started")
            withAnimation {
                self.isRecording = true
            }
        }
        catch {
            self.errorMsg = error.localizedDescription
            self.showError.toggle()
        }
    }
}
