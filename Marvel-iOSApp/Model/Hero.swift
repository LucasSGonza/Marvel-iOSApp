//
//  Hero.swift
//  Marvel-iOSApp
//
//  Created by Squad Apps on 19/12/23.
//

import UIKit

class Hero {
    
    //init properties
    var id: Int
    var name: String
    var description: String
    var img: String
    var reqOffset: Int
    
    var isFavorite: Bool = false
    var comicsAvailables: Int?
    var seriesAvailables: Int?
    var storiesAvailables: Int?
    var eventsAvailables: Int?
    
    init(id: Int, name: String, description: String, img: String, reqOffset: Int) {
        self.id = id
        self.name = name
        self.description = description
        self.img = img
        self.reqOffset = reqOffset
    }
    
}
