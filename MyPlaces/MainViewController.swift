//
//  MainViewController.swift
//  MyPlaces
//
//  Created by Илья Маркелов on 01/05/2019.
//  Copyright © 2019 Илья Маркелов. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // Передавая в параметры nil мы сообщаем контроллеру поиска, что для отображения разультата поиска хотим использовать тот же вью, в котором отображается основной контент
    private let searchController = UISearchController(searchResultsController: nil)
    
    // Results - автообновляемый тип контейнера, который возвращает запрашиваемые объекты. Результаты всегда отображают  текущее состояние хранилище в текущем потоке, в том числе и во время записей транзакций. Объект Results позволяет работать с данными в реальном времени. Мы можем одновременнно записывать в него данные и тут же их считывать
    private var places: Results<Place>!
    
    //Массив отфильтрованных записей
    private var filteredPlaces: Results<Place>!
    
    //сортировка по возрастанию
    private var ascendingSorting = true
    
    //Возвращает то или иное значение(true, false) в зависимости от того является ли строка поиска пустой или нет
    private var searchBarIsEmpty: Bool {
        //извлекаем опциональное значение свойства text из объеката searchBar
        guard let text = searchController.searchBar.text else {return false}
        return text.isEmpty
    }
    //Отслеживание активации поискового запроса.
    private var isFiltering: Bool {
        //  Возвращает true, если поисковая строка активирована и не является пустой
        return searchController.isActive && !searchBarIsEmpty
    }
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var reversedSortingButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        // отображение объектов на интерфейсе
        places = realm.objects(Place.self)
        
        //Настройка search controller
        //Получаталем информации об изменении текстов в поисковой строке должен быть класс MainViewController
        searchController.searchResultsUpdater = self
        //Позволяет взаимодействовать с вью контроллером как с соновным
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        //Строка поиска будет интегрирована в навигейшн бар
        navigationItem.searchController = searchController
        //Позволяет отпустить строку поиска при переходе на другой экран
        definesPresentationContext = true
        
    }

    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            //возвращаем количество элементов массива  filteredPlaces
            return filteredPlaces.count
        }
        //если объект пустой, мы должны возвращать 0, а иначе кол-во элементов данной коллекции
        return places.isEmpty ? 0 : places.count
    }
    // Метод для работы с контентом ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell

        var place = Place()
        
        //Если поисковый запрос активирован
        if isFiltering {
            //Присваиваем объекту Place значение из массива filteredPlaces по индексу текущей строки
            place = filteredPlaces[indexPath.row]
        } else {
            //Присваиваем этому эе объекту значение из коллекции places по индексу текущей строки
            place = places[indexPath.row]
        }

        cell.nameLabel.text = place.name
        cell.locationLabel.text = place.location
        cell.typeLabel.text = place.type
        cell.imageOfPlace.image = UIImage(data: place.imageData!)
       

        cell.imageOfPlace.layer.cornerRadius = cell.imageOfPlace.frame.size.height / 2 // устанавливаем размер ячейки
        cell.imageOfPlace.clipsToBounds = true // округялем учейки

        return cell
    }
    
   
    // MARK: Table view delegate
    //метод, позволяющий вызывать различные пункты меню свайпом по ячейке справо - налево
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
       let place = places[indexPath.row] //объект для удаления
        //действия при свайпе
       let deleteAction  = UITableViewRowAction(style: .default, title: "Delete") { (_, _) in
            StorageManager.deleteObject(place)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        return [deleteAction]
    }
    

    
    // MARK: - Navigation
    //При переходе на newPlaceViewCOntroller по сегвею с идентификатором showDetail мы открываем экран редактирования выбранного объекта
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else {return}   //определить индекс выбранной ячейки
            
            // извлечение объекта из массива Places по этому же индексу
            let place: Place
            if isFiltering {
                place = filteredPlaces[indexPath.row]
            } else {
                place = places[indexPath.row]
            }
            let newPlaceVC = segue.destination as! NewPlaceViewController //экземпляр вью контроллера
            newPlaceVC.currentPlace = place // обращение к экземпляру
        }
    }
    

    //функция возврата на предыдущий view controller с новой добавленной ячейкой
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        guard let newPlaceVC = segue.source as? NewPlaceViewController else {return} // возварт с view controller'a на который переходили ранее
        
        newPlaceVC.savePlace()
        tableView.reloadData() // обновляем интерфейс
    }
    @IBAction func sortSelection(_ sender: UISegmentedControl) {
        sorting()
    }
    @IBAction func reversedSotring(_ sender: Any) {
        // toggle - менфет значение на противоположное
        ascendingSorting.toggle()
        //поменять изображение для кнопки
        //Если сортировка по возрастанию, то для кнопки reverseSortingButton мы будем использовать изображение со стрелками вниз
        // а иначе будем выбирать изображение со стрелками вверх
        if ascendingSorting {
            reversedSortingButton.image = #imageLiteral(resourceName: "AZ")
        } else {
            reversedSortingButton.image = #imageLiteral(resourceName: "ZA")
        }
        sorting()
    }
    
    private func sorting() {
        //Если выбранный индекс сегмента равен 0, то сортируем массив places по ключу date
        if segmentedControl.selectedSegmentIndex == 0 {
            places = places.sorted(byKeyPath: "date", ascending: ascendingSorting)
        } else {
            places = places.sorted(byKeyPath: "name", ascending: ascendingSorting)
        }
        // Обновление таблицы
        tableView.reloadData()
    }
}


extension MainViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    //Фильтрация контента  в соответствии поисковым запросом
    private func  filterContentForSearchText(_ searchText: String) {
        //Заполнить коллекцию filteredPlaces отфильрованными объектами из основного массива places
        // CONTAINS[c] - не смотрим на регистр символов
        // Должны будем выполнять поиск по полю name и location и type и фильтровать данные будем по значению параметра searchText
        filteredPlaces = places.filter("name CONTAINS[c] %@ OR location CONTAINS[c] %@ OR type CONTAINS[c] %@", searchText, searchText, searchText)
        
        //Обновление таблицы
        tableView.reloadData()
    }
}
