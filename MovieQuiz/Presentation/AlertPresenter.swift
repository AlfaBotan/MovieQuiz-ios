//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Илья Волощик on 15.02.24.
//

import UIKit

final class AlertPresenter: AlertPresenterProtocol{
    
    weak var delegate: AlertPresenterDelegate?
    
    func createAlert( model: AlertModel) {
        
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completionClosure()
        }
        alert.addAction(action)
        delegate?.didShow(alert: alert)
    }
}
