//
//  ChordStruct.swift
//  ChordableSpotifyAPITest
//
//  Created by Minjoo Kim on 10/24/23.
//
import UIKit

struct Chord {
  let id: Int
  let name: String
  let image: UIImage
  let difficultyLevel: Level
  let audioFile: String
  var completed: Bool
  
  enum Level {
    case easy
    case medium
    case hard
  }
}
