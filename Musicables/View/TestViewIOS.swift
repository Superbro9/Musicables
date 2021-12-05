//
//  test.swift
//  Musicables
//
//  Created by Hugo Mason on 19/09/2021.
//

import SwiftUI
import QRCode
import CoreImage.CIFilterBuiltins

struct TestViewIOS: View {
    @StateObject var shazamSession = ShazamRecogniser()
    
    @Environment(\.colorScheme) var colorScheme
    var hello = ["hi", "bye", "hello"]
    
    var body: some View {
        //if let track = shazamSession.matchedTrack {
            GeometryReader { geometry in
                ZStack {
                    // background blurred image
                    AsyncImage(url: URL(string: "https://is4-ssl.mzstatic.com/image/thumb/Music115/v4/b0/47/cf/b047cf32-2af6-7ed5-754e-e4eed488be27/886446561875.jpg/800x800bb.jpg")) { phase in
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
                        AsyncImage(url: URL(string: "https://is4-ssl.mzstatic.com/image/thumb/Music115/v4/b0/47/cf/b047cf32-2af6-7ed5-754e-e4eed488be27/886446561875.jpg/800x800bb.jpg")) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: getRect().width - 100, height: 300)
                                    .cornerRadius(12)
                            }
                            
                            else {
                            Image("Shotgun")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: getRect().width - 100, height: 300)
                                .cornerRadius(12)
                                
                            }
                        }
                        
                        .frame(width: getRect().width - 100, height: 300)
                        
                        Text("Shotgun")
                            .font(.title2.bold())
                            .padding(.horizontal)
                            
                        
                        Text("**George Ezra**")
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Genres")
                                .padding(.leading)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                
                                HStack(spacing: 18) {
                                    ForEach(hello, id: \.self) { genre in
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
                        
                        let qrCodeImage = QRCode(url: URL(string: "https://upload.wikimedia.org/wikipedia/en/e/e2/Harry_Styles_-_Sign_of_the_Times_%28Official_Single_Cover%29.png")!,
                                                 color: .white,
                                                 backgroundColor: .black,
                                                 size: CGSize(width: 150, height: 150),
                                                 scale: 1,
                                                 inputCorrection: .medium)
                        let myImage: UIImage? = try? qrCodeImage!.image()
                        
                        Image(uiImage: myImage!)
                        
                        // apple music link
                        Link(destination: URL(string: "https://is4-ssl.mzstatic.com/image/thumb/Music115/v4/b0/47/cf/b047cf32-2af6-7ed5-754e-e4eed488be27/886446561875.jpg/800x800bb.jpg")!) {
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
                        .padding()
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
    
    func getQrCode() -> some View {
        let qrCodeImage = QRCode(url: URL(string: "https://upload.wikimedia.org/wikipedia/en/e/e2/Harry_Styles_-_Sign_of_the_Times_%28Official_Single_Cover%29.png")!,
                                 color: .blue,
                                 backgroundColor: .black,
                                 size: CGSize(width: 300, height: 300),
                                 scale: 1,
                                 inputCorrection: .medium)
        let myImage: UIImage? = try? qrCodeImage!.image()
        
        return Image(uiImage: myImage!)
    }
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    func generateQRCode(from string: String) -> UIImage {
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")
        
        if let outputImage = filter.outputImage {
            if let cgImg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImg)
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}

struct TestViewIOS_Previews: PreviewProvider {
    static var previews: some View {
        TestViewIOS()
    }
}
