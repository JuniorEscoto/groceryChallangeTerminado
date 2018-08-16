//
//  QuestionsViewController.swift
//  Grocery Challenge
//
//  Created by Aylwing Olivas on 8/16/18.
//  Copyright © 2018 Instacart. All rights reserved.
//

import UIKit

final class QuestionsViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var bannerContainerYOffset: NSLayoutConstraint!
    @IBOutlet private weak var bannerContainerView: UIView!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var submitButton: PrimaryButton!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Public properties
    weak var transitionDelegate: TransitionDelegate?

    // MARK: - Private properties
    private let viewModel: QuestionsViewModel
    private let dispatchQueue = DispatchQueue.main
    private let flowLayout: AnswersCollectionFlowLayout
    private let bannerView = AnswerStatusBanner.nibView
    private var answerCells: [AnswerSelectionCell] = []
    private var dispatchWorkItem: DispatchWorkItem?

    // MARK: - Lifecycle
    init(viewModel: QuestionsViewModel = QuestionsViewModel()) {
        self.viewModel = viewModel
        self.flowLayout = AnswersCollectionFlowLayout()
        super.init(nibName: String(describing: QuestionsViewController.self), bundle: Bundle(for: QuestionsViewController.self))
        self.viewModel.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        bannerContainerView.isHidden = true
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        flowLayout.updateNumberOfColumns()
    }

    // MARK: - IBActions
    @IBAction private func closeButtonTapped(_ sender: Any) {
        transitionDelegate?.process(transition: .endShopping)
    }

    @IBAction private func submitButtonTapped(_ sender: Any) {
        viewModel.processSelectedAnswer()
    }

    // MARK: - Private functions
    private func setUI() {
        bannerContainerView.isHidden = true
        submitButton.isEnabled = false
        activityIndicator.startAnimating()
        collectionView?.register(cellType: AnswerSelectionCell.self)
        bannerContainerView.addSubViewWithFillConstraints(bannerView)
        collectionView.setCollectionViewLayout(flowLayout, animated: false)
        bannerContainerYOffset.constant = -bannerContainerView.bounds.height
        viewModel.load()
    }

    private func showBanner(type: AnswerStatusBanner.BannerType, text: String?, duration: TimeInterval = 0.3) {

        dispatchWorkItem?.cancel()
        bannerContainerYOffset.constant = view.bounds.minY
        bannerContainerView.isHidden = false
        bannerView.showBanner(text: text, bannerType: type)

        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: .curveEaseInOut,
                       animations: { self.view.layoutIfNeeded() })

        let dismissBannerWorkItem = DispatchWorkItem {
                self.bannerContainerYOffset.constant = -self.bannerContainerView.bounds.height
                UIView.animate(withDuration: duration,
                               delay: 0,
                               usingSpringWithDamping: 1,
                               initialSpringVelocity: 0,
                               options: .curveEaseInOut,
                               animations: {
                                self.view.layoutIfNeeded()
                }, completion: { _ in
                    self.bannerContainerView.isHidden = true
                })
        }

        dispatchQueue.asyncAfter(deadline: .now() + duration + 1, execute: dismissBannerWorkItem)
        dispatchWorkItem = dismissBannerWorkItem
    }
}

extension QuestionsViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfAnswersForQuestion()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell: AnswerSelectionCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.download(url: viewModel.imageURL(for: indexPath))
        answerCells.append(cell)
        cell.cellIsSelected = viewModel.selectedIndexPath == indexPath

        cell.didTap = { [unowned self] in
            self.submitButton.isEnabled = true
            self.answerCells.forEach { $0.cellIsSelected = false }
            self.viewModel.selectedIndexPath = indexPath
        }
        
        return cell
    }
}

extension QuestionsViewController: QuestionsViewModelDelegate {

    func didLoad() {
        DispatchQueue.main.async { [unowned self] in
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.questionLabel.text = self.viewModel.question
            UIView.transition(with: self.view,
                              duration: 0.2,
                              options: .transitionCrossDissolve,
                              animations: self.collectionView.reloadData)
        }
    }

    func didError(viewError: ViewError) {
        DispatchQueue.main.async { [unowned self] in
            self.showBanner(type: .error, text: viewError.errorDescription)
        }
    }

    func didSubmitAnswer(isCorrect: Bool) {

        // FIXME: All strings presented to user should be localized
        if isCorrect {
            showBanner(type: .success, text: "Nice! You got it right")
        } else {
            showBanner(type: .error, text: "Awe! You missed that one")
        }

        submitButton.isEnabled = false
        viewModel.load()
    }

    func didCompleteQuestionBatch() {

        let cancelCallback: Callback = { [unowned self] in
            self.dispatchQueue.async {
                self.transitionDelegate?.process(transition: .endShopping)
            }
        }

        let acceptCallback = { [unowned self] in
            self.dispatchQueue.async {
                self.viewModel.load()
            }
        }

        // FIXME: All strings presented to user should be localized
        let attributedTitle = NSMutableAttributedString()
        attributedTitle
            .newLine()
            .image(#imageLiteral(resourceName: "GreenCircleCheckMark"))
            .newLine()
            .newLine()
            .text("All Done!")

        let quantityVerb = viewModel.questionsAnsweredCorrectly == 1 ? "time" : "times"
        presentAlert(attributedTitle: attributedTitle,
                     message: "You answered correctly \(viewModel.questionsAnsweredCorrectly) \(quantityVerb)!",
                     cancelButtonTitle: "Stop Shopping",
                     acceptButtonTitle: "Continue Shopping",
                     cancelCallback: cancelCallback,
                     acceptCallback: acceptCallback)
    }
}
