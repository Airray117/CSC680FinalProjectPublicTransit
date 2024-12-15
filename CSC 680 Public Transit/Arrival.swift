//
//  Arrival.swift
//  CSC 680 Public Transit
//
//  Created by Raymond Liu on 12/14/24.
//

import Foundation

struct Arrival: Identifiable
{
    let id = UUID()
    let route: String
    let destination: String
    let arrivalTime: String
}
