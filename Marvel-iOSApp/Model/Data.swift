//
//  Character.swift
//  Marvel-iOSApp
//
//  Created by Squad Apps on 14/12/23.
//

import UIKit

// MARK: 1 i don't think this is a good thing to do, its better if you split each struct to a new archive or put it separately
class Data: Decodable {
    
    var data: Result
    
    struct Result: Decodable {
        var results: [HeroInformation]
        var count: Int
        var total: Int
        var offset: Int
    }
    
    struct HeroInformation: Decodable {
        var id: Int
        var name: String
        var description: String
        var thumbnail: HeroImage
        var comics: Comics
        var series: Series
        var stories: Stories
        var events: Events
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
    struct Series: Decodable {
        var available: Int
    }
    struct Stories: Decodable {
        var available: Int
    }
    struct Events: Decodable {
        var available: Int
    }
    
}
