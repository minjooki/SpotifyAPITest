//
//  PlaylistStruct.swift
//  ChordableSpotifyAPITest
//
//  Created by Minjoo Kim on 10/17/23.
//

import Foundation
import SpotifyWebAPI

struct PlaylistStruct: Decodable {
  let name: String
  let items: [PlaylistItem]
  let images: [ImageStruct]
  let uri: String
  
  enum CodingKeys : String, CodingKey {
    case name
    case items = "tracks"
    case images
    case uri
  }
}
