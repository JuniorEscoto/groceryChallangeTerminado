//
//  QuestionsViewModelTests.swift
//  Grocery ChallengeTests
//
//  Created by Aylwing Olivas on 8/16/18.
//  Copyright © 2018 Instacart. All rights reserved.
//

import XCTest
@testable import Grocery_Challenge

class QuestionsViewModelTests: XCTestCase {

    final class MockQuestionViewModelDelegate: QuestionsViewModelDelegate {

        var didLoadCalled = false
        var didErrorCalled = false
        var didSubmitCorrectAnswerCalled = false
        var didCompleteQuestionBatchCalled = false

        func didLoad() {
            didLoadCalled = true
        }

        func didError(viewError: ViewError) {
            didErrorCalled = true
        }

        func didSubmitAnswer(isCorrect: Bool) {
            didSubmitCorrectAnswerCalled = isCorrect
        }

        func didCompleteQuestionBatch() {
            didCompleteQuestionBatchCalled = true
        }
    }
    
    func test_loading_invalid() {

        struct MockQuestionStore: QuestionStore {

            var questions: [Question] = []

            func readRandomQuestion(completion: @escaping (Result<Question>) -> Void) {
                completion(.error(APIError.nilRequest))
            }

            func readAllQuestions(completion: @escaping (Result<[Question]>) -> Void) {
                completion(.error(APIError.nilRequest))
            }
        }

        let mockQuestionStore = MockQuestionStore()
        let mockQuestionViewModelDelegate = MockQuestionViewModelDelegate()
        let questionsViewModel = QuestionsViewModel(questionStore: mockQuestionStore)
        questionsViewModel.delegate = mockQuestionViewModelDelegate

        XCTAssertFalse(mockQuestionViewModelDelegate.didLoadCalled)
        XCTAssertFalse(mockQuestionViewModelDelegate.didErrorCalled)

        questionsViewModel.load()

        XCTAssertFalse(mockQuestionViewModelDelegate.didLoadCalled)
        XCTAssertTrue(mockQuestionViewModelDelegate.didErrorCalled)
    }

    func test_loading_valid() {

        struct MockQuestionStore: QuestionStore {

            var questions: [Question] = []

            func readRandomQuestion(completion: @escaping (Result<Question>) -> Void) {
                completion(.success(Question()))
            }

            func readAllQuestions(completion: @escaping (Result<[Question]>) -> Void) {
                completion(.error(APIError.nilRequest))
            }
        }

        let mockQuestionStore = MockQuestionStore()
        let mockQuestionViewModelDelegate = MockQuestionViewModelDelegate()
        let questionsViewModel = QuestionsViewModel(questionStore: mockQuestionStore)
        questionsViewModel.delegate = mockQuestionViewModelDelegate

        XCTAssertFalse(mockQuestionViewModelDelegate.didLoadCalled)
        XCTAssertFalse(mockQuestionViewModelDelegate.didErrorCalled)

        questionsViewModel.load()

        XCTAssertTrue(mockQuestionViewModelDelegate.didLoadCalled)
        XCTAssertFalse(mockQuestionViewModelDelegate.didErrorCalled)
    }

    func test_correctAnswer_selection() {

        struct MockQuestionStore: QuestionStore {

            private let correctAnswerIndex = 2

            var questions: [Question] {
                return []
            }

            func readRandomQuestion(completion: @escaping (Result<Question>) -> Void) {
                let answers = (0..<4).map { Answer(isCorrect: $0 == correctAnswerIndex) }
                completion(.success(Question(answers: answers)))
            }

            func readAllQuestions(completion: @escaping (Result<[Question]>) -> Void) {
                completion(.error(APIError.nilRequest))
            }
        }

        let mockQuestionStore = MockQuestionStore()
        let mockQuestionViewModelDelegate = MockQuestionViewModelDelegate()
        let questionsViewModel = QuestionsViewModel(questionStore: mockQuestionStore)
        questionsViewModel.delegate = mockQuestionViewModelDelegate

        XCTAssertNil(questionsViewModel.selectedIndexPath)
        XCTAssertEqual(questionsViewModel.questionsAnsweredCorrectly, 0)
        XCTAssertFalse(mockQuestionViewModelDelegate.didSubmitCorrectAnswerCalled)

        questionsViewModel.load()

        (0..<4).forEach { index in
            let indexPath = IndexPath(row: index, section: 0)
            questionsViewModel.selectedIndexPath = indexPath
            questionsViewModel.processSelectedAnswer()
        }

        XCTAssertEqual(questionsViewModel.questionsAnsweredCorrectly, 1)
    }

    func test_questionBatch_completion() {

        class MockQuestionStore: QuestionStore {

            var questions: [Question] {
                return questionContainer
            }

            var questionContainer: [Question] = [Question()]

            func readRandomQuestion(completion: @escaping (Result<Question>) -> Void) {
                completion(.success(questionContainer.removeFirst()))
            }

            func readAllQuestions(completion: @escaping (Result<[Question]>) -> Void) {
                completion(.error(APIError.nilRequest))
            }
        }

        let mockQuestionStore = MockQuestionStore()
        let mockQuestionViewModelDelegate = MockQuestionViewModelDelegate()
        let questionsViewModel = QuestionsViewModel(questionStore: mockQuestionStore)
        questionsViewModel.delegate = mockQuestionViewModelDelegate

        XCTAssertFalse(mockQuestionViewModelDelegate.didCompleteQuestionBatchCalled)

        questionsViewModel.selectedIndexPath = IndexPath()
        mockQuestionStore.questionContainer.removeAll()
        questionsViewModel.processSelectedAnswer()
        XCTAssertTrue(mockQuestionViewModelDelegate.didCompleteQuestionBatchCalled)
    }
}

private extension Question {
    init(answers: [Answer] = []) {
        query = ""
        self.answers = answers
    }
}

private extension Answer {
    init(isCorrect: Bool = false) {
        url = URL(fileURLWithPath: "")
        correct = isCorrect
    }
}
