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
    @State private var showingSheet = false
    
    @Environment(\.colorScheme) var colorScheme
    
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
                GeometryReader { geometry in
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
                            
                            Text("**\(track.artist)**")
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
                                                    .foregroundColor(colorScheme == .light ? .black : .white)
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
                            Spacer()
                            
                            let qrcode =  QRCode(url: track.appleMusicURL,
                                                 color: UIColor.white,
                                                 backgroundColor: UIColor.black,
                                                 size: CGSize(width: 150, height: 150),
                                                 scale: 1,
                                                 inputCorrection: .medium)
                            
                            let myImage: UIImage? = try? qrcode!.image()
                            
                            Image(uiImage: myImage!)
                            
                            // apple music link
                            Link(destination: track.appleMusicURL) {
                                Text("Play in Apple Music")
                                    .frame(maxWidth: 300)
                                    
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(
                                Color.blue
                                    .cornerRadius(10)
                                    .shadow(radius: 10)
                            )
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
                        
                        .overlay(
                            Button(action: {
                                showingSheet.toggle()
                            }, label: {
                                Image(systemName: "qrcode")
                                    .font(.caption)
                                    .padding(10)
                                    .background(Color.white, in: Circle())
                                    .foregroundStyle(.black)
                            })
                        )
                    }
                }
            }
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
