//
//  CustomMusicScreen.swift
//  flocus
//
//  Created by Steffany Florence on 08/04/26.
//

import SwiftUI
import AVFoundation

struct Track {
    let title: String
    let fileName: String
}

struct CustomMusicScreen: View {
    // MARK: - Binding
    @Binding var isPresented: Bool
    
    // MARK: - State
    @State var selectedTab = 0
    @State var audioPlayer: AVAudioPlayer?
    
    // MARK: - Storage
    @AppStorage("selected_music_file") var selectedMusic: String = "BirdSound"
    
    
    // MARK: - Properties
    let musicList: [Track] = [
        Track(title: "Birds Chirping", fileName: "BirdSound"),
        Track(title: "Ocean Waves", fileName: "SeaCoast"),
        Track(title: "Thunderstorm in the Jungle", fileName: "CalmStorm"),
        Track(title: "Meditation Instrument", fileName: "NatureYoga")
    ]
    
    // MARK: - Actions
    func musicRow(track: Track, idx: Int) -> some View {
        Button(action: {
            saveMusic(track)
            selectedTab = idx
        }) {
            HStack {
                Image("\(track.fileName)")
                    .font(.system(size: 24))
                
                Text(track.title.capitalized)
                    .foregroundStyle(selectedMusic == track.fileName ? .black : .gray)
                    .fontWeight(selectedMusic == track.fileName ? .semibold : .regular)
            }
        }
        .buttonStyle(.plain)
    }
    
    func saveMusic(_ track: Track) {
        selectedMusic = track.fileName
        playSound(sound: track.fileName)
    }
    
    func playSound(sound: String) {
        audioPlayer?.stop()
        
        if let path = Bundle.main.path(forResource: sound, ofType: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer?.play()
            } catch {
                print("ERROR: Could not play the sound file.")
            }
        } else {
            print("ERROR: Could not find \(sound).mp3 in the bundle.")
        }
    }
    
    func getMusic() {
        selectedTab = self.musicList.firstIndex(where: { $0.fileName == selectedMusic }) ?? 0
    }
    
    // MARK: - View
    var body: some View {
        Modal(content: {
            VStack(spacing: 0) {
                Text("Choose your Music!")
                    .font(.title)
                    .foregroundColor(Color("Primary"))
                    .fontWeight(.bold)
                
                
                TabView(selection: $selectedTab) {
                    ForEach(0..<4) { i in
                        VStack {
                            Image("\(musicList[i].fileName)")
                                .resizable()
                                .frame(width: 120, height: 120)
                            
                            Text(musicList[i].title)
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                        .tag(i)
                    }
                }
                .onChange(of: selectedTab) { _, newValue in
                    let newTrack = musicList[newValue]
                    if selectedMusic != newTrack.fileName {
                        saveMusic(newTrack)
                    }
                }
                .frame(height: 240)
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                
                List(0..<4) { i in
                    musicRow(track: musicList[i], idx: i)
                }
                .scrollContentBackground(.hidden)
                .background(Color("Secondary"))
            }
            .onDisappear {
                audioPlayer?.stop()
            }
            .onAppear {
                getMusic()
            }
        }, isPresented: $isPresented)
    }
}

#Preview {
    CustomMusicScreen(isPresented: .constant(true))
}
