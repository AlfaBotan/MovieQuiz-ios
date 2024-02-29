//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Илья Волощик on 15.02.24.
//

import UIKit

protocol AlertPresenterProtocol {
    
    var delegate: AlertPresenterDelegate? {get set}
    
    func createAlert( model: AlertModel)
}
