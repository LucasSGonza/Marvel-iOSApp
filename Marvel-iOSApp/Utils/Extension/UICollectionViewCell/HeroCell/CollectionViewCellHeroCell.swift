//
//  CollectionViewCellCharCell.swift
//  Marvel-iOSApp
//
//  Created by Squad Apps on 14/12/23.
//

import UIKit
import Kingfisher

class CollectionViewCellHeroCell: UICollectionViewCell {
    
    @IBOutlet weak var heroImg: UIImageView!
    @IBOutlet weak var heroName: UILabel!
    
    private var hero: Hero?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupVisual()
        // Initialization code
    }
    
    private func setupVisual() {
        heroImg.layer.cornerRadius = 45
        heroImg.layer.borderColor = UIColor.white.cgColor
        heroImg.layer.borderWidth = 2.0
        self.backgroundColor = UIColor(named: "backgroundColorForCell")
        self.layer.cornerRadius = 8
    }
    
    func bind(hero: Hero) {
        self.hero = hero
        self.heroName.text = hero.name
        let url = URL(string: hero.img)
        self.heroImg.kf.setImage(with: url)
    }

}
