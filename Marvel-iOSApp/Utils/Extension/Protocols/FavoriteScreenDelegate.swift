//
//  FavoriteListDelegate.swift
//  Marvel-iOSApp
//
//  Created by Squad Apps on 20/12/23.
//

import Foundation

protocol FavoriteListDelegate: AnyObject {
    func setHeroesArray(_ heroesArray: [Hero])
}
