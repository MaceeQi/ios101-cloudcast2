//
//  WeatherForecastService.swift
//  CloudCast
//
//  Created by Macee Qi on 10/3/23.
//

import Foundation

class WeatherForecastService {
    
    // Static method that takes in latitude and longitude of certain location, and a closure
    // Closure gets called when the network request returns
    static func fetchForecast(latitude: Double,
                              longitude: Double,
                              completion: ((CurrentWeatherForecast) -> Void)? = nil) {
        // Create URL for API call
        let parameters = "latitude=\(latitude)&longitude=\(longitude)&current_weather=true&temperature_unit=fahrenheit&timezone=auto&windspeed_unit=mph"
        let url = URL(string: "https://api.open-meteo.com/v1/forecast?\(parameters)")!
        
        // Create a data task and pass in the URL
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // This closure is fired when the response is received - closure has access to data, response, error values
            guard error == nil else {
                assertionFailure("Error: \(error!.localizedDescription)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                assertionFailure("Invalid response")
                return
            }
            guard let data = data, httpResponse.statusCode == 200 else {
                assertionFailure("Invalid response, status code: \(httpResponse.statusCode)")
                return
            }
            // Now, 'data' contains the data received from the response
            let forecast = parse(data: data)
            
            // Initialize JSONDecoder to decode the data
            let decoder = JSONDecoder()
            let response = try! decoder.decode(WeatherAPIResponse.self, from: data)
            
            // This response will be used to change the UI, so it must happen on the main thread
            DispatchQueue.main.async {
                completion?(response.currentWeather)   // Call the completion closure
            }
        }
        task.resume()   // Resume the task and fire the request
    }
    
    private static func parse (data: Data) -> CurrentWeatherForecast {
        // Transform the data we received into a dictionary [String: Any]
        let jsonDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        let currentWeather = jsonDictionary["current_weather"] as! [String: Any]
        
        // Wind speed
        let windSpeed = currentWeather["windspeed"] as! Double
        
        // Wind direction
        let windDirection = currentWeather["winddirection"] as! Double
        
        // Temperature
        let temperature = currentWeather["temperature"] as! Double
        
        // Weather code
        let weatherCodeRaw = currentWeather["weathercode"] as! Int
        
        return CurrentWeatherForecast(windSpeed: windSpeed,
                                      windDirection: windDirection,
                                      temperature: temperature,
                                      weatherCodeRaw: weatherCodeRaw)
    }
}
