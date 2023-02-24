//
//  WeatherManager.swift
//  Clima
//
//  Created by Carlos Evelo on 2/23/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let geoURL = "https://api.openweathermap.org/geo/1.0/direct?appid=943be57bb172d7b3e44a13ff5576f4a8&limit=1" //&q={city name},{state code},{country code}
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=943be57bb172d7b3e44a13ff5576f4a8&units=imperial" //lat={lat}&lon={lon}
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(geoURL)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    
    func fetchWeather(_ lat: Double, _ lon: Double) {
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(lon)"
        performWeatherRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        // Step 1: Create a URl object
        if let url = URL(string: urlString) {
            // Step 2: Create a URLSession
            let session = URLSession(configuration: .default)
            // Step 3: Give the session a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeGeoData = data {
                    var lat = 0.0
                    var lon = 0.0
                    let decoder = JSONDecoder()
                    
                    do {
                        let decodedData = try decoder.decode(Array<GeoResponse>.self, from: safeGeoData)
                        lat = decodedData[0].lat
                        lon = decodedData[0].lon
                    }
                    catch {
                        delegate?.didFailWithError(error: error)
                        print(error)
                    }
                    
                    let dataUrlString = "\(weatherURL)&lat=\(lat)&lon=\(lon)"
                    performWeatherRequest(urlString: dataUrlString)
                }
            }
            // Step 4: Start the task
            task.resume()
        }
    }
    
    func performWeatherRequest(urlString: String) {
        if let url = URL(string: urlString) {
            // Step 2: Create a URLSession
            let session = URLSession(configuration: .default)
            // Step 3: Give the session a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safedata = data {
                    let decoder = JSONDecoder()
                    do {
                        let decodedData = try decoder.decode(WeatherResponse.self, from: safedata)
                        let id = decodedData.weather[0].id
                        let temp = decodedData.main.temp
                        let name = decodedData.name
                        
                        let weather = WeatherModel(conditionId: id, cityName: name, tempurature: temp)
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                    catch {
                        delegate?.didFailWithError(error: error)
                        print(error)
                    }
                }
            }
            // Step 4: Start the task
            task.resume()
        }
    }
}
