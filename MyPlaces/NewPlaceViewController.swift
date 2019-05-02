//
//  NewPlaceViewController.swift
//  MyPlaces
//
//  Created by Илья Маркелов on 02/05/2019.
//  Copyright © 2019 Илья Маркелов. All rights reserved.
//

import UIKit

class NewPlaceViewController: UITableViewController {
    
    var newPlace: Place?

    var imageIsChanged = false
    @IBOutlet var saveButton: UIBarButtonItem!
    
    @IBOutlet var placeImage: UIImageView!
    @IBOutlet var placeName: UITextField!
    @IBOutlet var placeLocation: UITextField!
    @IBOutlet var placeType: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView() // заменим разлиновку на обычный view
        
        saveButton.isEnabled = false // по умолчанию кнопка save будет отключена
        
        placeName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged) //при редактировании текст. поля name будет срабатывать метод, который будет вызывать метод textFieldChanged
        
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
    
    //Сохранение новой ячейки при добавлении
    func saveNewPlace() {
        
        var image: UIImage?
        // Если изображение было изменено пользователем, то для свойства image присваиваем значение , которое берем из imageView - placeImage
        //Иначе присваиваем свое изображение
        if imageIsChanged {
            image = placeImage.image
        } else {
            image = #imageLiteral(resourceName: "imagePlaceholder")
        }
        
        newPlace = Place(name: placeName.text!,
                         location: placeLocation.text,
                         type: placeType.text,
                         image: image,
                         resturantImage: nil)
    }
    //Закрытие view controller
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: Text field delegate
extension NewPlaceViewController: UITextFieldDelegate {
    
    // Скрываем клавиатуру по нажатию на Done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //(заполнено текстовове поле или нет). Если текст. поле заполнено. то кнопка save будет активна
    @objc private func textFieldChanged() {
        if placeName.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
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
        placeImage.image = info[.editedImage] as? UIImage
        placeImage.contentMode = .scaleAspectFit // позволяет масштабировать изображение по содержимому UIImage
        placeImage.clipsToBounds = true //обрезать изображение по границам самого UIImage
        
        imageIsChanged = true
        
        dismiss(animated: true) // закрыть imagePickerController
    }
}
