//
//  WeatherResponse.swift
//  Clima
//
//  Created by Carlos Evelo on 2/23/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

struct WeatherResponse: Decodable {
    var name: String
    var weather: [Weather]
    var main: Main
}

struct Main: Decodable {
    var temp: Double
}

struct Weather: Decodable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}
