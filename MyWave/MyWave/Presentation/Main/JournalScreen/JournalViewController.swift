//
//  JournalViewController.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 21.02.2025.
//

import UIKit
import SnapKit

final class JournalViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: JournalViewModel
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let statsStackView = UIStackView()
    private let titleLabel = UILabel()
    private let centerButton = UIButton(type: .system)
    private let centerStack = UIStackView()
    private let addNoteLabel = UILabel()
    private let mainVerticalStack = UIStackView()
    private var progressView: CircularProgressView!
    
    // MARK: - Initialization
    init(viewModel: JournalViewModel) {
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
        addDemoCards()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .black
        configureScrollView()
        configureStatsStackView()
        configureTitleLabel()
        configureProgressView()
        configureCenterButton()
        configureNoteLabel()
        configurCenterStack()
        configureMainVerticalStack()
        addStatItems()
    }
    
    private func configureScrollView() {
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
    }
    
    private func configureStatsStackView() {
        statsStackView.axis = .horizontal
        statsStackView.spacing = 8
        contentView.addSubview(statsStackView)
    }
    
    private func configureTitleLabel() {
        titleLabel.text = "Что вы сейчас чувствуете?"
        titleLabel.font = UIFont(name: "Gwen-Trial-Regular", size: 36)!
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 2
        contentView.addSubview(titleLabel)
    }
    
    private func configureProgressView() {
        progressView = CircularProgressView()
        contentView.addSubview(progressView)
    }
    
    private func configureCenterButton() {
        let config = UIImage.SymbolConfiguration(pointSize: 48, weight: .thin)
        let image = UIImage(systemName: "plus.circle.fill", withConfiguration: config)
        
        centerButton.setImage(image, for: .normal)
        
        centerButton.tintColor = .white
        centerButton.backgroundColor = .black
        centerButton.layer.cornerRadius = 32
        centerButton.clipsToBounds = true
        centerButton.addTarget(self, action: #selector(centerButtonTapped), for: .touchUpInside)
        
        contentView.addSubview(centerButton)
    }
    
    private func configureNoteLabel() {
        addNoteLabel.text = "Добавить запись"
        addNoteLabel.font = UIFont(name: "VelaSans-Medium", size: 16)!
        addNoteLabel.textColor = .white
        contentView.addSubview(addNoteLabel)
    }
    
    private func configurCenterStack() {
        centerStack.addArrangedSubview(centerButton)
        centerStack.addArrangedSubview(addNoteLabel)
        centerStack.axis = .vertical
        centerStack.spacing = 8
        centerStack.alignment = .center
        contentView.addSubview(centerStack)
    }
    
    private func configureMainVerticalStack() {
        mainVerticalStack.axis = .vertical
        mainVerticalStack.spacing = 58
        contentView.addSubview(mainVerticalStack)
    }
    
    private func addStatItems() {
        let statsItems = [
            StatItem(title: nil, value: viewModel.entriesCountString()),
            StatItem(title: "в день:", value: "2 записей"),
            StatItem(title: "серия:", value: "500 дней")
        ]
        statsItems.forEach { addStatItem($0) }
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }
        
        statsStackView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).inset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(32)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(statsStackView.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        progressView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(364)
        }
        
        mainVerticalStack.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(contentView).offset(-24)
        }
        
        centerStack.snp.makeConstraints { make in
            make.center.equalTo(progressView)
        }


    }
    
    // MARK: - Stat Items
    private func addStatItem(_ item: StatItem) {
        let view = UIView()
        view.backgroundColor = UIColor(named: "statItemBG")
        view.layer.cornerRadius = 16
        
        let stack = UIStackView()
        stack.spacing = 4
        
        if let title = item.title {
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.textColor = .white
            titleLabel.font = UIFont(name: "VelaSans-Regular", size: 14)
            stack.addArrangedSubview(titleLabel)
        }
        
        let valueLabel = UILabel()
        valueLabel.text = item.value
        valueLabel.textColor = .white
        valueLabel.font = UIFont(name: "VelaSans-Bold", size: 14)
        stack.addArrangedSubview(valueLabel)
        
        view.addSubview(stack)
        stack.snp.makeConstraints { $0.edges.equalToSuperview().inset(8) }
        
        statsStackView.addArrangedSubview(view)
    }
    
    // MARK: - Demo Cards
    private func addDemoCards() {
        let demoEntries = viewModel.demoEntries
        
        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.spacing = 8
        
        var currentDay: Date?
        var dayStack: UIStackView?
        
        demoEntries.forEach { entry in
            guard let date = entry["date"] as? Date,
                  let emotion = entry["emotion"] as? String,
                  let type = entry["type"] as? CardType else { return }
            
            let calendar = Calendar.current
            let day = calendar.startOfDay(for: date)
            
            if day != currentDay {
                dayStack = UIStackView()
                dayStack?.axis = .vertical
                dayStack?.spacing = 4
                verticalStack.addArrangedSubview(dayStack!)
                currentDay = day
            }
            
            let card = createCardView(date: date, emotion: emotion, type: type)
            dayStack?.addArrangedSubview(card)
        }
        
        mainVerticalStack.addArrangedSubview(verticalStack)
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
        emotionLabel.text = "Я чувствую\n\(emotion)"
        emotionLabel.numberOfLines = 2
        emotionLabel.textColor = .white
        emotionLabel.font = .systemFont(ofSize: 18, weight: .bold)
        
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
            $0.top.leading.equalToSuperview().inset(16)
            $0.trailing.lessThanOrEqualTo(card.imageView.snp.leading).offset(-16)
        }
        
        emotionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.bottom.lessThanOrEqualToSuperview().inset(16)
        }
        
        card.snp.makeConstraints {
            $0.height.equalTo(158)
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardTapped))
            card.addGestureRecognizer(tapGesture)
            card.isUserInteractionEnabled = true
        
        return card
    }
    
    // MARK: - Actions
    @objc private func centerButtonTapped() {
        viewModel.startAddNoteFlow()
    }
    
    @objc private func cardTapped(_ gesture: UITapGestureRecognizer) {
        viewModel.editNote()
    }
}



// MARK: - Typealias
typealias StatItem = (title: String?, value: String)
