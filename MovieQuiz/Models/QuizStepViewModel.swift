//
//  QuizStepViewModel.swift
//  MovieQuiz
//
//  Created by Илья Волощик on 14.02.24.
//

import UIKit

// вью модель для состояния "Вопрос показан"

struct QuizStepViewModel {
    
  // картинка с афишей фильма с типом UIImage
    var image: UIImage
  // вопрос о рейтинге квиза
    var question: String
  // строка с порядковым номером этого вопроса (ex. "1/10")
    var questionNumber: String
    
}
