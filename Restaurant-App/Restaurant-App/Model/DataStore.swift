import Foundation

//
//  DataStore.swift
//  Restaurant-App
//
//  Created by SDC-USER on 19/11/25.
//

//create the dsta store type
class DataStore {
    
    private var restaurants:[Restaurant] = []
    
    private init() {
        loadSampleData()
    }
    
    static let shared = DataStore()
    func getRestaurants()->[Restaurant] {
        return restaurants
    }
    
    func filter(for cuisine:CuisineType)->[Restaurant] {
        restaurants.filter{restaurant in
            if restaurant.cuisine.contains(cuisine) {
                return true
            }
            return false
        }
    }
    func getFavouriyeRestaurants() -> [Restaurant]{
        restaurants.filter{ restaurant in
            return restaurant.isFavourite}
    }
  
    
    func loadSampleData() {
        let sampleData: [Restaurant] = [
            Restaurant(
                ID: UUID(),
                name: "California Kitchen",
                location: Location(latitude: 0.0, longitude: 0.0),
                address: "Pune",
                rating: 5.0,
                reviews: [],
                images: ["chicken_korma"],
                cuisine: [.northIndian],
                isFavourite: false
            ),
            Restaurant(ID: UUID(),
                       name: "LA Kitchen",
                       location: Location(latitude: 1.0, longitude: 1.0),
                       address: "Pune",
                       rating:4.0,
                       reviews: [],
                       images: ["china_palace_dxining"],
                       cuisine: [.American],
                      isFavourite: true),
            Restaurant(ID: UUID(),
                       name: "NYC Kitchen",
                       location: Location(latitude: 1.0, longitude: 1.0),
                       address: "Pune",
                       rating:4.2,
                       reviews: [],
                       images: ["hot_dog"],
                       cuisine: [.Mughlai],
                      isFavourite: false)

        ]
        
        self.restaurants = sampleData
    }
}

