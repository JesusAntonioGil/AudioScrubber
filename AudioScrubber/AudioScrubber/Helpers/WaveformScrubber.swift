//
//  WaveformScrubber.swift
//  AudioScrubber
//
//  Created by Jesus Antonio Gil on 25/3/25.
//

import SwiftUI
import AVKit


struct WaveformScrubber: View {
    struct Config {
        var spacing: Float = 2
        var shapeWidth: Float = 2
        var activeTint: Color = .black
        var inactiveTint: Color = .gray.opacity(0.7)
    }
    
    struct AudioInfo {
        var duration: TimeInterval = 0
    }
    
    
    var config: Config = .init()
    var url: URL
    // Scrubber Progress
    @Binding var progress: CGFloat
    var info: (AudioInfo) -> () = { _ in }
    var onGestureActive: (Bool) -> () = { _ in }
    // View Properties
    @State private var samples: [Float] = []
    @State private var downsizedSamples: [Float] = []
    
    
    var body: some View {
        Text("hola")
            .onAppear {
                initializeAudioFile()
            }
    }
}


extension WaveformScrubber {
    private func initializeAudioFile() {
        guard samples.isEmpty else { return }
        
        Task.detached(priority: .high) {
            do {
                let audioFile = try AVAudioFile(forReading: url)
                let audioInfo = extractAudioInfo(audioFile)
                let samples = try extractAudioSamples(audioFile)
                print(samples.count)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    nonisolated func extractAudioSamples(_ file: AVAudioFile) throws -> [Float] {
        let format = file.processingFormat
        let frameCount = UInt32(file.length)
        
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else {
            return []
        }
        
        try file.read(into: buffer)
        
        if let channel = buffer.floatChannelData {
            let samples = Array(UnsafeBufferPointer(start: channel[0], count: Int(buffer.frameLength)))
            return samples
        }
        
        return []
    }
    
    nonisolated func extractAudioInfo(_ file: AVAudioFile) -> AudioInfo {
        let format = file.processingFormat
        let sampleRate = format.sampleRate
        
        let duration = file.length / Int64(sampleRate)
        
        return .init(duration: TimeInterval(duration))
    }
}


#Preview {
    ContentView()
}
