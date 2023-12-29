//
//  Character.swift
//  Marvel-iOSApp
//
//  Created by Squad Apps on 14/12/23.
//

import UIKit

class Data: Decodable {
    
    var data: Result
    
    struct Result: Decodable {
        var results: [HeroInformation]
        var count: Int
        var total: Int
    }
    
    struct HeroInformation: Decodable {
        var id: Int
        var name: String
        var description: String
        var thumbnail: HeroImage
        var comics: Comics
    }
    
    struct HeroImage: Decodable {
        var path: String
        var extension_: String
        
        enum CodingKeys: String, CodingKey {
            case path = "path"
            case extension_ = "extension"
        }
        
    }
    
    struct Comics: Decodable {
        var available: Int
    }
    
}
