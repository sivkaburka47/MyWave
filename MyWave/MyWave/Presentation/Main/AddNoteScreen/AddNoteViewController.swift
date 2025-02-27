//
//  AddNoteViewController.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 22.02.2025.
//

import UIKit
import SnapKit

final class AddNoteViewController: UIViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let cardHeight: CGFloat = 158
        static let tagCellHeight: CGFloat = 36
        static let tagCellPadding: CGFloat = 36
        static let tagTextFieldMaxWidth: CGFloat = 200
        static let tagTextFieldMaxLength: Int = 30
        static let sectionHeaderHeight: CGFloat = 40
        static let defaultInset: CGFloat = 24
        static let smallInset: CGFloat = 16
        static let animationDuration: TimeInterval = 0.3
    }
    
    private struct Section {
        let title: String
        var items: [String]
    }
    
    // MARK: - Properties
    private let viewModel: AddNoteViewModel
    private var sections: [Section] = [
        Section(title: "Чем вы занимались", items: ["Прием пищи", "Встреча с друзьями", "Тренировка", "Хобби", "Отдых", "Поездка"]),
        Section(title: "С кем вы были?", items: ["Один", "Друзья", "Семья", "Коллеги", "Партнер", "Питомцы"]),
        Section(title: "Где вы были?", items: ["Дом", "Работа", "Школа", "Транспорт", "Улица"])
    ]
    
    private var selectedTags = Set<String>()
    private var isAddingTag = false
    private var currentEditingSection: Int?
    private var newTagText = ""
    
    private var card = UIView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let saveNoteButton = CustomLargeButton(style: .white)
    private var collectionView: UICollectionView!
    private let newTagTextField = UITextField()
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .black
        setupScrollView()
        setupCard()
        setupSaveButton()
        setupCollectionView()
        setupTextField()
        updateCollectionViewHeight()
        setupKeyboardObservers()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(view.safeAreaLayoutGuide)
            $0.height.greaterThanOrEqualTo(view.safeAreaLayoutGuide).priority(.required)
        }
    }
    
    private func setupCard() {
        card = createCardView(
            date: viewModel.selectedDate,
            emotion: viewModel.selectedEmotion,
            type: viewModel.selectedCardType
        )
        contentView.addSubview(card)
        
        card.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.defaultInset)
            $0.leading.trailing.equalToSuperview().inset(Constants.defaultInset)
        }
    }
    
    private func setupCollectionView() {
        let layout = LeftAlignedFlowLayout()
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        layout.sectionInset = UIEdgeInsets(top: 0, left: Constants.defaultInset, bottom: Constants.smallInset, right: Constants.defaultInset)
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
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(card.snp.bottom).offset(Constants.defaultInset)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(saveNoteButton.snp.top).offset(-Constants.defaultInset).priority(.high)
            collectionViewHeightConstraint = $0.height.equalTo(0).priority(.medium).constraint
        }
    }
    
    private func setupSaveButton() {
        saveNoteButton.setTitle("Сохранить", for: .normal)
        saveNoteButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        contentView.addSubview(saveNoteButton)
        
        saveNoteButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Constants.defaultInset)
            $0.bottom.equalToSuperview().offset(-Constants.defaultInset)
        }
    }
    
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
        dateLabel.textColor = .white
        dateLabel.font = UIFont(name: "VelaSans-Regular", size: 14)!
        
        let emotionLabel = UILabel()
        emotionLabel.numberOfLines = 2
        emotionLabel.textColor = .white
        
        let emotionText = NSMutableAttributedString(string: "Я чувствую\n", attributes: [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "VelaSans-Regular", size: 20)!
        ])
        emotionText.append(NSAttributedString(string: emotion, attributes: [
            .foregroundColor: type.emotionTextColor,
            .font: UIFont(name: "Gwen-Trial-Bold", size: 28)!
        ]))
        emotionLabel.attributedText = emotionText
        
        card.addSubview(dateLabel)
        card.addSubview(emotionLabel)
        
        dateLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(Constants.smallInset)
            $0.trailing.lessThanOrEqualTo(card.imageView.snp.leading).offset(-Constants.smallInset)
        }
        
        emotionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(Constants.smallInset)
            $0.bottom.lessThanOrEqualToSuperview().inset(Constants.smallInset)
        }
        
        card.snp.makeConstraints {
            $0.height.equalTo(Constants.cardHeight)
        }

        return card
    }
    
    private func setupTextField() {
        newTagTextField.delegate = self
        newTagTextField.backgroundColor = .darkGray
        newTagTextField.textColor = .white
        newTagTextField.tintColor = .white
        newTagTextField.layer.cornerRadius = Constants.tagCellHeight / 2
        newTagTextField.font = UIFont(name: "VelaSans-Regular", size: 14)
        newTagTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.smallInset, height: 0))
        newTagTextField.leftViewMode = .always
        newTagTextField.returnKeyType = .done
        newTagTextField.isHidden = true
        view.addSubview(newTagTextField)
    }
    
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
    
    private func updateCollectionViewHeight() {
        collectionView.layoutIfNeeded()
        let height = collectionView.collectionViewLayout.collectionViewContentSize.height
        collectionViewHeightConstraint?.update(offset: height)
        
        self.view.layoutIfNeeded()
    }
    
    @objc private func doneTapped() {
        viewModel.completeFlow()
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }
        
        scrollView.snp.updateConstraints {
            $0.bottom.equalTo(view).offset(-keyboardFrame.height)
        }
        
        UIView.animate(withDuration: Constants.animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide() {
        scrollView.snp.updateConstraints {
            $0.bottom.equalTo(view)
        }
        
        UIView.animate(withDuration: Constants.animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension AddNoteViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].items.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        let item = indexPath.item
        
        if item == sections[section].items.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddTagCell.identifier, for: indexPath) as! AddTagCell
            cell.configure()
            return cell
        }
        
        let tag = sections[section].items[item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.identifier, for: indexPath) as! TagCell
        cell.configure(with: tag, isSelected: selectedTags.contains(tag))
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
        
        header.configure(title: sections[indexPath.section].title)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.section
        let item = indexPath.item
        
        if item == sections[section].items.count {
            currentEditingSection = section
            isAddingTag.toggle()
            
            if isAddingTag {
                showTextField(at: indexPath)
            } else {
                hideTextField()
            }
            
            UIView.performWithoutAnimation {
                collectionView.reloadItems(at: [indexPath])
            }
            return
        }
        
        let tag = sections[section].items[item]
        selectedTags = selectedTags.contains(tag)
            ? selectedTags.filter { $0 != tag }
            : selectedTags.union([tag])
        
        UIView.performWithoutAnimation {
            collectionView.reloadItems(at: [indexPath])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = indexPath.section
        let item = indexPath.item
        
        if item == sections[section].items.count {
            return CGSize(width: Constants.tagCellHeight, height: Constants.tagCellHeight)
        }
        
        let text = sections[section].items[item]
        let width = text.size(withAttributes: [.font: UIFont(name: "VelaSans-Regular", size: 14)!]).width + Constants.tagCellPadding
        return CGSize(width: width, height: Constants.tagCellHeight)
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
                width: min(Constants.tagTextFieldMaxWidth, self.collectionView.frame.width - cell.frame.origin.x - Constants.defaultInset),
                height: Constants.tagCellHeight
            )
        }
        
        newTagTextField.becomeFirstResponder()
    }
    
    private func hideTextField() {
        newTagTextField.resignFirstResponder()
        newTagTextField.isHidden = true
        currentEditingSection = nil
        isAddingTag.toggle()
    }
}

// MARK: - UITextFieldDelegate
extension AddNoteViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard
            let text = textField.text?.trimmingCharacters(in: .whitespaces),
            !text.isEmpty,
            let section = currentEditingSection
        else {
            hideTextField()
            return false
        }
        
        sections[section].items.append(text)
        selectedTags.insert(text)
        
        collectionView.performBatchUpdates({
            let newIndex = IndexPath(item: sections[section].items.count - 1, section: section)
            collectionView.insertItems(at: [newIndex])
        }) { [weak self] _ in
            self?.updateCollectionViewHeight()
            self?.reloadAddButton(for: section)
        }
        
        hideTextField()
        return true
    }
    
    private func reloadAddButton(for section: Int) {
        let addButtonIndex = IndexPath(item: sections[section].items.count, section: section)
        UIView.performWithoutAnimation {
            collectionView.reloadItems(at: [addButtonIndex])
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        return newText.count <= Constants.tagTextFieldMaxLength
    }
}
