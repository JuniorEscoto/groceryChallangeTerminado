//
//  QuestionsAPI.swift
//  Grocery Challenge
//
//  Created by Andrew Crookston on 5/14/18.
//  Copyright © 2018 Instacart. All rights reserved.
//

import Foundation

protocol QuestionStore: Service {
    var questions: [Question] { get }
    func readRandomQuestion(completion: @escaping (Result<Question>) -> Void)
    func readAllQuestions(completion: @escaping (Result<[Question]>) -> Void)
}

final class QuestionsAPI {

    var request: Requests = QuestionsRequest()

    private struct QuestionsContainer: Codable {
        var questions: [Question] = []
    }

    private var questionsContainer = QuestionsContainer()
}

extension QuestionsAPI: QuestionStore {

    var questions: [Question] {
        return questionsContainer.questions
    }

    func readRandomQuestion(completion: @escaping (Result<Question>) -> Void) {

        readAllQuestions { [weak self] result in

            guard let strongSelf = self else { return }

            switch result {

            case .success(let questions):

                guard let randomQuestion = questions.randomElement, !questions.isEmpty else {
                    completion(.error(APIError.noQuestions))
                    return
                }

                strongSelf.questionsContainer.questions.remove(at: randomQuestion.index)
                completion(.success(randomQuestion.element))

            case .error(let error):
                completion(.error(error))
            }
        }
    }

    func readAllQuestions(completion: @escaping (Result<[Question]>) -> Void) {

        if questionsContainer.questions.isEmpty {

            get(request: request) { [weak self] result in

                guard let strongSelf = self else { return }

                switch result {

                case .success(let data):

                    do {

                        strongSelf.questionsContainer = try JSONDecoder().decode(QuestionsContainer.self, from: data)
                        completion(.success(strongSelf.questionsContainer.questions))

                    } catch {
                        completion(.error(.otherError(error)))
                    }

                case .error(let error):
                    completion(.error(error))
                }
            }

        } else {
            completion(.success(questionsContainer.questions))
        }
    }
}
