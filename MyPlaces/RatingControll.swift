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
    
    // Текущее значени рейтинга
    var rating = 0
    
    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    // MARk: Button action
    @objc func rettingButtonTapped(button: UIButton) {
        print("Button pressed")
    }

    // MARK: Private Methods
    
    private func setupButtons() {
        // Перебирание элементы массива ratingButtons и удалть эти элементы сначала из списка сабвью а затем из стек вью
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        
        ratingButtons.removeAll()
        
        for _  in 0..<starCount {
            //Create the button
            let  button = UIButton()
            button.backgroundColor = .red
            
            //Add constraints
            // Отключает автоматически сгенерированный констрейнты для кнопки
            button.translatesAutoresizingMaskIntoConstraints = false
            // Определяет высоту кнопки
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            // Определяет ширину кнопки
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            //Setup the button action
            button.addTarget(self, action: #selector(rettingButtonTapped(button:)), for: .touchUpInside)
            // Add the button to the stack
            //Добавляет кнопку в список представлений как сабвью класса RatingControll
            addArrangedSubview(button)
            
            //Add the new button on the rating button array
            ratingButtons.append(button)
            
        }
       
    }
}
