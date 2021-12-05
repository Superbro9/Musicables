//
//  TestView.swift
//  Musicables WatchKit Extension
//
//  Created by Hugo Mason on 21/09/2021.
//

import SwiftUI

struct TestViewWatch: View {
    @StateObject var shazamSession = ShazamRecogniser()
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // track info
                VStack(spacing: 10) {
                    
                    // album artwork image
                    AsyncImage(url: URL(string: "https://is4-ssl.mzstatic.com/image/thumb/Music115/v4/b0/47/cf/b047cf32-2af6-7ed5-754e-e4eed488be27/886446561875.jpg/800x800bb.jpg")) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .padding(.leading, -14)
                                //.padding(.top, -28)
                                //.padding(.bottom)
                                .edgesIgnoringSafeArea(.all)
                           //     .resizable()
                           //     .aspectRatio(contentMode: .fill)
                           //     .frame(width: geometry.size.width, height: //geometry.size.height)
                           //     .cornerRadius(6)
                           //     .padding(.top, -28)
                           //     .padding(.bottom)
                        }
                        else {
                            //ProgressView()
                            Image("Shotgun")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .padding(.leading, -14)
                                //.padding(.trailing, 20)
                                //.padding(.trailing, -28)
                                //.padding(.bottom)
                                .edgesIgnoringSafeArea(.all)
                            
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    // close button
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .overlay(
                        VStack {
                            Text("Shotgun")
                                .padding(.horizontal)
                    
                            Text("**George Ezra**")
                                .padding(.horizontal)
                        }
                            .padding(.bottom, 3)
                        ,alignment: .bottom
                        
                    )
              //      .overlay(
              //
              //          Button(action: {
              //              // resetting view
              //              shazamSession.matchedTrack = nil
              //              shazamSession.stopRecording()
              //          }, label: {
              //              Image(systemName: "xmark")
              //                  .font(.caption)
              //                  .padding(5)
              //                  .background(Color.white, in: Circle())
              //                  .foregroundStyle(.black)
              //          })
              //              .buttonStyle(PlainButtonStyle())
              //              .padding(.trailing, 3)
              //              .padding(.top, 1)
              //          ,alignment: .topTrailing
              //      )
            }
        }
        .onLongPressGesture {
            shazamSession.matchedTrack = nil
            shazamSession.stopRecording()
        }
    }
}

struct TestViewWatch_Previews: PreviewProvider {
    static var previews: some View {
        //TestView()
        TestViewWatch()
                .previewDevice("Apple Watch Series 7 - 45mm")
        
        TestViewWatch()
                .previewDevice("Apple Watch Series 3 - 38mm")
    }
}
