//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Илья Волощик on 14.02.24.
//

import UIKit

protocol QuestionFactoryProtocol {
    
    var  delegate:QuestionFactoryDelegate? { get set}
    
    func requestNextQuestion()
    func loadData()
    
}
