//
//  ViewController.swift
//  CloudCast
//
//  Created by Mari Batilando on 3/29/23.
//

import UIKit

// Data model for Location
struct Location {
  let name: String
  let latitude: Double
  let longitude: Double
}


class ForecastViewController: UIViewController {
  
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var temperatureLabel: UILabel!
  @IBOutlet weak var windspeedLabel: UILabel!
  @IBOutlet weak var windDirectionLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var forecastImageView: UIImageView!
  
  private var locations = [Location]()  // Stores the different locations
  private var selectedLocationIndex = 0 // Keeps track of the current selected location
    
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addGradient()
    
    // Create a few locations to show the forecast for
    let sanJose = Location(name: "San Jose", latitude: 37.335480, longitude: -121.893028)
    let manila = Location(name: "Manila", latitude: 12.8797, longitude: 121.7740)
    let italy = Location(name: "Italy", latitude: 41.8719, longitude: 12.5674)
    locations = [sanJose, manila, italy]
    
    // When view loads, make sure the first location is shown
    changeLocation(withLocationIndex: 0)
  }
  
  
  private func addGradient() {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = view.bounds
    gradientLayer.colors = [UIColor(red: 0.54, green: 0.88, blue: 0.99, alpha: 1.00).cgColor,
                            UIColor(red: 0.51, green: 0.81, blue: 0.97, alpha: 1.00).cgColor]
    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
    view.layer.insertSublayer(gradientLayer, at: 0)
  }
  
  
  private func changeLocation(withLocationIndex locationIndex: Int) {
    guard locationIndex < locations.count else { return }
    let location = locations[locationIndex]
    locationLabel.text = location.name
  }
  
  
  @IBAction func didTapBackButton(_ sender: UIButton) {
    // Make sure selected location index is always >= 0
    selectedLocationIndex = max(0, selectedLocationIndex - 1)
    changeLocation(withLocationIndex: selectedLocationIndex)
  }
  
  
  @IBAction func didTapForwardButton(_ sender: UIButton) {
    // Make sure selected location index is always < locations.count
    selectedLocationIndex = min(locations.count - 1, selectedLocationIndex + 1)
    changeLocation(withLocationIndex: selectedLocationIndex)
  }
}

