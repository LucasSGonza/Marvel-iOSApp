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
    @IBOutlet weak var heroComics: UILabel!
    @IBOutlet weak var heroSeries: UILabel!
    @IBOutlet weak var heroStories: UILabel!
    @IBOutlet weak var heroEvents: UILabel!
    
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
    
    //para retirar a tela especifica do heroi quando trocar de tela, pela tabBar, por exemplo
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.popViewController(animated: true)
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
            heroComics.text = "Comics availables: \(hero.comicsAvailables ?? 0)"
            heroSeries.text = "Series availables: \(hero.comicsAvailables ?? 0)"
            heroStories.text = "Stories availables: \(hero.comicsAvailables ?? 0)"
            heroEvents.text = "Events availables: \(hero.comicsAvailables ?? 0)"
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
