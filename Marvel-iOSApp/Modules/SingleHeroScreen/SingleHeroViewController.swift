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
    
    private var hero: Hero? //ira receber a referencia de hero

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVisual()
        favoriteHero()
        setupNavBar()
    }
    
    //está igualando a referencia ao espaço de memoria na qual esse hero está na array da dashboard
    func initView(hero: Hero) {
        self.hero = hero
    }
    
    private func setupNavBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close, target: self, action: #selector(goBack))
    }
    
    @objc private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupVisual() {
        if let hero = hero {
            heroName.text = hero.name
            let urlImg = URL(string: hero.img)
            heroImg.kf.setImage(with: urlImg)
            heroDescription.text = !hero.description.isEmpty ? hero.description : "No description available"
            favoriteImageView.image = hero.isFavorite ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
        }
    }
    
    private func favoriteHero() {
        favoriteImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addFavorite)))
    }
    
    @objc private func addFavorite() {
        if let hero = hero {
            if hero.isFavorite {
                favoriteImageView.image = UIImage(systemName: "bookmark")
                hero.isFavorite = false
            } else {
                favoriteImageView.image = UIImage(systemName: "bookmark.fill")
                hero.isFavorite = true
            }
        }
    }

}
