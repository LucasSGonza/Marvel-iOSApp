//
//  HeroInformation.swift
//  Marvel-iOSApp
//
//  Created by Squad Apps on 10/01/24.
//

struct HeroInformation: Decodable {
    var id: Int
    var name: String
    var description: String
    var thumbnail: HeroImage
    var comics: Comics
    var series: Series
    var stories: Stories
    var events: Events
}
