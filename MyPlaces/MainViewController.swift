//
//  MainViewController.swift
//  MyPlaces
//
//  Created by Илья Маркелов on 01/05/2019.
//  Copyright © 2019 Илья Маркелов. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {

    let fastFood = ["Балкан Гриль", "Бочка", "Вкусные истории", "Дастархан", "Индокитай", "Классик", "Шок", "Bonsai", "Burger Heroes", "Kitchen", "Love&Life", "Morris Pub", "Sherlock Holmes"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fastFood.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = fastFood[indexPath.row]
        cell.imageView?.image = UIImage(named: fastFood[indexPath.row])
        cell.imageView?.layer.cornerRadius = cell.frame.size.height / 2 // устанавливаем размер ячейки
        cell.imageView?.clipsToBounds = true // округялем учейки

        return cell
    }
    
    //MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
