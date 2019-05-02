//
//  NewPlaceViewController.swift
//  MyPlaces
//
//  Created by Илья Маркелов on 02/05/2019.
//  Copyright © 2019 Илья Маркелов. All rights reserved.
//

import UIKit

class NewPlaceViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView() // заменим разлиновку на обычный view
        
        
    }
    
    // MARK: Table view delegate
    // Скрываем клавиатуру при тапу по экрану
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0  { // если первая ячейка имеет индекс 0,
                                //мы должны вызвать меню,
                                //чтобы пользователь выбрал изображение,
                                //а иначе мы должны скрыть клавиатуру
        } else {
            view.endEditing(true)
        }
    }
}

// MARK: Text field delegate

extension NewPlaceViewController: UITextFieldDelegate {
    
    // Скрываем клавиатуру по нажатию на Done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
