//
//  Hero.swift
//  Marvel-iOSApp
//
//  Created by Squad Apps on 19/12/23.
//

import UIKit

class Hero {
    
    var reqOffset: Int
    var id: Int
    var name: String
    var description: String
    var img: String
    var comicsAvailables: Int
    var isFavorite: Bool = false
    
    init(id: Int, name: String, description: String, img: String, comicsAvailables: Int, reqOffset: Int) {
        self.id = id
        self.name = name
        self.description = description
        self.img = img
        self.comicsAvailables = comicsAvailables
        self.reqOffset = reqOffset
    }
    
}
