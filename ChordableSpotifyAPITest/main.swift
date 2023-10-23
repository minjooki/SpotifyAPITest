
//  Code was adapted from https://github.com/Peter-Schorn/SpotifyAPIExampleApp/blob/main/SpotifyAPIExampleApp

import Foundation
import Combine
import SpotifyWebAPI

// Authorization code from example API code

// Retrieves the client id and client secret from the "CLIENT_ID" and --> changed to hardcoded for playground
// "CLIENT_SECRET" environment variables, respectively. --> changed to hardcoded for playground
// Throws a fatal error if either can't be found.

func getSpotifyCredentials() -> (clientId: String, clientSecret: String) {
    let clientId = "b8ed1171504e4a8296abfff76f5d7995"
    let clientSecret = "c7a9a1550d9045dbba33bd89a4a71692"
    return (clientId: clientId, clientSecret: clientSecret)
}

//var authorizationState = String.randomURLSafe(length: 128)
//var currentUser: SpotifyUser? = nil



// Retrieve the client id and client secret from the environment variables.
//let spotifyCredentials = getSpotifyCredentials()

//let spotifyAPI = SpotifyAPI(
//    authorizationManager: ClientCredentialsFlowManager(
//        clientId: spotifyCredentials.clientId,
//        clientSecret: spotifyCredentials.clientSecret
////        scopes:
//    )
//)

let spotifyAPI = SpotifyAPI(
    authorizationManager: AuthorizationCodeFlowManager(
        clientId: "b8ed1171504e4a8296abfff76f5d7995", clientSecret: "c7a9a1550d9045dbba33bd89a4a71692"
    )
)

var cancellables: Set<AnyCancellable> = []
let dispatchGroup = DispatchGroup()


func authorize() {
  
  let authorizationURL = spotifyAPI.authorizationManager.makeAuthorizationURL(
    redirectURI: URL(string: "spotify-ios-quick-start://spotify-login-callback")!,
    showDialog: true,
    scopes: [
      .playlistModifyPrivate,
      .userModifyPlaybackState,
      .playlistReadCollaborative,
      .userLibraryRead,
      .userReadPlaybackPosition
    ]
  )!
}

spotifyAPI.authorizationManager.requestAccessAndRefreshTokens(
  redirectURIWithQuery: URL(string: "spotify-ios-quick-start://spotify-login-callback")!
)
.sink(receiveCompletion: { completion in
    switch completion {
        case .finished:
            print("successfully authorized")
        case .failure(let error):
            if let authError = error as? SpotifyAuthorizationError, authError.accessWasDenied {
                print("The user denied the authorization request")
            }
            else {
                print("couldn't authorize application: \(error)")
            }
    }
})
.store(in: &cancellables)

// Authorize the application
//try spotifyAPI.authorizationManager.authorize()




// MARK: - The Application is Now Authorized -

// MARK: - Get A Track -

// SZA Snooze https://open.spotify.com/track/4iZ4pt7kvcaH6Yo8UoZ4s2?si=685341836fb94ce3
var trackURI = "spotify:track:4iZ4pt7kvcaH6Yo8UoZ4s2?si=685341836fb94ce3"

dispatchGroup.enter()
spotifyAPI.track(trackURI, market: "US")
  .sink(
    receiveCompletion: { completion in
      print("completion:", completion, terminator: "\n\n\n")
      dispatchGroup.leave()
    },
    receiveValue: { track in
      print("\nReceived Track, printing")
      print("----------- ")
      print("\(track.name)")
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
    receiveValue: { playlist in
      print("\nReceived Playlist")
      print("----------- ")
      
      print("\nPrinting Playlist")
      print("\(playlist.name)")
      
      // making new playlist struct from this item
      
      print("\nPrinting Tracks")
      for track in playlist.items.items.compactMap(playlist.item) {
        print(track.name)
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
spotifyAPI.playlistTracks(playlistURI, limit: 100, offset: 0, market: "US")
  .sink(
    receiveCompletion: { completion in
      print("completion:", completion, terminator: "\n\n\n")
      dispatchGroup.leave()
    },
    receiveValue: { playlistTrack in
      print("\nReceived Playlist")
      print("----------- ")
      print("\nArray of just the tracks")
      let tracks: [Track] = playlistTrack.items.compactMap(\.item)
      
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
spotifyAPI.playlistImage(playlistImgURI)
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

