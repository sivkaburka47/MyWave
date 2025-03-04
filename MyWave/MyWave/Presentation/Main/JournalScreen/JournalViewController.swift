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
    private let progressView: CircularProgressView
    private let centerStack = UIStackView()
    private let centerButton = UIButton(type: .system)
    private let addNoteLabel = UILabel()
    private let mainVerticalStack = UIStackView()
    
    // MARK: - Initialization
    
    init(viewModel: JournalViewModel) {
        self.viewModel = viewModel
        self.progressView = CircularProgressView()
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
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

// MARK: - UI Setup

extension JournalViewController {
    
    private func setupUI() {
        view.backgroundColor = Metrics.Colors.background
        setupScrollView()
        configureStatsStackView()
        configureTitleLabel()
        configureProgressView()
        configureCenterStack()
        configureMainVerticalStack()
        addStatItems()
        addEntries()
        addDemoCards()
    }
    
    private func setupScrollView() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
    }
    
    private func configureStatsStackView() {
        statsStackView.axis = .horizontal
        statsStackView.spacing = Constants.smallSpacing
        contentView.addSubview(statsStackView)
    }
    
    private func configureTitleLabel() {
        titleLabel.text = Metrics.Strings.titleText
        titleLabel.font = Metrics.Fonts.titleFont
        titleLabel.textColor = Metrics.Colors.text
        titleLabel.numberOfLines = 2
        contentView.addSubview(titleLabel)
    }
    
    private func configureProgressView() {
        contentView.addSubview(progressView)
    }
    
    private func configureCenterStack() {
        let config = UIImage.SymbolConfiguration(pointSize: 48, weight: .thin)
        let image = UIImage(systemName: "plus.circle.fill", withConfiguration: config)
        
        centerButton.setImage(image, for: .normal)
        centerButton.tintColor = Metrics.Colors.text
        centerButton.backgroundColor = Metrics.Colors.background
        centerButton.layer.cornerRadius = Constants.centerButtonSize / 2
        centerButton.clipsToBounds = true
        centerButton.addTarget(self, action: #selector(centerButtonTapped), for: .touchUpInside)
        
        addNoteLabel.text = Metrics.Strings.addNoteText
        addNoteLabel.font = Metrics.Fonts.noteFont
        addNoteLabel.textColor = Metrics.Colors.text
        
        centerStack.axis = .vertical
        centerStack.spacing = Constants.smallSpacing
        centerStack.alignment = .center
        centerStack.addArrangedSubview(centerButton)
        centerStack.addArrangedSubview(addNoteLabel)
        contentView.addSubview(centerStack)
    }
    
    private func configureMainVerticalStack() {
        mainVerticalStack.axis = .vertical
        mainVerticalStack.spacing = Constants.largeSpacing * 2
        contentView.addSubview(mainVerticalStack)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.width.equalToSuperview()
        }
        
        statsStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Constants.mediumSpacing)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(Constants.statItemHeight)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(statsStackView.snp.bottom).offset(Constants.largeSpacing)
            $0.leading.trailing.equalToSuperview().inset(Constants.contentInsets)
        }
        
        progressView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.largeSpacing)
            $0.leading.trailing.equalToSuperview().inset(Constants.contentInsets)
            $0.height.equalTo(Constants.progressViewHeight)
        }
        
        centerStack.snp.makeConstraints {
            $0.center.equalTo(progressView)
        }
        
        centerButton.snp.makeConstraints {
            $0.width.height.equalTo(Constants.centerButtonSize)
        }
        
        mainVerticalStack.snp.makeConstraints {
            $0.top.equalTo(progressView.snp.bottom).offset(Constants.largeSpacing)
            $0.leading.trailing.equalToSuperview().inset(Constants.contentInsets)
            $0.bottom.equalToSuperview().offset(-Constants.contentInsets)
        }
    }
}

// MARK: - Today Entries

extension JournalViewController {
    
    private func addEntries() {
        progressView.update(with: viewModel.getTodayEntries())
    }
}

// MARK: - Stat Items

extension JournalViewController {
    
    private func addStatItems() {
        let statsItems = [
            StatItem(title: nil, value: viewModel.entriesCountString()),
            StatItem(title: Metrics.Strings.perDayText, value: viewModel.minEntriesCountString()),
            StatItem(title: Metrics.Strings.seriesText, value: viewModel.seriesDurationString())
        ]
        statsItems.forEach { addStatItem($0) }
    }
    
    private func addStatItem(_ item: StatItem) {
        let itemView = UIView()
        itemView.backgroundColor = Metrics.Colors.statItemBackground
        itemView.layer.cornerRadius = Constants.statItemCornerRadius
        
        let stack = UIStackView()
        stack.spacing = Constants.smallSpacing / 2
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        
        if let title = item.title {
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.textColor = Metrics.Colors.text
            titleLabel.font = Metrics.Fonts.statTitleFont
            stack.addArrangedSubview(titleLabel)
        }
        
        let valueLabel = UILabel()
        valueLabel.text = item.value
        valueLabel.textColor = Metrics.Colors.text
        valueLabel.font = Metrics.Fonts.statValueFont
        stack.addArrangedSubview(valueLabel)
        
        itemView.addSubview(stack)
        stack.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        statsStackView.addArrangedSubview(itemView)
    }
}

// MARK: - Demo Cards

extension JournalViewController {
    
    private func addDemoCards() {
        let demoEntries = viewModel.demoEntries
        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.spacing = Constants.smallSpacing
        
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
                dayStack?.spacing = Constants.smallSpacing / 2
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
        emotionLabel.attributedText = emotionText
        emotionLabel.numberOfLines = 2
        
        card.addSubview(dateLabel)
        card.addSubview(emotionLabel)
        
        dateLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(Constants.mediumSpacing)
            $0.trailing.lessThanOrEqualTo(card.imageView.snp.leading).offset(-Constants.mediumSpacing)
        }
        
        emotionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(Constants.mediumSpacing)
            $0.bottom.lessThanOrEqualToSuperview().inset(Constants.mediumSpacing)
        }
        
        card.snp.makeConstraints {
            $0.height.equalTo(Constants.cardHeight)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardTapped))
        card.addGestureRecognizer(tapGesture)
        card.isUserInteractionEnabled = true
        
        return card
    }
}

// MARK: - Actions

extension JournalViewController {
    
    @objc private func centerButtonTapped() {
        viewModel.startAddNoteFlow()
    }
    
    @objc private func cardTapped(_ gesture: UITapGestureRecognizer) {
        viewModel.editNote()
    }
}

// MARK: - Constants & Metrics

extension JournalViewController {
    
    enum Constants {
        static let contentInsets: CGFloat = 24
        static let smallSpacing: CGFloat = 8
        static let mediumSpacing: CGFloat = 16
        static let largeSpacing: CGFloat = 32
        static let statItemHeight: CGFloat = 32
        static let statItemCornerRadius: CGFloat = 16
        static let progressViewHeight: CGFloat = 364
        static let centerButtonSize: CGFloat = 64
        static let cardHeight: CGFloat = 158
    }
    
    enum Metrics {
        enum Colors {
            static let background = UIColor.black
            static let text = UIColor.white
            static let statItemBackground = UIColor(named: "statItemBG")
        }
        
        enum Fonts {
            static let titleFont = UIFont(name: "Gwen-Trial-Regular", size: 36)!
            static let noteFont = UIFont(name: "VelaSans-Medium", size: 16)!
            static let statTitleFont = UIFont(name: "VelaSans-Regular", size: 14)!
            static let statValueFont = UIFont(name: "VelaSans-Bold", size: 14)!
            static let cardDateFont = UIFont(name: "VelaSans-Regular", size: 14)!
            static let cardEmotionFont = UIFont(name: "VelaSans-Regular", size: 20)!
            static let cardEmotionHighlightFont = UIFont(name: "Gwen-Trial-Bold", size: 28)!
        }
        
        enum Strings {
            static let titleText = LocalizedString.Journal.titleText
            static let addNoteText = LocalizedString.Journal.addNoteText
            static let perDayText = LocalizedString.Journal.perDayText
            static let seriesText = LocalizedString.Journal.seriesText
            static let feelText = LocalizedString.Journal.feelText
        }
    }
}

// MARK: - Typealias

typealias StatItem = (title: String?, value: String)
