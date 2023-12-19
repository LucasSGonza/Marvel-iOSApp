//
//  Hero.swift
//  Marvel-iOSApp
//
//  Created by Squad Apps on 19/12/23.
//

import UIKit

class Hero {
    var id: Int
    var name: String
    var description: String
    var img: String
    
    init(id: Int, name: String, description: String, img: String) {
        self.id = id
        self.name = name
        self.description = description
        self.img = img
    }
    
}
