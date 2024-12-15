//
//  TransitStop.swift
//  CSC 680 Public Transit
//
//  Created by Raymond Liu on 10/31/24.
//

import Foundation
import CoreLocation

struct TransitStop: Identifiable
{
    let id: String
    let name: String
    let coordinate: CLLocationCoordinate2D
    var arrivals: [String] = [] 
}


