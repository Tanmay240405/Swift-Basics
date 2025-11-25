//
//  Destination.swift
//  Travel Destinations
//
//  Auto-generated from destinations.json structure
//

import Foundation

// MARK: - Main Response
struct DestinationsResponse: Codable {
    
    var destinations: [Destination] = []

    init() {
        do {
            let response = try load()
            destinations = response.destinations
        } catch {
            print(error.localizedDescription)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case destinations
    }
    
    func getRandomDestination() -> Destination {
        return destinations.randomElement()!
    }
    
    func getDestinations(type:String) -> [Destination] {
        return destinations.filter { destination in
            destination.category == type
        }
    }
    
}

// MARK: - Destination
struct Destination: Codable, Identifiable {
    let id: String
    let name: String
    let category: String
    let description: String
    let imagePath: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case category
        case description
        case imagePath = "image_path"
    }
}


// MARK: - Category Enum
enum DestinationCategory: String, CaseIterable {
    case beach = "beach"
    case mountains = "mountains"
    case urban = "urban"
    case tropical = "tropical"
    case desert = "desert"
    case cultural = "cultural"
    case adventure = "adventure"
    case countryside = "countryside"

    var displayName: String {
        switch self {
        case .beach: return "Beach"
        case .mountains: return "Mountains"
        case .urban: return "Urban"
        case .tropical: return "Tropical"
        case .desert: return "Desert"
        case .cultural: return "Cultural"
        case .adventure: return "Adventure"
        case .countryside: return "Countryside"
        }
    }

    var icon: String {
        switch self {
        case .beach: return "🏖️"
        case .mountains: return "⛰️"
        case .urban: return "🏙️"
        case .tropical: return "🌴"
        case .desert: return "🏜️"
        case .cultural: return "🏛️"
        case .adventure: return "🎿"
        case .countryside: return "🌾"
        }
    }
}

// MARK: - JSON Loading Helper
extension DestinationsResponse {
    /// Load destinations from a JSON file
    func load(from filename: String = "destinations") throws -> DestinationsResponse {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            throw NSError(domain: "DestinationsResponse", code: 404,
                         userInfo: [NSLocalizedDescriptionKey: "destinations.json not found"])
        }

        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        print(String(data: data, encoding: .utf8))
        do {
            return try decoder.decode(DestinationsResponse.self, from: data)
        } catch {
            print(error.localizedDescription)
            throw error
        }
        
    }

    /// Load destinations from JSON data
    func decode(from data: Data) throws -> DestinationsResponse {
        let decoder = JSONDecoder()
        return try decoder.decode(DestinationsResponse.self, from: data)
    }
}

// MARK: - Filtering Extensions
extension DestinationsResponse {
    func destinations(for category: DestinationCategory) -> [Destination] {
        destinations.filter { $0.category == category.rawValue }
    }

    /// Get destinations grouped by category
    var destinationsByCategory: [DestinationCategory: [Destination]] {
        var grouped: [DestinationCategory: [Destination]] = [:]

        for category in DestinationCategory.allCases {
            grouped[category] = destinations(for: category)
        }

        return grouped
    }
}

