//
//  DataFetcher.swift
//  KW Install
//
//  Created by Luke Morse on 4/6/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import Foundation
import Combine
import Firebase

protocol DataFetchable {
  func currentUserData(
    forUser user: String
  ) -> AnyPublisher<currentUserDataResponse, DataError>
}

class DataFetcher {
  private let session: URLSession
    private let db: Firestore
  
  init(session: URLSession = .shared) {
    self.db = Firestore.firestore()
    self.session = session
  }
}

extension DataFetcher: DataFetchable {
    func currentUserData(forUser user: String) -> AnyPublisher<currentUserDataResponse, DataError> {
        
        return fetchData(with: makeCurrentUserComponents(withUser: user))
    }
    
    func fetchDataTest() {
        
        let docRef = db.collection("users").document("UB0V05346m499rFcYkvp")

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func getInstalls() -> [Installation] {
        let docRef = db.collection("teams").document("2YRtIFLhYdTe7UNCvoVz").collection("installations").document("zeKjtHNgEwKPEnxyIi5i")
        let decoder = JSONDecoder()
//        let install = try decoder.decode(Installation, from: docRef)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        }

        return []
    }
    
    private func fetchData<T>(
      with components: URLComponents
    ) -> AnyPublisher<T, DataError> where T: Decodable {
      guard let url = components.url else {
        let error = DataError.network(description: "Couldn't create URL")
        return Fail(error: error).eraseToAnyPublisher()
      }
      return session.dataTaskPublisher(for: URLRequest(url: url))
        .mapError { error in
          .network(description: error.localizedDescription)
        }
        .flatMap(maxPublishers: .max(1)) { pair in
          decode(pair.data)
        }
        .eraseToAnyPublisher()
    }
}



// MARK: - OpenWeatherMap API
private extension DataFetcher {
  struct OpenWeatherAPI {
    static let scheme = "https"
    static let host = "api.openweathermap.org"
    static let path = "/data/2.5"
    static let key = "<your key>"
  }
  
  
  func makeCurrentUserComponents(
    withUser user: String
  ) -> URLComponents {
    var components = URLComponents()
//    components.scheme = OpenWeatherAPI.scheme
//    components.host = OpenWeatherAPI.host
//    components.path = OpenWeatherAPI.path + "/weather"
//
//    components.queryItems = [
//      URLQueryItem(name: "q", value: city),
//      URLQueryItem(name: "mode", value: "json"),
//      URLQueryItem(name: "units", value: "metric"),
//      URLQueryItem(name: "APPID", value: OpenWeatherAPI.key)
//    ]
    
    return components
  }
}




enum DataError: Error {
  case parsing(description: String)
  case network(description: String)
}





struct currentUserDataResponse: Decodable {
  let main: Main
  
  struct Main: Codable {
    let schoolName: String
    
    enum CodingKeys: String, CodingKey {
      case schoolName = "schoolName"
    }
  }
}
