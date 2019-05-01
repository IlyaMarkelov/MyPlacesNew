//
//  PlaceModel.swift
//  MyPlaces
//
//  Created by Илья Маркелов on 01/05/2019.
//  Copyright © 2019 Илья Маркелов. All rights reserved.
//

import Foundation

struct Place {
    var name: String
    var location: String
    var type: String
    var image: String
    
    static let fastFood = ["Балкан Гриль", "Бочка", "Вкусные истории", "Дастархан", "Индокитай", "Классик", "Шок", "Bonsai", "Burger Heroes", "Kitchen", "Love&Life", "Morris Pub", "Sherlock Holmes"]
    
    static func getPlaces() -> [Place] {
        var places = [Place]()
        for place in fastFood {
            places.append(Place(name: place, location: "Москва", type: "Ресторан", image: place))
        }
        return places
    }
}
