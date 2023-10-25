//
//  ImageStruct.swift
//  ChordableSpotifyAPITest
//
//  Created by Minjoo Kim on 10/17/23.
//

import Foundation
import SpotifyWebAPI

struct Image: Decodable {
  let url: String
  let height: Int
  let width: Int
  
  enum CodingKeys : String, CodingKey {
    case url
    case height
    case width
  }
}
