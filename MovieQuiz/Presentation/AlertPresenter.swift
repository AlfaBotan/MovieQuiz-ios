//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Илья Волощик on 15.02.24.
//

import UIKit

class AlertPresenter: AlertPresenterProtocol{
    
    weak var delegate: AlertPresenterDelegate?
    
    func createAlert( model: AlertModel) {
        
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completionClosure()
        }
        alert.addAction(action)
        delegate?.didShow(alert: alert)
        
        // MARK: - вопрос наставнку либо ревьюеру, есть ли смысл вызывать презент отсюда? просто тогда метод который должен быть реализован по протоколу делегата во вью контроллере останется пустым.

//        // Получаем активную сцену
//                if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
//                    // Получаем окно сцены и корневой контроллер
//                    if let window = scene.windows.first, 
//                       let rootViewController = window.rootViewController {
//                        rootViewController.present(alert, animated: true, completion: nil)
//                    }
//                }


    }
}
