//
//  CollectionViewCellCharCell.swift
//  Marvel-iOSApp
//
//  Created by Squad Apps on 14/12/23.
//

import UIKit
import Kingfisher

class CollectionViewCellHeroCell: UICollectionViewCell {
    
    @IBOutlet weak var viewForHeroImg: UIView!
    @IBOutlet weak var heroImg: UIImageView!
    @IBOutlet weak var heroName: UILabel!
    
    private var hero: Hero?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupVisual()
        // Initialization code
    }
    
    private func setupVisual() {
//        viewForHeroImg.backgroundColor = UIColor(named: "backgroundColorForCell")
        self.backgroundColor = UIColor(named: "backgroundColor")
        self.layer.masksToBounds = true //to apply shadow, false
        self.layer.cornerRadius = 10
        
//        self.layer.shadowRadius = 3
//        self.layer.shadowColor = UIColor.white.cgColor
//        self.layer.shadowOpacity = 0.4
//        self.layer.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    func bind(hero: Hero) {
        self.hero = hero
        self.heroName.text = hero.name
        let url = URL(string: hero.img)
        self.heroImg.kf.setImage(with: url)
    }

}
