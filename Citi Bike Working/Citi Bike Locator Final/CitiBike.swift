//
//  CitiBike.swift
//  Citi Bike Locator
//
//  Created by David Hartglass on 4/20/18.
//  Copyright © 2018 David Hartglass. All rights reserved.
//

import UIKit

class CitiBike{
    // var image: UIImage?
    let id: Int
    let stationName: String
    let availableDocks: Int
    let totalDocks: Int
    let latitude: Double
    let longitude: Double
    let statusValue: String
    let availableBikes: Int
    let stAddress1: String
    let stAddress2: String?
    let city: String?
    let postalCode: String?
    let location: String?
    let altitude: String?
    let testStation: Bool?
    let lastCommunicationTime: Date
    let landmark: String?
    
    init(
        id: Int,
        stationName: String,
        availableDocks: Int,
        totalDocks: Int,
        latitude: Double,
        longitude: Double,
        statusValue: String,
        availableBikes: Int,
        stAddress1: String,
        stAddress2: String?,
        city: String?,
        postalCode: String?,
        location: String?,
        altitude: String?,
        testStation: Bool?,
        lastCommunicationTime: Date,
        landMark: String?
        
        ){
        self.id = id
        self.stationName = stationName
        self.availableDocks = availableDocks
        self.totalDocks = totalDocks
        self.latitude = latitude
        self.longitude = longitude
        self.statusValue = statusValue
        self.availableBikes = availableBikes
        self.stAddress1 = stAddress1
        self.stAddress2 = stAddress2
        self.city = city
        self.postalCode = postalCode
        self.location = location
        self.altitude = altitude
        self.testStation = testStation
        self.lastCommunicationTime = lastCommunicationTime
        self.landmark = landMark
    }
}


