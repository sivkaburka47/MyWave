//
//  ByDayView.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 01.03.2025.
//

import UIKit
import SnapKit

final class ByDayView: UIView {
    var contentHeight: CGFloat {
        let titleHeight = titleScreen.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        let stackHeight = stackView.systemLayoutSizeFitting(
            UIView.layoutFittingCompressedSize
        ).height
        
        return titleHeight + stackHeight + 48
    }
    
    private let titleScreen = UILabel()
    private let stackView = UIStackView()
    private let weekdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    private let dayMonthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .black
        
        titleScreen.text = "Эмоции по дням недели"
        titleScreen.font = UIFont(name: "Gwen-Trial-Regular", size: 36)
        titleScreen.textColor = .white
        titleScreen.numberOfLines = 0
        
        addSubview(titleScreen)
        titleScreen.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        stackView.axis = .vertical
        stackView.spacing = 0
        addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(titleScreen.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }
    
    func update(with data: (week: String, notes: [Note])) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        
        guard
            !data.notes.isEmpty,
            let firstNoteDate = data.notes.first?.dateAdded,
            let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: firstNoteDate))
        else { return }
        
        let days = (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
        
        var maxDayLabelWidth: CGFloat = 0
        let tempLabel = UILabel()
        tempLabel.font = .systemFont(ofSize: 16, weight: .medium)
        
        for day in days {
            let formattedDate = dayMonthFormatter.string(from: day)
            tempLabel.text = "\(weekdayFormatter.string(from: day))\n\(formattedDate.split(separator: " ")[0]) \(formattedDate.split(separator: " ")[1].prefix(3))"
            maxDayLabelWidth = max(maxDayLabelWidth, tempLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).width)
        }
        
        for day in days {
            let notesForDay = data.notes.filter { calendar.isDate($0.dateAdded, inSameDayAs: day) }
            let cell = createDayCell(date: day, notes: notesForDay, maxDayLabelWidth: maxDayLabelWidth)
            stackView.addArrangedSubview(cell)
            
            let divider = UIView()
            divider.backgroundColor = UIColor(named: "statItemBG")
            divider.snp.makeConstraints {
                $0.height.equalTo(1)
            }
            stackView.addArrangedSubview(divider)
        }
        
        self.layoutIfNeeded()
    }

    private func createDayCell(date: Date, notes: [Note], maxDayLabelWidth: CGFloat) -> UIView {
        let cell = UIView()
        cell.backgroundColor = .clear
        
        let dayLabel = UILabel()
        dayLabel.font = .systemFont(ofSize: 12, weight: .regular)
        dayLabel.textColor = .white
        dayLabel.numberOfLines = 0
        let formattedDate = dayMonthFormatter.string(from: date)
        dayLabel.text = "\(weekdayFormatter.string(from: date).capitalized)\n\(formattedDate.split(separator: " ")[0]) \(formattedDate.split(separator: " ")[1].prefix(3))"
        
        let emotionsContainer = UIStackView()
        emotionsContainer.axis = .vertical
        emotionsContainer.spacing = 4
        
        let uniqueTitles = Set(notes.map { $0.title })
        for title in uniqueTitles {
            let emotionLabel = UILabel()
            emotionLabel.font = .systemFont(ofSize: 12, weight: .regular)
            emotionLabel.textColor = .lightGray
            emotionLabel.text = title
            emotionLabel.numberOfLines = 1
            emotionLabel.lineBreakMode = .byTruncatingTail
            emotionsContainer.addArrangedSubview(emotionLabel)
        }
        

        if uniqueTitles.isEmpty {
            let placeholder = UILabel()
            placeholder.font = .systemFont(ofSize: 12, weight: .regular)
            placeholder.textColor = .lightGray
            placeholder.text = " "
            emotionsContainer.addArrangedSubview(placeholder)
        }
        
        let iconsContainer = UIStackView()
        iconsContainer.axis = .vertical
        iconsContainer.spacing = 8
        iconsContainer.alignment = .trailing
        
        let uniqueIcons = Set(notes.isEmpty ? ["none"] : notes.map { $0.icon })
        var currentRow: UIStackView?
        
        for (index, icon) in uniqueIcons.enumerated() {
            if index % 3 == 0 {
                currentRow = UIStackView()
                currentRow?.axis = .horizontal
                currentRow?.spacing = 4
                currentRow?.distribution = .fill
                iconsContainer.addArrangedSubview(currentRow!)
            }
            
            let iconView = UIImageView(image: UIImage(named: icon))
            iconView.contentMode = .scaleAspectFit
            iconView.snp.makeConstraints { $0.size.equalTo(40) }
            currentRow?.addArrangedSubview(iconView)
        }
        
        cell.addSubview(dayLabel)
        cell.addSubview(emotionsContainer)
        cell.addSubview(iconsContainer)
        
        dayLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview()
            $0.width.equalTo(maxDayLabelWidth)
        }
        
        emotionsContainer.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalTo(dayLabel.snp.trailing).offset(12)
            $0.trailing.lessThanOrEqualTo(iconsContainer.snp.leading).offset(-12)
        }
        
        iconsContainer.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview()
        }
        
        cell.snp.makeConstraints {
            $0.bottom.greaterThanOrEqualTo(emotionsContainer.snp.bottom).offset(12)
            $0.bottom.greaterThanOrEqualTo(iconsContainer.snp.bottom).offset(12)
        }
        
        return cell
    }

}

