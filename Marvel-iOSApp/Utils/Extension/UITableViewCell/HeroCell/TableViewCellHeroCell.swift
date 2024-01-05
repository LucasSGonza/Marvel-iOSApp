//
//  TableViewCellHeroCell.swift
//  Marvel-iOSApp
//
//  Created by Squad Apps on 20/12/23.
//

import UIKit

class TableViewCellHeroCell: UITableViewCell {
    
    @IBOutlet weak var viewForImage: UIView!
    @IBOutlet weak var heroImg: UIImageView!
    @IBOutlet weak var heroName: UILabel!
    @IBOutlet weak var heroDescription: UILabel!
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var favoriteImageView: UIImageView!
    
    private var hero: Hero?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        favoriteHero()
        setupVisual()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    private func setupVisual() {
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = false
        
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = 10
        
        self.layer.shadowRadius = 3
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.80
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        self.backgroundColor = .clear
    }
    
    func bind(hero: Hero) {
        favoriteImageView.image = UIImage(systemName: "bookmark.fill")
        self.hero = hero
        heroName.text = hero.name
        let url = URL(string: hero.img)
        heroImg.kf.setImage(with: url)
        heroDescription.text = !hero.description.isEmpty ? hero.description : "No description available"
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
