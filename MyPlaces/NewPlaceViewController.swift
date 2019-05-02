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
            let actionSheet = UIAlertController(title: nil, // окно при добавлении нового изображения
                                                message: nil,
                                                preferredStyle: .actionSheet)
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in
                self.chooseImagePicker(source: .camera)
            }
            
            let photo = UIAlertAction(title: "Photo", style: .default) { _ in
                self.chooseImagePicker(source: .photoLibrary)
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            
            present(actionSheet, animated: true)
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

// MARK: Work with image
extension NewPlaceViewController {
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) { // проверка на доступность источника выбора изображения
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true //позволить пользователю редактировать выбранное изображение
            imagePicker.sourceType = source // определяем тип источника выбора изображения
            present(imagePicker, animated: true) // отображение на экране
        }
    }
}
