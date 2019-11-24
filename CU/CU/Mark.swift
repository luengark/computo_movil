//
//  Mark.swift
//  CU
//
//  Created by 2020-1 on 11/21/19.
//  Copyright © 2019 Enrique García. All rights reserved.
//

import Foundation
import MapKit

struct mark: Codable{
    let name: String
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
}

let path = Bundle.main.path(forResource: "marks", ofType: "json")
let jsonData = NSData(contentsOfFile: path!)
let locations = try! JSONDecoder().decode([mark].self, from: jsonData! as Data)
