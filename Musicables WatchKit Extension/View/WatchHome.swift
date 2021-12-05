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
                            // track info
                            VStack(spacing: 10) {
                                
                                // album artwork image
                                AsyncImage(url: track.artwork) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .padding(.leading, -14)
                                        //.padding(.top, -28)
                                        //.padding(.bottom)
                                        .edgesIgnoringSafeArea(.all)
                                    
                                     //   .resizable()
                                     //   .aspectRatio(contentMode: .fill)
                                     //   .frame(width: geometry.size.width, height: //geometry.size.height)
                                     //   .cornerRadius(6)
                                     //   .padding(.top, -28)
                                     //   .padding(.bottom)
                                }
                                    else {
                                        ProgressView()
                                    }
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                
                            //    VStack {
                            //        Text(track.title)
                            //            .padding(.horizontal)
                            //            .padding(.top, -2)
                            //
                            //        Text("**\(track.artist)**")
                            //            .padding(.horizontal)
                            //    }
                            }
                            // close button
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .overlay(
                                VStack {
                                    Text(track.title)
                                        .padding(.horizontal)
                                    
                                    Text("**\(track.artist)**")
                                        .padding(.horizontal)
                                }
                                ,alignment: .bottom
                                
                            )
                        }
                }
                .onLongPressGesture {
                    shazamSession.matchedTrack = nil
                    shazamSession.stopRecording()
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
