import SwiftUI
import AVFoundation

struct MetronomeView: View {
    @State private var bpm: Double = 120
    @State private var isRunning: Bool = false
    @State private var timer: Timer?
    @State private var audioPlayer: AVAudioPlayer?

    private var beatInterval: TimeInterval {
        return 60.0 / bpm
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("BPM: \(Int(bpm))")
                .font(.title)
            
            Slider(value: $bpm, in: 40...200, step: 1)
                .padding()
                .accentColor(.blue)
            
            Button(action: {
                isRunning.toggle()
                if isRunning {
                    startMetronome()
                } else {
                    stopMetronome()
                }
            }) {
                Text(isRunning ? "Stop" : "Start")
                    .font(.title)
                    .padding()
                    .foregroundColor(.white)
                    .background(isRunning ? Color.red : Color.green)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
    
    private func startMetronome() {
        timer = Timer.scheduledTimer(withTimeInterval: beatInterval, repeats: true) { _ in
            playBeatSound()
        }
    }

    private func stopMetronome() {
        timer?.invalidate()
        timer = nil
    }
    
    private func playBeatSound() {
        guard let url = Bundle.main.url(forResource: "click", withExtension: "m4a") else {
            print("Sound file not found")
            return
        }

        do {
            // Set up the audio session to ignore silent mode
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
}
