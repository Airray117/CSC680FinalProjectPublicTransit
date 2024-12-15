//
//  Untitled.swift
//  CSC 680 Public Transit
//
//  Created by Raymond Liu on 12/14/24.
//

import Foundation

class NextBusParserDelegate: NSObject, XMLParserDelegate
{
    var arrivals: [String] = []

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:])
    {
        if elementName == "prediction", let minutes = attributeDict["minutes"]
        {
            arrivals.append("\(minutes) mins")
        }
    }
}
