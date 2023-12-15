//
//  Character.swift
//  Marvel-iOSApp
//
//  Created by Squad Apps on 14/12/23.
//

import UIKit

class Hero: Decodable {
    
    var data: Result
    
    struct Result: Decodable {
        var result: [HeroInformation]
    }
    
    struct HeroInformation: Decodable {
        var id: Int
        var name: String
        var description: String
        var thumbnail: HeroImage
    }
    
    struct HeroImage: Decodable {
        var path: String
        var extension_: String
        
        enum CodingKeys: String, CodingKey {
            case path = "path"
            case extension_ = "extension"
        }
        
    }
    
}
