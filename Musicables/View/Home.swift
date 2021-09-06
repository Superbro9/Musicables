//
//  Home.swift
//  Home
//
//  Created by Hugo Mason on 26/08/2021.
//

import SwiftUI
import QRCode

struct Home: View {
    // creating object
    @StateObject var shazamSession = ShazamRecogniser()
    
    var body: some View {
        ZStack {
            VStack {
                    // Record button...
                    Button {
                        shazamSession.listenMusic()
                    } label: {
                        Image(systemName: shazamSession.isRecording ? "stop" : "mic")
                            .font(.system(size: 35).bold())
                        // fill varient
                            .symbolVariant(.fill)
                            .padding(30)
                            .background(Color.cyan, in: Circle())
                            .foregroundStyle(.white)
                    }
            }
            if let track = shazamSession.matchedTrack {
                    ZStack {
                        
                        // background blurred image
                        AsyncImage(url: track.artwork) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            }
                            else {
                                Color.white
                            }
                        }
                        .overlay(.ultraThinMaterial)
                        
                        .frame(maxWidth: getRect().width)
                        
                        // track info
                        VStack(spacing: 15) {
                            
                            // artwork image
                            AsyncImage(url: track.artwork) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: getRect().width - 100, height: 300)
                                        .cornerRadius(12)
                                }
                                else {
                                    ProgressView()
                                }
                            }
                            .frame(width: getRect().width - 100, height: 300)
                            
                            Text(track.title)
                                .font(.title2.bold())
                                .padding(.horizontal)
                            
                            Text("Artist: **\(track.artist)**")
                                .padding(.horizontal)
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Genres")
                                    .padding(.leading)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    
                                    HStack(spacing: 18) {
                                        ForEach(track.genres, id: \.self) { genre in
                                            Button {
                                                
                                            } label: {
                                                Text(genre)
                                                    .font(.caption)
                                            }
                                            .buttonStyle(.bordered)
                                            .controlSize(.small)
                                            .buttonStyle(.borderedProminent)
                                            .tint(.black)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            
                            // apple music link
                            Link(destination: track.appleMusicURL) {
                                Text("Play in apple music")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                            .tint(.blue)
                        }
                        // close button
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .overlay(
                            
                            Button(action: {
                                // resetting view
                                shazamSession.matchedTrack = nil
                                shazamSession.stopRecording()
                            }, label: {
                                Image(systemName: "xmark")
                                    .font(.caption)
                                    .padding(10)
                                    .background(Color.white, in: Circle())
                                    .foregroundStyle(.black)
                            })
                                .padding(10)
                            ,alignment: .topTrailing
                        )
                    }            }
        }
        .alert(shazamSession.errorMsg, isPresented: $shazamSession.showError) {
            Button("Close", role: .cancel) {
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

// extending view to get screen size
extension View {
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
}

struct test: View {
    @StateObject var shazamSession = ShazamRecogniser()
    
    var body: some View {
        VStack {
                let musicCode = QRCode(url: URL(string: "(track.appleMusicURL)")!,
                                       color: UIColor.black,
                                       backgroundColor: UIColor.white,
                                       size: CGSize(width: 200, height: 250),
                                       scale: 1,
                                       inputCorrection: .medium)
           
                let myImage: UIImage? = try? musicCode?.image()
                Image(uiImage: myImage!)
        }
    }
}
