//
//  QuestionsViewModel.swift
//  Grocery Challenge
//
//  Created by Aylwing Olivas on 8/16/18.
//  Copyright © 2018 Instacart. All rights reserved.
//

import Foundation

protocol QuestionsViewModelDelegate: class {
    func didLoad()
    func didError(viewError: ViewError)
    func didSubmitAnswer(isCorrect: Bool)
    func didCompleteQuestionBatch()
}

final class QuestionsViewModel {

    // MARK: - Public properties
    weak var delegate: QuestionsViewModelDelegate?
    var selectedIndexPath: IndexPath?
    private (set) var questionsAnsweredCorrectly = 0

    var question: String? {
        return questionObject?.query
    }

    var completedQuestionBatch: Bool {
        return questionStore.questions.isEmpty
    }

    // MARK: - Private properties
    private let questionStore: QuestionStore
    private var questionObject: Question?

    init(questionStore: QuestionStore = QuestionsAPI()) {
        self.questionStore = questionStore
    }

    // MARK: - Public functions
    func load() {
        questionStore.readRandomQuestion { [unowned self] result in
            switch result {

            case .success(let question):
                self.questionObject = question
                self.questionObject?.answers.shuffle()
                self.delegate?.didLoad()

            case .error(let error): break
                self.delegate?.didError(viewError: ViewError(apiError: error))
            }
        }
    }

    func processSelectedAnswer() {
        guard let selectedIndexPath = selectedIndexPath else { return }

        let isCorrect = questionObject?.answers[selectedIndexPath.row].correct ?? false
        delegate?.didSubmitAnswer(isCorrect: isCorrect)

        if isCorrect {
            questionsAnsweredCorrectly += 1
        }

        if questionStore.questions.isEmpty {
            delegate?.didCompleteQuestionBatch()
        }
    }

    func numberOfAnswersForQuestion() -> Int {
        return questionObject?.answers.count ?? 0
    }

    func imageURL(for indexPath: IndexPath) -> URL? {
        return questionObject?.answers[indexPath.row].url
    }
}
