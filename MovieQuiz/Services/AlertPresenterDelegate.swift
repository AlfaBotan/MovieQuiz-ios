//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Илья Волощик on 15.02.24.
//

import UIKit

protocol AlertPresenterDelegate: AnyObject {
    
    func didShow(alert: UIAlertController?)
    
}
