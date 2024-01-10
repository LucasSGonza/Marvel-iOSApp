//
//  HeroImage.swift
//  Marvel-iOSApp
//
//  Created by Squad Apps on 10/01/24.
//

struct HeroImage: Decodable {
    
    var path: String
    var extension_: String
    
    enum CodingKeys: String, CodingKey {
        case path = "path"
        case extension_ = "extension"
    }
    
}
