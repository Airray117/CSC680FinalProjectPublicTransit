//
//  MuniParserDelegate.swift
//  CSC 680 Public Transit
//
//  Created by Raymond Liu on 12/14/24.
//

import Foundation

class MuniParserDelegate: NSObject, XMLParserDelegate
{
    var arrivals: [Arrival] = [] // Ensure this uses the global Arrival type

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        if elementName == "prediction"
        {
            if let minutes = attributeDict["minutes"],
               let route = attributeDict["routeTag"],
               let destination = attributeDict["dirTitleBecause"]
            {
                let arrival = Arrival(route: route, destination: destination, arrivalTime: minutes + " mins")
                arrivals.append(arrival)
            }
        }
    }
}
