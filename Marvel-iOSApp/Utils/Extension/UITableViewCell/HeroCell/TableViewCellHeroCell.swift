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
    @IBOutlet weak var heroComicsAvailable: UILabel!
    @IBOutlet weak var favoriteImageView: UIImageView!
    
    private var hero: Hero?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupVisual()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupVisual() {
        
    }
    
    func bind(hero: Hero) {
        self.hero = hero
        heroName.text = hero.name
        let url = URL(string: hero.img)
        heroImg.kf.setImage(with: url)
        heroDescription.text = !hero.description.isEmpty ? hero.description : "No description available"
        heroComicsAvailable.text = "Comics available: \(hero.comicsAvailables)"
    }
    
}
