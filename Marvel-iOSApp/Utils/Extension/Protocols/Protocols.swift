//
//  FavoriteListDelegate.swift
//  Marvel-iOSApp
//
//  Created by Squad Apps on 20/12/23.
//

import Foundation

protocol TabBarDelegate: AnyObject {
    func setHeroesArray(_ heroesArray: [Hero])
    func returnToDashboard()
}

protocol FavoriteScreenDelegate: AnyObject {
    func setHeroesArray(_ heroesArray: [Hero])
    func initView(heroesArray: [Hero], delegate: TabBarDelegate)
}
