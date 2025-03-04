//
//  OptionsViewController.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 22.02.2025.
//

import UIKit
import SnapKit

final class OptionsViewController: UIViewController {
    // MARK: - Properties
    
    private let viewModel: OptionsViewModel
    
    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()
    
    private let titleLabel = UILabel()
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    
    private let reminderStack = UIView()
    private let reminderIcon = UIImageView()
    private let reminderLabel = UILabel()
    private let reminderSwitch = UISwitch()
    
    private let faceIdStack = UIView()
    private let faceIdIcon = UIImageView()
    private let faceIdLabel = UILabel()
    private let faceIdSwitch = UISwitch()
    
    private let remindersContainer = UIStackView()
    
    private let addReminderButton = CustomLargeButton(style: .white)
    
    // MARK: - Initialization
    
    init(viewModel: OptionsViewModel) {
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
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

// MARK: - UI Setup

extension OptionsViewController {
    
    private func setupUI() {
        view.backgroundColor = Metrics.Colors.background
        
        setupScrollView()
        configureTitleLabel()
        configureProfile()
        configureReminderStack()
        configureRemindersContainer()
        configureAddReminderButton()
        configureFaceIdStack()
        
        contentStackView.setCustomSpacing(Constants.largeSpacing, after: titleLabel)
        contentStackView.setCustomSpacing(Constants.largeSpacing, after: nameLabel.superview!)
        contentStackView.setCustomSpacing(Constants.mediumSpacing, after: addReminderButton)
    }
    
    private func setupScrollView() {
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentStackView.axis = .vertical
        contentStackView.spacing = Constants.mediumSpacing
        contentStackView.alignment = .fill
        
        scrollView.addSubview(contentStackView)
        contentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Constants.contentInsets)
            $0.width.equalToSuperview().inset(Constants.contentInsets)
        }
    }
    
    private func configureTitleLabel() {
        titleLabel.text = Metrics.Strings.settingsTitle
        titleLabel.font = Metrics.Fonts.titleFont
        titleLabel.textColor = Metrics.Colors.text
        
        contentStackView.addArrangedSubview(titleLabel)
    }
    
    private func configureProfile() {
        profileImageView.image = Metrics.Images.profileImage
        profileImageView.layer.cornerRadius = Constants.profileImageSize / 2
        profileImageView.clipsToBounds = true
        
        nameLabel.text = Metrics.Strings.profileName
        nameLabel.textColor = Metrics.Colors.text
        nameLabel.font = Metrics.Fonts.nameFont
        nameLabel.textAlignment = .center
        
        let profileStack = UIStackView(arrangedSubviews: [profileImageView, nameLabel])
        profileStack.axis = .vertical
        profileStack.alignment = .center
        profileStack.spacing = Constants.smallSpacing
        
        contentStackView.addArrangedSubview(profileStack)
        
        profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(Constants.profileImageSize)
        }
    }
    
    private func configureReminderStack() {
        reminderStack.backgroundColor = .clear
        
        reminderIcon.image = Metrics.Images.reminderIcon
        reminderIcon.tintColor = Metrics.Colors.text
        reminderIcon.snp.makeConstraints {
            $0.width.height.equalTo(Constants.iconSize)
        }

        reminderLabel.text = Metrics.Strings.reminderText
        reminderLabel.textColor = Metrics.Colors.text
        reminderLabel.font = Metrics.Fonts.reminderFont

        reminderStack.addSubview(reminderIcon)
        reminderStack.addSubview(reminderLabel)
        reminderStack.addSubview(reminderSwitch)

        contentStackView.addArrangedSubview(reminderStack)

        reminderIcon.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.centerY.equalToSuperview()
        }

        reminderLabel.snp.makeConstraints {
            $0.left.equalTo(reminderIcon.snp.right).offset(Constants.smallSpacing)
            $0.centerY.equalToSuperview()
        }

        reminderSwitch.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.centerY.equalToSuperview()
        }

        reminderStack.snp.makeConstraints {
            $0.height.equalTo(Constants.reminderStackHeight)
        }
    }
    
    private func configureRemindersContainer() {
        remindersContainer.axis = .vertical
        remindersContainer.spacing = Constants.smallSpacing
        
        contentStackView.addArrangedSubview(remindersContainer)
    }
    
    private func configureAddReminderButton() {
        addReminderButton.setTitle(Metrics.Strings.addReminderButtonTitle, for: .normal)
        addReminderButton.addTarget(self, action: #selector(addReminder), for: .touchUpInside)
        
        contentStackView.addArrangedSubview(addReminderButton)
    }
    
    private func configureFaceIdStack() {
        faceIdStack.backgroundColor = .clear
        
        faceIdIcon.image = Metrics.Images.faceIdIcon
        faceIdIcon.tintColor = Metrics.Colors.text
        faceIdIcon.snp.makeConstraints {
            $0.width.height.equalTo(Constants.iconSize)
        }
        
        faceIdLabel.text = Metrics.Strings.faceIdText
        faceIdLabel.textColor = Metrics.Colors.text
        faceIdLabel.font = Metrics.Fonts.reminderFont
        
        faceIdStack.addSubview(faceIdIcon)
        faceIdStack.addSubview(faceIdLabel)
        faceIdStack.addSubview(faceIdSwitch)
        
        contentStackView.addArrangedSubview(faceIdStack)
        
        faceIdIcon.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        faceIdLabel.snp.makeConstraints {
            $0.left.equalTo(reminderIcon.snp.right).offset(Constants.smallSpacing)
            $0.centerY.equalToSuperview()
        }
        
        faceIdSwitch.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        faceIdStack.snp.makeConstraints {
            $0.height.equalTo(Constants.reminderStackHeight)
        }
    }
}

// MARK: - Actions

extension OptionsViewController {
    @objc private func addReminder() {
        let alert = UIAlertController(title: "\n\n\n\n\n\n\n\n\n",
                                  message: nil,
                                  preferredStyle: .actionSheet)
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        let alertHeight = Constants.pickerHeight + Constants.alertHeightOffset
        
        alert.view.addSubview(datePicker)
        
        datePicker.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.alertInsets)
            $0.leading.trailing.equalToSuperview().inset(Constants.alertInsets)
            $0.height.equalTo(Constants.pickerHeight)
        }
        
        let cancelAction = UIAlertAction(title: Metrics.Strings.cancelActionTitle, style: .cancel)
        let okAction = UIAlertAction(title: Metrics.Strings.addActionTitle, style: .default) { [weak self] _ in
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            let timeString = formatter.string(from: datePicker.date)
            self?.createReminder(with: timeString)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        alert.preferredContentSize = CGSize(
            width: UIScreen.main.bounds.width,
            height: alertHeight
        )
        
        present(alert, animated: true)
    }

    private func createReminder(with time: String) {
        let reminderView = ReminderView(time: time)
        
        reminderView.buttonAction = { [weak self, weak reminderView] in
            guard let view = reminderView else { return }
            self?.removeReminder(view)
        }
        
        remindersContainer.addArrangedSubview(reminderView)
    }
    
    private func removeReminder(_ reminderView: ReminderView) {
        reminderView.removeFromSuperview()
    }
    
    @objc private func deleteReminder(_ sender: UIButton) {
        if let reminderView = sender.superview {
            reminderView.removeFromSuperview()
        }
    }
}


// MARK: - Constants & Metrics

extension OptionsViewController {
    
    enum Constants {
        static let profileImageSize: CGFloat = 96
        static let iconSize: CGFloat = 24
        static let stackSpacing: CGFloat = 16
        static let customSpacing: CGFloat = 32
        static let reminderStackHeight: CGFloat = 32
        static let pickerHeight: CGFloat = 180
        static let alertHeightOffset: CGFloat = 120
        static let alertInsets: CGFloat = 20
        static let contentInsets: CGFloat = 24
        static let smallSpacing: CGFloat = 8
        static let mediumSpacing: CGFloat = 16
        static let largeSpacing: CGFloat = 32
    }
    
    enum Metrics {
        enum Colors {
            static let background = UIColor.black
            static let text = UIColor.white
        }
        
        enum Images {
            static let profileImage = UIImage(named: "avatarIcon")
            static let reminderIcon = UIImage(named: "alertIcon")
            static let faceIdIcon = UIImage(systemName: "faceid")
        }
        
        enum Fonts {
            static let titleFont = UIFont(name: "Gwen-Trial-Regular", size: 36)!
            static let nameFont = UIFont(name: "VelaSans-Bold", size: 24)!
            static let reminderFont = UIFont(name: "VelaSans-Medium", size: 16)!
        }
        
        enum Strings {
            static let settingsTitle = LocalizedString.Options.settingsTitle
            static let profileName = LocalizedString.Options.profileName
            static let reminderText = LocalizedString.Options.reminderText
            static let addReminderButtonTitle = LocalizedString.Options.addReminderButtonTitle
            static let faceIdText = LocalizedString.Options.faceIdText
            static let cancelActionTitle = LocalizedString.Options.cancel
            static let addActionTitle = LocalizedString.Options.add
        }
    }
}
