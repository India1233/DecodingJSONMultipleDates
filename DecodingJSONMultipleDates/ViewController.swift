//
//  ViewController.swift
//  DecodingJSONMultipleDates
//
//  Created by Suresh Shiga on 28/11/19.
//  Copyright © 2019 Test. All rights reserved.
//https://blog.usejournal.com/decoding-a-json-having-multiple-date-formats-in-swift-9ad22c443448

import UIKit




class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 1
        setupJSON()
        
        //2
        //setupJSON2()
    }
//1
    private func setupJSON(){
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        let decodable = JSONDecoder()
        decodable.dateDecodingStrategy = .formatted(formatter)
       
        do {
             let sunPosition = try decodable.decode(SunPosition.self, from: data)
            print(sunPosition.sunrise)
            print(sunPosition.sunset)
        } catch  {
            print(error)
        }
    }
    // 2
    private func setupJSON2(){
        do {
            guard let data3 = data2 else { fatalError("data not found")}
            let sunPosition = try JSONDecoder().decode(SunPosition2.self, from: data3)
            print(sunPosition.sunrise.value)
            print(sunPosition.sunset.value)
            print(sunPosition.day.value)
        } catch  {
            print(error)
        }
    }
}


//MARK:- MODEL

// 1
struct SunPosition: Codable {
    let location: String
    let sunrise: Date
    let sunset: Date
}

// 2

struct SunPosition2: Codable {
    let location: String
    let sunrise: CustomDate<HoursAndMinutes>
    let sunset: CustomDate<HoursAndMinutes>
    let day: CustomDate<Days>
}

// Protocal for dateformatter
protocol HasDateFormatter {
    static var dateFormatter: DateFormatter {get}
}

// CustomDate Struct for getting date value
struct CustomDate<E:HasDateFormatter>: Codable {
    let value: Date
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let text = try container.decode(String.self)
        guard let date = E.dateFormatter.date(from: text) else { throw CustomDateError.general}
        self.value = date
    }
    enum CustomDateError: Error {
        case general
    }
}

// Get the hours and minutes
struct HoursAndMinutes: HasDateFormatter {
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter
    }
}

//Get the Days
struct Days: HasDateFormatter {
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        return formatter
        
    }
}

//MARK:- DATA
//1
let data = """
{
"location": "India",
"sunrise": "4:48 AM",
"sunset": "8:26 PM"
}
"""
    .data(using: .utf8)!

// 2

let data2 = """
{
"location": "India",
"sunrise": "03:00 AM",
"sunset": "09: 00 PM",
"day": "12-SEP-2019"
}
"""
    .data(using: .utf8)
