//
//  Element.swift
//  AC3.2-MidtermElements
//
//  Created by Annie Tung on 12/8/16.
//  Copyright © 2016 Annie Tung. All rights reserved.
//

import Foundation

class Element {
    let id: Int
    let record_url: String
    let number: Int
    let weight: Float
    let name: String
    let symbol: String
    let melting_c: Int
    let boiling_c: Int
    let density: Double
    let crust_percent: Float
    let discovery_year: String
    let group: Int
    let electrons: String
    let ion_energy: Float
    let thumbnail: String
    let fullImage: String
    
    init(id: Int, record_url: String, number: Int, weight: Float, name: String, symbol: String, melting_c: Int, boiling_c: Int, density: Double, crust_percent: Float, discovery_year: String, group: Int, electrons: String, ion_energy: Float, thumbnail: String, fullImage: String) {
        self.id = id
        self.record_url = record_url
        self.number = number
        self.weight = weight
        self.name = name
        self.symbol = symbol
        self.melting_c = melting_c
        self.boiling_c = boiling_c
        self.density = density
        self.crust_percent = crust_percent
        self.discovery_year = discovery_year
        self.group = group
        self.electrons = electrons
        self.ion_energy = ion_energy
        self.thumbnail = thumbnail
        self.fullImage = fullImage
    }
    
    convenience init?(from dict: [String:Any]) {
        guard
            let id = dict["id"] as? Int,
            let record_url = dict["record_url"] as? String,
            let number = dict["number"] as? Int,
            let weight = dict["weight"] as? Float,
            let name = dict["name"] as? String,
            let symbol = dict["symbol"] as? String,
            let discovery_year = dict["discovery_year"] as? String,
            let group = dict["group"] as? Int else { return nil }
        
        let melting_c = dict["melting_c"] as? Int ?? 0
        let boiling_c = dict["boiling_c"] as? Int ?? 0
        let density = dict["density"] as? Double ?? 0
        let crust_percent = dict["crust_percent"] as? Float ?? 0
        let electrons = dict["electrons"] as? String ?? ""
        let ion_energy = dict["ion_energy"] as? Float ?? 0
        
        let thumbnailURL = "https://s3.amazonaws.com/ac3.2-elements/\(symbol)_200.png"
        let fullImageURL = "https://s3.amazonaws.com/ac3.2-elements/\(symbol).png"
        
        self.init(id: id, record_url: record_url, number: number, weight: weight, name: name, symbol: symbol, melting_c: melting_c, boiling_c: boiling_c, density: density, crust_percent: crust_percent, discovery_year: discovery_year, group: group, electrons: electrons, ion_energy: ion_energy, thumbnail: thumbnailURL, fullImage: fullImageURL)
    }
    
    class func parse(from jsonData: Data) -> [Element]? {
        var elementsArray = [Element]()
        do {
            let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String:Any]]
            guard let validJson = json else { return nil }
            for jsonDict in validJson {
                if let validElement = Element(from: jsonDict) {
                    elementsArray.append(validElement)
                }
            }
            return elementsArray
        } catch {
            print("Error parsing data: \(error)")
        }
        return nil
    }
}
