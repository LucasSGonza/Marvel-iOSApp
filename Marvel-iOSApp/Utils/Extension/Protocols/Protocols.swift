//
//  FavoriteListDelegate.swift
//  Marvel-iOSApp
//
//  Created by Squad Apps on 20/12/23.
//

import Foundation

protocol TabBarDelegate: AnyObject {
    func setHeroesArray(_ heroesArray: [Hero])
}

protocol FavoriteScreenDelegate: AnyObject {
    func setHeroesArray(_ heroesArray: [Hero])
}

//Dashboard nao precisa ter delegate, visto que as unicas alterações na Array são feitas diretamente no heroi que é passado para a SingleHeroScreen, este que já tem como referencia de memoria a array da dashboard, por isso que as alterações acontecem

//protocol DashboardDelegate: AnyObject {
//    func setHeroesArray(_ heroesArray: [Hero])
//}
