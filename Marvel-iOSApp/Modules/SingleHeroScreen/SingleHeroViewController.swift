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
    
    @IBOutlet weak var heroDescription: UITextView!

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
        setupScreenVisual()
        setupVisualForHeroInfos()
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
            image: UIImage(systemName: "chevron.backward"),
            style: .done,
            target: self,
            action: #selector(goBack)
        )
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
        self.navigationItem.title = hero?.name ?? "Single Hero"
    }
    
    @objc private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupScreenVisual() {
        viewForHeroImg.layer.cornerRadius = 10
        viewForHeroImg.layer.masksToBounds = true
        viewForInfos.layer.cornerRadius = 10
        
        heroDescription.layer.backgroundColor = UIColor(named: "backgroundColorForDescription")?.cgColor ?? UIColor.gray.cgColor
        heroDescription.layer.cornerRadius = 10
    }
    
    private func setupVisualForHeroInfos() {
        if let hero = hero {
            heroName.text = hero.name
            let urlImg = URL(string: hero.img)
            heroImg.kf.setImage(with: urlImg)
            heroDescription.text = hero.description.isEmpty ? "No description available" : hero.description

            heroComics.text = "Comics availables: \(hero.comicsAvailables)"
            heroSeries.text = "Series availables: \(hero.seriesAvailables)"
            heroStories.text = "Stories availables: \(hero.storiesAvailables)"
            heroEvents.text = "Events availables: \(hero.eventsAvailables)"
            
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
