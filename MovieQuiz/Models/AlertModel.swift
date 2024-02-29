//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Илья Волощик on 15.02.24.
//

import UIKit

struct AlertModel {
    
    let title: String
    let message: String
    let buttonText: String
    var completionClosure: () -> Void
    
}
