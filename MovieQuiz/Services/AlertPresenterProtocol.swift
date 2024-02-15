//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Илья Волощик on 15.02.24.
//

import UIKit

protocol AlertPresenterProtocol {
    
    func createAlert( model: AlertModel)
    
    var delegate: AlertPresenterDelegate? {get set}
    
}
