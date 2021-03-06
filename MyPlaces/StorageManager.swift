//
//  StorageManager.swift
//  MyPlaces
//
//  Created by Илья Маркелов on 02/05/2019.
//  Copyright © 2019 Илья Маркелов. All rights reserved.
//

import RealmSwift

let realm = try! Realm() // Создание экземпляра Realm

//сохранение в БД
class  StorageManager {
    static func saveObject(_ place: Place) {
        try! realm.write {
            realm.add(place)
        }
    }
    
    //удаление объекта из БД
    static func deleteObject(_ place: Place) {
        try! realm.write {
            realm.delete(place)
        }
    }
}
