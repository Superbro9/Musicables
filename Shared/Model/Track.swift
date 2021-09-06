//
//  Track.swift
//  Track
//
//  Created by Hugo Mason on 26/08/2021.
//

import SwiftUI

struct Track: Identifiable {
    var id = UUID().uuidString
    // track info
    var title: String
    var artist: String
    var artwork: URL
    var genres: [String]
    var appleMusicURL: URL
}
