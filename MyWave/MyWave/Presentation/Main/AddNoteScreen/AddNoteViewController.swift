//
//  AddNoteViewController.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 22.02.2025.
//

import UIKit
import SnapKit

final class AddNoteViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: AddNoteViewModel
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var card = UIView()
    private var collectionView: UICollectionView!
    private let newTagTextField = UITextField()
    private let saveNoteButton = CustomLargeButton(style: .white)
    
    private var collectionViewHeightConstraint: Constraint?
    
    // MARK: - Initialization
    
    init(viewModel: AddNoteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UI Setup

extension AddNoteViewController {
    
    private func setupUI() {
        view.backgroundColor = Metrics.Colors.background
        configureScrollView()
        configureCard()
        configureCollectionView()
        configureTextField()
        configureSaveButton()
        setupKeyboardObservers()
        updateCollectionViewHeight()
    }
    
    private func configureScrollView() {
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
    }
    
    private func configureCard() {
        card.removeFromSuperview()
        card = createCardView(
            date: viewModel.selectedDate,
            emotion: viewModel.selectedEmotion,
            type: viewModel.selectedCardType
        )
        contentView.addSubview(card)
    }
    
    private func configureCollectionView() {
        let layout = LeftAlignedFlowLayout()
        layout.minimumLineSpacing = Constants.smallSpacing / 2
        layout.minimumInteritemSpacing = Constants.smallSpacing / 2
        layout.sectionInset = UIEdgeInsets(
            top: 0,
            left: Constants.contentInsets,
            bottom: Constants.smallSpacing,
            right: Constants.contentInsets
        )
        layout.headerReferenceSize = CGSize(width: view.frame.width, height: Constants.sectionHeaderHeight)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: TagCell.identifier)
        collectionView.register(AddTagCell.self, forCellWithReuseIdentifier: AddTagCell.identifier)
        collectionView.register(
            SectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderView.identifier
        )
        
        contentView.addSubview(collectionView)
    }
    
    private func configureTextField() {
        newTagTextField.delegate = self
        newTagTextField.backgroundColor = Metrics.Colors.tagBackground
        newTagTextField.textColor = Metrics.Colors.text
        newTagTextField.tintColor = Metrics.Colors.text
        newTagTextField.layer.cornerRadius = Constants.tagCellHeight / 2
        newTagTextField.font = Metrics.Fonts.tagFont
        newTagTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.smallSpacing, height: 0))
        newTagTextField.leftViewMode = .always
        newTagTextField.returnKeyType = .done
        newTagTextField.isHidden = true
        view.addSubview(newTagTextField)
    }
    
    private func configureSaveButton() {
        saveNoteButton.setTitle(Metrics.Strings.saveButtonTitle, for: .normal)
        saveNoteButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        view.addSubview(saveNoteButton)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(view.safeAreaLayoutGuide)
            $0.height.greaterThanOrEqualTo(view.safeAreaLayoutGuide).priority(.required)
        }
        
        card.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.contentInsets)
            $0.leading.trailing.equalToSuperview().inset(Constants.contentInsets)
            $0.height.equalTo(Constants.cardHeight)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(card.snp.bottom).offset(Constants.contentInsets)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-Constants.contentInsets).priority(.high)
            collectionViewHeightConstraint = $0.height.equalTo(0).priority(.medium).constraint
        }
        
        saveNoteButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Constants.contentInsets)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-Constants.contentInsets)
        }
        
        DispatchQueue.main.async {
            self.updateBottomSpacing()
        }
    }
    
    private func updateBottomSpacing() {
        let saveButtonTop = saveNoteButton.frame.maxY
        let bottomSpacing = UIScreen.main.bounds.height - saveButtonTop + Constants.contentInsets
        print(bottomSpacing)
        contentView.snp.updateConstraints {
            $0.bottom.equalToSuperview().inset(bottomSpacing)
        }
    }

    
}

// MARK: - Card Creation

extension AddNoteViewController {
    
    private func createCardView(date: Date, emotion: String, type: CardType) -> UIView {
        let card = MoodCardView()
        card.type = type
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateStyle = .medium
        dateFormatter.doesRelativeDateFormatting = true
        let dateString = dateFormatter.string(from: date)
        
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "ru_RU")
        timeFormatter.timeStyle = .short
        let timeString = timeFormatter.string(from: date)
        
        let dateLabel = UILabel()
        dateLabel.text = "\(dateString), \(timeString)"
        dateLabel.textColor = Metrics.Colors.text
        dateLabel.font = Metrics.Fonts.cardDateFont
        
        let emotionText = NSMutableAttributedString(
            string: "\(Metrics.Strings.feelText)\n",
            attributes: [
                .foregroundColor: Metrics.Colors.text,
                .font: Metrics.Fonts.cardEmotionFont
            ]
        )
        emotionText.append(NSAttributedString(
            string: emotion,
            attributes: [
                .foregroundColor: type.emotionTextColor,
                .font: Metrics.Fonts.cardEmotionHighlightFont
            ]
        ))
        
        let emotionLabel = UILabel()
        emotionLabel.numberOfLines = 2
        emotionLabel.attributedText = emotionText
        
        card.addSubview(dateLabel)
        card.addSubview(emotionLabel)
        
        dateLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(Constants.smallSpacing)
            $0.trailing.lessThanOrEqualTo(card.imageView.snp.leading).offset(-Constants.smallSpacing)
        }
        
        emotionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(Constants.smallSpacing)
            $0.bottom.lessThanOrEqualToSuperview().inset(Constants.smallSpacing)
        }
        
        return card
    }
}

// MARK: - Collection View Management

extension AddNoteViewController {
    
    private func updateCollectionViewHeight() {
        collectionView.layoutIfNeeded()
        let height = collectionView.collectionViewLayout.collectionViewContentSize.height
        collectionViewHeightConstraint?.update(offset: height)
        view.layoutIfNeeded()
    }
    
    private func showTextField(at indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? AddTagCell else { return }
        
        collectionView.addSubview(newTagTextField)
        newTagTextField.isHidden = false
        newTagTextField.text = ""
        newTagTextField.frame = cell.frame
        
        UIView.animate(withDuration: Constants.animationDuration) {
            self.newTagTextField.transform = .identity
            self.newTagTextField.frame = CGRect(
                x: cell.frame.origin.x,
                y: cell.frame.origin.y,
                width: min(Constants.tagTextFieldMaxWidth, self.collectionView.frame.width - cell.frame.origin.x - Constants.contentInsets),
                height: Constants.tagCellHeight
            )
        }
        
        newTagTextField.becomeFirstResponder()
    }
    
    private func hideTextField() {
        newTagTextField.resignFirstResponder()
        newTagTextField.isHidden = true
        viewModel.setAddingTag(false)
    }
    
    private func reloadAddButton(for section: Int) {
        let addButtonIndex = IndexPath(item: viewModel.sections[section].items.count, section: section)
        UIView.performWithoutAnimation {
            collectionView.reloadItems(at: [addButtonIndex])
        }
    }
}

// MARK: - Keyboard Handling

extension AddNoteViewController {
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        updateCollectionViewHeight()
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let adjustedOffset = keyboardFrame.height
        scrollView.snp.updateConstraints {
            $0.bottom.equalToSuperview().offset(-adjustedOffset)
        }
        
        UIView.animate(withDuration: Constants.animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide() {
        scrollView.snp.updateConstraints {
            $0.bottom.equalToSuperview()
        }
        
        UIView.animate(withDuration: Constants.animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - Actions

extension AddNoteViewController {
    
    @objc private func doneTapped() {
        viewModel.completeFlow()
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource

extension AddNoteViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.sections[section].items.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        let item = indexPath.item
        
        if item == viewModel.sections[section].items.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddTagCell.identifier, for: indexPath) as! AddTagCell
            cell.configure()
            return cell
        }
        
        let tag = viewModel.sections[section].items[item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.identifier, for: indexPath) as! TagCell
        cell.configure(with: tag, isSelected: viewModel.selectedTags.contains(tag))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SectionHeaderView.identifier,
            for: indexPath
        ) as! SectionHeaderView
        
        header.configure(title: viewModel.sections[indexPath.section].title)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.section
        let item = indexPath.item
        
        if item == viewModel.sections[section].items.count {
            viewModel.setEditingSection(section)
            viewModel.toggleAddingTag()
            
            if viewModel.isAddingTag {
                showTextField(at: indexPath)
            } else {
                hideTextField()
            }
            
            UIView.performWithoutAnimation {
                collectionView.reloadItems(at: [indexPath])
            }
            return
        }
        
        let tag = viewModel.sections[section].items[item]
        viewModel.toggleTagSelection(tag)
        
        UIView.performWithoutAnimation {
            collectionView.reloadItems(at: [indexPath])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = indexPath.section
        let item = indexPath.item
        
        if item == viewModel.sections[section].items.count {
            return CGSize(width: Constants.tagCellHeight, height: Constants.tagCellHeight)
        }
        
        let text = viewModel.sections[section].items[item]
        let width = text.size(withAttributes: [.font: Metrics.Fonts.tagFont]).width + Constants.tagCellPadding
        return CGSize(width: width, height: Constants.tagCellHeight)
    }
}

// MARK: - UITextFieldDelegate

extension AddNoteViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text?.trimmingCharacters(in: .whitespaces),
              !text.isEmpty,
              let section = viewModel.currentEditingSection else {
            hideTextField()
            return false
        }
        
        viewModel.addTag(text, to: section)
        
        collectionView.performBatchUpdates({
            let newIndex = IndexPath(item: viewModel.sections[section].items.count - 1, section: section)
            collectionView.insertItems(at: [newIndex])
        }) { [weak self] _ in
            self?.updateCollectionViewHeight()
            self?.reloadAddButton(for: section)
        }
        
        hideTextField()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        return newText.count <= Constants.tagTextFieldMaxLength
    }
}

// MARK: - Constants & Metrics

extension AddNoteViewController {
    
    enum Constants {
        static let cardHeight: CGFloat = 158
        static let tagCellHeight: CGFloat = 36
        static let tagCellPadding: CGFloat = 36
        static let tagTextFieldMaxWidth: CGFloat = 200
        static let tagTextFieldMaxLength: Int = 30
        static let sectionHeaderHeight: CGFloat = 40
        static let contentInsets: CGFloat = 24
        static let smallSpacing: CGFloat = 16
        static let animationDuration: TimeInterval = 0.3
    }
    
    enum Metrics {
        enum Colors {
            static let background = UIColor.black
            static let text = UIColor.white
            static let tagBackground = UIColor.darkGray
        }
        
        enum Fonts {
            static let cardDateFont = UIFont(name: "VelaSans-Regular", size: 14)!
            static let cardEmotionFont = UIFont(name: "VelaSans-Regular", size: 20)!
            static let cardEmotionHighlightFont = UIFont(name: "Gwen-Trial-Bold", size: 28)!
            static let tagFont = UIFont(name: "VelaSans-Regular", size: 14)!
        }
        
        enum Strings {
            static let feelText = LocalizedString.AddNote.feelText
            static let saveButtonTitle = LocalizedString.AddNote.saveText
        }
    }
}
