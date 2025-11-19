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

enum CuisineType{
    case chinese, italian, northIndian, Mughlai, Japanese, SouthIndian, French, American
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
}

