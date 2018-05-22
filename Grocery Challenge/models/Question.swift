//
//  Question.swift
//  Grocery Challenge
//
//  Created by Andrew Crookston on 5/14/18.
//  Copyright © 2018 Instacart. All rights reserved.
//

import Foundation

struct Answer: Codable {
    let url: URL
    let correct: Bool
}

struct Question: Codable {
    let query: String
    let answers: [Answer]
}

extension Question {
    enum QuestionErrors: Error {
        case noQuestions
    }

    static func randomQuestion(from api: API = ChallengeAPI(),
                               request: Requests = .questions,
                               _ completion: @escaping (Result<Question>) -> Void) {
        allQuestions(from: api, request: request) { result in
            switch result {
            case .success(let questions):
                guard questions.count > 0 else {
                    completion(.error(QuestionErrors.noQuestions))
                    return
                }
                let index = Int(arc4random_uniform(UInt32(questions.count)))
                completion(.success(questions[index]))
            case .error(let error):
                completion(.error(error))
            }
        }
    }

    static func allQuestions(from api: API = ChallengeAPI(),
                             request: Requests = .questions,
                             _ completion: @escaping (Result<[Question]>) -> Void) {
        api.get(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let questions: Questions = try JSONDecoder().decode(Questions.self, from: data)
                    completion(.success(questions.questions))
                } catch {
                    completion(.error(error))
                }
            case .error(let error):
                completion(.error(error))
            }
        }
    }

    // Only used for decoding
    private struct Questions: Codable {
        let questions: [Question]
    }
}
