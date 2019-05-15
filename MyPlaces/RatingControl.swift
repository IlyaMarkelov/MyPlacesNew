//
//  RatingControll.swift
//  MyPlaces
//
//  Created by Илья Маркелов on 06/05/2019.
//  Copyright © 2019 Илья Маркелов. All rights reserved.
//

import UIKit

// @IBDesignable - позволяет отобразить контент в котором мы наполнили стек вью в интерфейс билдере. Все изменения в коду будут отображаться в интерфейс билдере

@IBDesignable class RatingControll: UIStackView {
    //MARK: Properties
    // Текущее значени рейтинга
    var rating = 0 {
        didSet {
            updateButtonSelectionState()
        }
    }
    
    // Массив кнопок
    private var ratingButtons = [UIButton]()
    
    // Размер кнопок
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        //Observer
        didSet {
            // В данной реализации добавляет новые кнопки
            setupButtons()
        }
    }
    
    // Количество звезд в стек вью
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    
    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    // MARK: Button action
    @objc func ratingButtonTapped(button: UIButton) {
        //Определить индекс кнопки, который касается пользователь
        //FirstIndex - возвращает индекс первого выбранного элемента
        guard let index = ratingButtons.firstIndex(of: button) else {return}
        //Определить рейтинг относительно выбранной звезды
        let selectedRating = index + 1
        //Если текущий рейтинг равен, например, 3, то при выборе 3-й звезды рейтинг обнулится
        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
        }
    }

    // MARK: Private Methods
    
    private func setupButtons() {
        // Перебирание элементы массива ratingButtons и удалть эти элементы сначала из списка сабвью а затем из стек вью
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        
        ratingButtons.removeAll()

        //Load button image
        // Отображение ресурсов которые хранятся в каталоге Accets в IB
        let bundle = Bundle(for: type(of: self))
        // Заполненная звезда
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        
        // Пустая звезда
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        
        // Звезда при тапе
        let highLightedStar = UIImage(named: "highLightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        
        
        for _  in 0..<starCount {
            //Create the button
            let  button = UIButton()
            
            //Set the button image
            //Кнопка не нажата
            button.setImage(emptyStar, for: .normal)
            // Кнопка выбрана
            button.setImage(filledStar, for: .selected)
            //Тап по кнопке
            button.setImage(highLightedStar, for: .highlighted)
            //Тап, когда кнопка выделена
            button.setImage(highLightedStar, for: [.highlighted, .selected])

            
            //Add constraints
            // Отключает автоматически сгенерированный констрейнты для кнопки
            button.translatesAutoresizingMaskIntoConstraints = false
            // Определяет высоту кнопки
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            // Определяет ширину кнопки
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            //Setup the button action
            button.addTarget(self, action: #selector(ratingButtonTapped(button:)), for: .touchUpInside)
            // Add the button to the stack
            //Добавляет кнопку в список представлений как сабвью класса RatingControll
            addArrangedSubview(button)
            
            //Add the new button on the rating button array
            ratingButtons.append(button)
        }
        
        updateButtonSelectionState()
    }
    
    private func updateButtonSelectionState() {
        for (index, button) in ratingButtons.enumerated() {
            //Если индекс кнопки будет меньше рейтинга, то свойству isSelected будет присваиваться значение true и кнопка будет отображать заполненную звезду
            // а в противном случае свойству  isSelected будет присваиваться значение false (звезда останется незаполненной)
            button.isSelected = index < rating
        }
    }
}
