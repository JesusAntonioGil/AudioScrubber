//
//  ContentView.swift
//  AudioScrubber
//
//  Created by Jesus Antonio Gil on 25/3/25.
//

import SwiftUI


struct ContentView: View {
    @State private var progress: CGFloat = 0.5
    
    
    var body: some View {
        NavigationStack {
            List {
                if let audioURL {
                    Section("audio.mp3") {
                        WaveformScrubber(url: audioURL, progress: $progress) { info in
                            print(info.duration)
                        } onGestureActive: { status in
                            
                        }
                        .frame(height: 60)
                    }
                }
                
                Slider(value: $progress)
            }
            .navigationTitle("Waveform Scrubber")
        }
    }
    
    var audioURL: URL? {
        Bundle.main.url(forResource: "audio", withExtension: "mp3")
    }
}


#Preview {
    ContentView()
}
