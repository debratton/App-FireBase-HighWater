//
//  Flood.swift
//  HighWaters
//
//  Created by David E Bratton on 11/19/18.
//  Copyright © 2018 David Bratton. All rights reserved.
//

import Foundation

struct Flood {
    var latitude: Double
    var longitude: Double
    
    func toDictionary() -> [String:Any] {
        return ["latitude": self.latitude, "longitude": self.longitude]
    }
}

extension Flood {
    init?(dictionary: [String: Any]) {
        guard let latitude = dictionary["latitude"] as? Double,
              let longitude = dictionary["longitude"] as? Double else {
                return nil
        }
        self.latitude = latitude
        self.longitude = longitude
    }
}
