import Foundation
//
//  Model.swift
//  Restaurant-App
//
//  Created by SDC-USER on 19/11/25.
//
struct Location {
    var latitude: Double
    var longitude: Double
}

enum CuisineType: String, CaseIterable{
    case chinese, italian, northIndian, Mughlai, Japanese, SouthIndian, French, American
    var imageName: String {
        switch self {
        case .chinese: return "chinese"
        case .italian: return "italian"
        case .northIndian: return "north_indian"
        case .Mughlai: return "mughlai"
        case .Japanese: return "japanese"
        case .SouthIndian: return "south_indian"
        case .French: return "french"
        case .American: return "american"
        }
    }
}
struct Restaurant {
    var ID: UUID
    var name:String
    var location:Location
    var address: String
    var rating: Double
    var reviews: [String]
    var images: [String]
    var cuisine: [CuisineType]
    var isFavourite: Bool 
}

