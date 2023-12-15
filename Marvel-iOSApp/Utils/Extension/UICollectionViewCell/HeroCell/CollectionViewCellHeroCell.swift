//
//  CollectionViewCellCharCell.swift
//  Marvel-iOSApp
//
//  Created by Squad Apps on 14/12/23.
//

import UIKit

class CollectionViewCellHeroCell: UICollectionViewCell {
    
    @IBOutlet weak var heroImg: UIImageView!
    @IBOutlet weak var heroName: UILabel!
    
    private var hero:Hero?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bind(hero: Hero) {
        self.hero = hero
        self.heroName.text = hero.data.result[0].name
    }

}
