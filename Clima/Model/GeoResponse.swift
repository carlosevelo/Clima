//
//  GeoResponse.swift
//  Clima
//
//  Created by Carlos Evelo on 2/23/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

struct GeoResponse: Decodable {
    var name: String
    //var local_names: [String]
    var lat: Double
    var lon: Double
    var country: String
    var state: String
}
