//
//  TrackStruct.swift
//  ChordableSpotifyAPITest
//
//  Created by Minjoo Kim on 10/17/23.
//

import SpotifyWebAPI
import Foundation

struct TrackStruct: Decodable {
  let name: String
  let album: String
  let artist: [Artist]
  let duration: Int
  let uri: String
  
  enum CodingKeys : String, CodingKey {
    case name
    case album
    case artist
    case duration = "duration_ms"
    case uri
  }
}
