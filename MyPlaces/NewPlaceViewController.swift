//
//  NewPlaceViewController.swift
//  MyPlaces
//
//  Created by Илья Маркелов on 02/05/2019.
//  Copyright © 2019 Илья Маркелов. All rights reserved.
//

import UIKit

class NewPlaceViewController: UITableViewController {

    @IBOutlet weak var imageOfPlace: UIImageView!
    
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
            let cameraIcon = #imageLiteral(resourceName: "camera") // создание иконки камера
            let photoIcon = #imageLiteral(resourceName: "photo") // создание иконки фото
            
            let actionSheet = UIAlertController(title: nil, // окно при добавлении нового изображения
                                                message: nil,
                                                preferredStyle: .actionSheet)
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in
                self.chooseImagePicker(source: .camera)
            }
            camera.setValue(cameraIcon, forKey: "image")// добавление иконки камеры в меню
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment") // перенос текста к левому краю
            
            let photo = UIAlertAction(title: "Photo", style: .default) { _ in
                self.chooseImagePicker(source: .photoLibrary)
            }
            photo.setValue(photoIcon, forKey: "image") // добавление иконки фото в меню
            photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment") // перенос текста к левому краю
            
            
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
extension NewPlaceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate /*позволяет определить переходы в стеки view controller'ов, которые открываются при выборе изображений */ {
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) { // проверка на доступность источника выбора изображения
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self // делегирование обязанностей по методу imagePickerController
            imagePicker.allowsEditing = true //позволить пользователю редактировать выбранное изображение
            imagePicker.sourceType = source // определяем тип источника выбора изображения
            present(imagePicker, animated: true) // отображение на экране
        }
    }
    
    // Позволяет использовать отредактированное пользователем изображение
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageOfPlace.image = info[.editedImage] as? UIImage
        imageOfPlace.contentMode = .scaleAspectFit // позволяет масштабировать изображение по содержимому UIImage
        imageOfPlace.clipsToBounds = true //обрезать изображение по границам самого UIImage
        dismiss(animated: true) // закрыть imagePickerController
    }
}
