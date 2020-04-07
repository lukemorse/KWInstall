//
//  Utilities.swift
//  KW Install
//
//  Created by Luke Morse on 4/6/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import Foundation
import Combine

func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, DataError> {
  let decoder = JSONDecoder()
  decoder.dateDecodingStrategy = .secondsSince1970

  return Just(data)
    .decode(type: T.self, decoder: decoder)
    .mapError { error in
      .parsing(description: error.localizedDescription)
    }
    .eraseToAnyPublisher()
}
