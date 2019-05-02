//
//  PlaceModel.swift
//  MyPlaces
//
//  Created by Илья Маркелов on 01/05/2019.
//  Copyright © 2019 Илья Маркелов. All rights reserved.
//

import RealmSwift

class Place: Object {
    @objc dynamic var name = ""
    @objc dynamic var location: String?
    @objc dynamic var type: String?
    @objc dynamic var imageData: Data?
    
    let fastFood = ["Балкан Гриль", "Бочка", "Вкусные истории", "Дастархан", "Индокитай", "Классик", "Шок", "Bonsai", "Burger Heroes", "Kitchen", "Love&Life", "Morris Pub", "Sherlock Holmes"]
    
    func savePlaces() {
        for place in fastFood {
            
            let image = UIImage(named: place)
            guard let imageData = image?.pngData() else {return} //pngData позволяет сконвертировтаь изображение в тип Data
            
            let newPlace = Place()
            
            newPlace.name = place
            newPlace.location = "Moscow"
            newPlace.type = "Resaurant"
            newPlace.imageData = imageData
            
            StorageManager.saveObject(newPlace)
        }
    }
}
