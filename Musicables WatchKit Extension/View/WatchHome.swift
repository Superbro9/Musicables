//
//  Home.swift
//  Home
//
//  Created by Hugo Mason on 30/08/2021.
//

import SwiftUI 

struct WatchHome: View {
    // creating object
    @StateObject var shazamSession = ShazamRecogniser()
    
    var body: some View {
        ZStack {
            //NavigationView {
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
           //     .navigationTitle("Shazam Kit")
           // }
            if let track = shazamSession.matchedTrack {
                    ZStack {
                        // background blurred image
                        AsyncImage(url: track.artwork) { phase in
                            if let image = phase.image {
                                image
                                    //.resizable()
                                    .aspectRatio(contentMode: .fill)
                            }
                            else {
                                Color.white
                            }
                        }
                        // max width
                        .frame(maxWidth: 250, maxHeight: 320)
                        
                        // track info
                        VStack(spacing: 5) {
                            
                            // background blurred image
                            AsyncImage(url: track.artwork) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 200, height: 300)
                                        .cornerRadius(12)
                                }
                                else {
                                    ProgressView()
                                }
                            }
                            .frame(width: 200, height: 300)
                            
                            Text(track.title)
                                .font(.title2.bold())
                                .padding(.horizontal)
                            
                            Text("Artist: **\(track.artist)**")
                                .padding(.horizontal)
                            
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
        WatchHome()
    }
}
