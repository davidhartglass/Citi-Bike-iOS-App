//
//  CitiBikeCollection.swift
//  Citi Bike Locator
//
//  Created by David Hartglass on 4/20/18.
//  Copyright © 2018 David Hartglass. All rights reserved.
//

import Foundation

class CitiBikeCollection {
    var currentBikes = Array<CitiBike>()
    
    func createURL()->URL? {
        //Since thr URL does not change, there is no need to mutate
        let baseURL = "https://feeds.citibikenyc.com/stations/stations.json"
        var myURLComponents = URLComponents(string: baseURL)
        
        // add options to queryOptionArray
        var queryOptionArray = Array<URLQueryItem>()
        queryOptionArray.append(URLQueryItem(name: "format", value: "json"))
        queryOptionArray.append(URLQueryItem(name: "nojsoncallback", value: "1"))
        
        print("The URL is \(String(describing: myURLComponents?.string))")
        
        return myURLComponents?.url
    }
    
    // the parameter is an optional (default nil) that is a func taking 0 param, returning nothing
    func getRecent(completionHandler: (()->())? = nil )->Array<CitiBike> {
        
        let myURL = createURL()
        let returnArray = bikeFromURL(myURL: myURL!, completionHandler: completionHandler)
        
        return returnArray
    }
    
    func bikeFromURL(myURL: URL, completionHandler: (()->())? = nil)->Array<CitiBike> {
        var myBikeArray = Array<CitiBike>()
        // choices are ephemeral (in memory), .background (keeps running), .default
        let session = URLSession(configuration: .ephemeral)
        
        let task = session.dataTask(with: myURL) {
            (data,response,error)->Void in
            
            //Local array to hold the bikes
            var localBikeArray = Array<CitiBike>()
            
            //If we get an error, output it
            if let actualError = error {
                print("Got an error-Error is \(error)")
            }
                //Otherwise lets proceed to parse
            else if let actualResponse = response, let actualData = data {
                print("I got some data")
                
                //Uncomment below to show the data that is attempting to be parsed
                //print(actualData)
                let parsedData = try? JSON(data: actualData)
                
                //print("Parsed Data: \(String(describing: parsedData))")
                
                //Below prints the number of bikes found
                print("Found \(parsedData!["stationBeanList"].count) bikes")
                
                let receivedBikeArray = parsedData!["stationBeanList"]
                
                //To format the date into a format we can use
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss a"
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                
                //While the value exists in 'value', proceed to fill parameters
                for (_,value) in receivedBikeArray {
                    //print("value is \(value)")
                    //print ("date is \(value["lastCommunicationTime"])")
                    let thisCity = value["city"].string
                    let thisStatusKey = value["statusKey"].int
                    let thisAvailableDocks = value["availableDocks"].int
                    let thisAltitude = value["altitude"].string
                    let dateString = value["lastCommunicationTime"].string
                    let thisLastCommunicationTime = (nil == dateString) ? nil : dateFormatter.date(from: dateString!)
                    print("dateString is \(dateString!)")
                    print("Parsed date is \(thisLastCommunicationTime)")
                    let thisStAddress1 = value["stAddress1"].string
                    let thisStatusValue = value["statusValue"].string
                    let thisLatitude = value["latitude"].double
                    let thisStationName = value["stationName"].string
                    let thisID = value["id"].int
                    let thisLocation = value["location"].string
                    let thisStAddress2 = value["stAddress2"].string
                    let thisAvailableBikes = value["availableBikes"].int
                    let thisPostalCode = value["postalCode"].string
                    let thisTotalDocks = value["totalDocks"].int
                    let thisLandmark = value["landmark"].string
                    let thisLongitude = value["longitude"].double
                    let thisTestStation = value["testStation"].bool
                    //print(value)
                    
                    //Using the init method, now lets set the parameters of the bike to our parsed data
                    let thisBike = CitiBike(
                        id: thisID!,
                        stationName: thisStationName!,
                        availableDocks: thisAvailableDocks!,
                        totalDocks: thisTotalDocks!,
                        latitude: thisLatitude!,
                        longitude: thisLongitude!,
                        statusValue: thisStatusValue!,
                        availableBikes: thisAvailableBikes!,
                        stAddress1: thisStAddress1!,
                        stAddress2: thisStAddress2,
                        city: thisCity!,
                        postalCode: thisPostalCode,
                        location: thisAltitude,
                        altitude: thisAltitude,
                        testStation: thisTestStation,
                        lastCommunicationTime: thisLastCommunicationTime!,
                        landMark: thisLandmark)
                    
                    localBikeArray.append(thisBike)
                    //print("Size of this array is \(localBikeArray.count)")
                    
                }
                // parse the data
            } else {
                print("How did I get here???")
            }
            self.currentBikes = localBikeArray
            print("MyBikeArray has size \(self.currentBikes.count)")
            
            if let actualCH = completionHandler {
                // user closures are frequently UI code, so run this in the main thread
                DispatchQueue.main.async {
                    actualCH()
                }
            }
        } // end of data task closure
        
        task.resume()
        print("Hi, I'm here")
        return myBikeArray
    }
}

