//
//  MainViewController.swift
//  MyPlaces
//
//  Created by Илья Маркелов on 01/05/2019.
//  Copyright © 2019 Илья Маркелов. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UITableViewController {

    // Results - автообновляемый тип контейнера, который возвращает запрашиваемые объекты. Результаты всегда отображают  текущее состояние хранилище в текущем потоке, в том числе и во время записей транзакций. Объект Results позволяет работать с данными в реальном времени. Мы можем одновременнно записывать в него данные и тут же их считывать
    var places: Results<Place>!
    override func viewDidLoad() {
        super.viewDidLoad()
        // отображение объектов на интерфейсе
        places = realm.objects(Place.self)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.isEmpty ? 0 : places.count //если объект пустой, мы должны возвращать 0, а иначе кол-во элементов данной коллекции
    }
    // Метод для работы с контентом ячейки
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell

        let place = places[indexPath.row]

        cell.nameLabel.text = place.name
        cell.locationLabel.text = place.location
        cell.typeLabel.text = place.type
        cell.imageOfPlace.image = UIImage(data: place.imageData!)
       

        cell.imageOfPlace.layer.cornerRadius = cell.imageOfPlace.frame.size.height / 2 // устанавливаем размер ячейки
        cell.imageOfPlace.clipsToBounds = true // округялем учейки

        return cell
    }
    
   
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    //функция возврата на предыдущий view controller с новой добавленной ячейкой
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        guard let newPlaceVC = segue.source as? NewPlaceViewController else {return} // возварт с view controller'a на который переходили ранее
        
        newPlaceVC.saveNewPlace()
        tableView.reloadData() // обновляем интерфейс
    }
}
