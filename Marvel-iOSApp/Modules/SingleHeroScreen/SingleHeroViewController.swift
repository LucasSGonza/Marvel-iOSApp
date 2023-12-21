//
//  SingleHeroViewController.swift
//  Marvel-iOSApp
//
//  Created by Squad Apps on 21/12/23.
//

import UIKit

class SingleHeroViewController: UIViewController {
    
    @IBOutlet weak var heroName: UILabel!
    @IBOutlet weak var heroImg: UIImageView!
    @IBOutlet weak var heroDescription: UILabel!
    @IBOutlet weak var viewForHeroImg: UIView!
    @IBOutlet weak var viewForInfos: UIView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    
    private weak var delegateTabBar: TabBarDelegate?
    private var heroesArray: [Hero] = [] //recebe a Array para poder salvar o dado (favoritado ou nao)
    private var heroID: Int? //para buscar na Array o heroi especifico

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVisual()
        favoriteHero()
        setupNavBar()
    }
    
    func initView(heroesArray: [Hero], heroID: Int) {
        self.heroesArray = heroesArray
        self.heroID = heroID
    }
    
    private func setupNavBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close, target: self, action: #selector(goBack))
    }
    
    @objc private func goBack() {
        delegateTabBar?.setHeroesArray(self.heroesArray)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupVisual() {
        guard let hero = self.heroesArray.first(where: {$0.id == heroID}) else { return }
        heroName.text = hero.name
        let urlImg = URL(string: hero.img)
        heroImg.kf.setImage(with: urlImg)
        heroDescription.text = !hero.description.isEmpty ? hero.description : "No description available"
        favoriteImageView.image = hero.isFavorite ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
//        viewForHeroImg.layer.masksToBounds = true
//        viewForHeroImg.layer.cornerRadius = 100
//        viewForHeroImg.layer.borderWidth = 3.0
//        viewForHeroImg.layer.borderColor = UIColor.white.cgColor
        viewForInfos.layer.cornerRadius = 15
    }
    
    private func favoriteHero() {
        favoriteImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addFavorite)))
    }
    
    @objc private func addFavorite() {
        guard let hero = self.heroesArray.first(where: {$0.id == heroID}) else { return }
        if hero.isFavorite {
            favoriteImageView.image = UIImage(systemName: "bookmark")
            hero.isFavorite = false
        } else {
            favoriteImageView.image = UIImage(systemName: "bookmark.fill")
            hero.isFavorite = true
        }
        print(hero.isFavorite)
    }

}
