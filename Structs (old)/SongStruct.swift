//
//  SongStruct.swift
//  ChordableSpotifyAPITest
//
//  Created by Minjoo Kim on 10/24/23.
//
import UIKit

struct Song {
  let id: Int
  let title: String
  let artist: String
  let album: String
  let duration: Double
  let genre: Int
  let spotifyURL: String
  var chordProgression: [ChordData]
  var completed: Bool


  
  struct ChordData {
      let chord: String?
      let startTime: Double
      let endTime: Double
  }
}

struct Genre {
  let id: Int
  let name: String
  let image: UIImage
}
