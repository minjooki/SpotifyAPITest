//: [Previous](@previous)

//  Code was adapted from https://github.com/Peter-Schorn/SpotifyAPIExamples

import Foundation
import Combine
import SpotifyWebAPI

// Authorization code from example API code

// Retrieves the client id and client secret from the "CLIENT_ID" and --> changed to hardcoded for playground
// "CLIENT_SECRET" environment variables, respectively. --> changed to hardcoded for playground
// Throws a fatal error if either can't be found.

func getSpotifyCredentialsFromEnvironment() -> (clientId: String, clientSecret: String) {
    let clientId = "b8ed1171504e4a8296abfff76f5d7995"
    let clientSecret = "c7a9a1550d9045dbba33bd89a4a71692"
    return (clientId: clientId, clientSecret: clientSecret)
}

extension ClientCredentialsFlowManager {

    /*
     A convenience method that calls through to `authorize()` and then blocks
     the thread until the publisher completes. Returns early if the application
     is already authorized.

     This method is defined in *this* app, not in the `SpotifyWebAPI` module.

     - Throws: If `authorize()` finishes with an error.
     */
    func waitUntilAuthorized() throws {

        if self.isAuthorized() { return }

        let semaphore = DispatchSemaphore(value: 0)

        var authorizationError: Error? = nil

        let cancellable = self.authorize()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    authorizationError = error
                }
                semaphore.signal()
            })

        _ = cancellable  // suppress warnings

        semaphore.wait()

        if let authorizationError = authorizationError {
            throw authorizationError
        }

    }

}


// From example API code (given authorization in separate file)

var cancellables: Set<AnyCancellable> = []
let dispatchGroup = DispatchGroup()

// Retrieve the client id and client secret from the environment variables.
let spotifyCredentials = getSpotifyCredentialsFromEnvironment()

let spotifyAPI = SpotifyAPI(
    authorizationManager: ClientCredentialsFlowManager(
        clientId: spotifyCredentials.clientId,
        clientSecret: spotifyCredentials.clientSecret
    )
)
// Authorize the application
try spotifyAPI.authorizationManager.waitUntilAuthorized()

// MARK: - The Application is Now Authorized -

// MARK: - Get A Track -

// SZA Snooze https://open.spotify.com/track/4iZ4pt7kvcaH6Yo8UoZ4s2?si=685341836fb94ce3
var trackURI = "spotify:track:4iZ4pt7kvcaH6Yo8UoZ4s2?si=685341836fb94ce3"

dispatchGroup.enter()
spotifyAPI.track(uri: trackURI, market: "US")
  .sink(
    receiveCompletion: { completion in
      print("completion:", completion, terminator: "\n\n\n")
      dispatchGroup.leave()
    },
    receiveValue: { track in
      print("\nReceived Track, printing")
      print("----------- ")
      print(track)
    }
  )
  .store(in: &cancellables)
dispatchGroup.wait()

// MARK: - Get User's Playlists -

dispatchGroup.enter()
spotifyAPI.currentUserPlaylist(limit: 50, offset: 0)
  .sink(
    receiveCompletion: { completion in
      print("completion:", completion, terminator: "\n\n\n")
      dispatchGroup.leave()
    },
    receiveValue: { playlists in
      print("\nReceived Playlist")
      print("----------- ")
      print("\nPrinting Playlist Items Reference")
      for playlist in playlists {
        print("\(playlist.playlistItemsReference)")
      }
      
      print("\nGetting add URIs to list, only if it is a track (song)")
//      let uris: [String] = playlists.items.map(\.uri)
      let uris: [String] = playlists.items.compactMap {$0.type == .track ? \.uri : nil}
      
      
      print("\n Passing in URI items to get each track")
      for uri in uris {
        print(playlistItems(uri: uri, limit: 100, offset: 0, market: "US"))
      }
    }
  )
  .store(in: &cancellables)
dispatchGroup.wait()

// MARK: - From Playlist, Get Track Information (Track Format) -

// "Christmas Classics"
// https://open.spotify.com/playlist/37i9dQZF1DX6R7QUWePReA?si=6d655c15bafd45cb
let playlistURI = "spotify:playlist:37i9dQZF1DX6R7QUWePReA?si=6d655c15bafd45cb"

dispatchGroup.enter()
spotifyAPI.playlistTracks(playlist: playlistURI, limit: 100, offset: 0, market: "US")
  .sink(
    receiveCompletion: { completion in
      print("completion:", completion, terminator: "\n\n\n")
      dispatchGroup.leave()
    },
    receiveValue: { playlistTracks in
      print("\nReceived Playlist")
      print("----------- ")
      print("\nArray of just the tracks")
      let tracks: [Track] = playlistTracks.items.compactMap(\.item)
      
      print("\nPrinting each track")
      for track in tracks {
        print(track.name)
      }
    }
  )
  .store(in: &cancellables)
dispatchGroup.wait()

// MARK: - Get Playlist Image -

// "This is Steve Lacy"
// https://open.spotify.com/playlist/37i9dQZF1DZ06evO30zJ7i?si=1a971b5b122948a2
let playlistImgURI = "spotify:playlist:37i9dQZF1DZ06evO30zJ7i?si=1a971b5b122948a2"

dispatchGroup.enter()
spotifyAPI.playlistImage(playlist: playlistImgURI)
  .sink(
    receiveCompletion: { completion in
      print("completion:", completion, terminator: "\n\n\n")
      dispatchGroup.leave()
    },
    receiveValue: { image in
      print("\nReceived Image")
      print("----------- ")
      print(image)
    }
  )
  .store(in: &cancellables)
dispatchGroup.wait()

//: [Next](@next)
