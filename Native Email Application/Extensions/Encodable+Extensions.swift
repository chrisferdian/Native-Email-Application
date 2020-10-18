//
//  Encodable+Extensions.swift
//  Native Email Application
//
//  Created by TMLI IT DEV on 18/10/20.
//

import Foundation
extension Encodable {
  func asDictionary() throws -> [String: Any] {
    let data = try JSONEncoder().encode(self)
    guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
      throw NSError()
    }
    return dictionary
  }
}
