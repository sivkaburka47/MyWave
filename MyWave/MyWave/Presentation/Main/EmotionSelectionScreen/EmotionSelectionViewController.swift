//
//  EmotionSelectionViewController.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 22.02.2025.
//

import UIKit
import SnapKit

final class EmotionSelectionViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: EmotionSelectionViewModel
    
    private let container = UIView()
    private var centerXConstraint: Constraint?
    private var centerYConstraint: Constraint?
    private var currentOffset: CGPoint = .zero
    
    private var emotionView: EmotionSelectionView!
    private var allCircles = [UIView]()
    private var selectedCircle: UIView?
    private var originalFrames = [UIView: CGRect]()
    private var currentClosestCircle: UIView?
    private var isAutoSelecting = false
    
    // MARK: - Initialization
    
    init(viewModel: EmotionSelectionViewModel) {
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
}

// MARK: - UI Setup

extension EmotionSelectionViewController {
    
    private func setupUI() {
        view.backgroundColor = Metrics.Colors.background
        configureContainer()
        configureEmotionGroups()
        configureEmotionView()
        view.clipsToBounds = true
    }
    
    private func configureContainer() {
        container.backgroundColor = .clear
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        container.addGestureRecognizer(panGesture)
        view.addSubview(container)
    }
    
    private func configureEmotionGroups() {
        let emotions = viewModel.emotions
        let redGroup = createColorGroup(with: Array(emotions[0..<4]))
        redGroup.frame = CGRect(x: 0, y: 0, width: Constants.groupSize, height: Constants.groupSize)
        
        let yellowGroup = createColorGroup(with: Array(emotions[4..<8]))
        yellowGroup.frame = CGRect(x: Constants.groupSize + Constants.spacing, y: 0, width: Constants.groupSize, height: Constants.groupSize)
        
        let blueGroup = createColorGroup(with: Array(emotions[8..<12]))
        blueGroup.frame = CGRect(x: 0, y: Constants.groupSize + Constants.spacing, width: Constants.groupSize, height: Constants.groupSize)
        
        let greenGroup = createColorGroup(with: Array(emotions[12..<16]))
        greenGroup.frame = CGRect(x: Constants.groupSize + Constants.spacing, y: Constants.groupSize + Constants.spacing, width: Constants.groupSize, height: Constants.groupSize)
        
        [redGroup, yellowGroup, blueGroup, greenGroup].forEach {
            container.addSubview($0)
            allCircles.append(contentsOf: $0.subviews)
        }
    }
    
    private func configureEmotionView() {
        emotionView = EmotionSelectionView(
            state: .inactive,
            emotion: nil,
            advice: nil
        ) { [weak self] in
            self?.nextTapped()
        }
        view.addSubview(emotionView)
    }
    
    private func setupConstraints() {
        container.snp.makeConstraints {
            self.centerXConstraint = $0.centerX.equalToSuperview().constraint
            self.centerYConstraint = $0.centerY.equalToSuperview().constraint
            $0.width.equalTo(Constants.groupSize * 2 + Constants.spacing)
            $0.height.equalTo(Constants.groupSize * 2 + Constants.spacing)
        }
        
        emotionView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-Constants.contentInsets)
            $0.left.right.equalToSuperview().inset(Constants.contentInsets)
        }
    }
}

// MARK: - Emotion Group Creation

extension EmotionSelectionViewController {
    
    private func createColorGroup(with emotions: [(String, UIColor)]) -> UIView {
        let groupContainer = UIView()
        
        for (index, emotion) in emotions.enumerated() {
            let row = index / 2
            let column = index % 2
            
            let circle = UIView()
            circle.backgroundColor = emotion.1
            circle.layer.cornerRadius = Constants.circleSize / 2
            circle.isUserInteractionEnabled = true
            circle.tag = row * 10 + column
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(circleTapped(_:)))
            circle.addGestureRecognizer(tap)
            
            groupContainer.addSubview(circle)
            circle.snp.makeConstraints {
                $0.size.equalTo(Constants.circleSize)
                $0.leading.equalToSuperview().offset(CGFloat(column) * (Constants.circleSize + Constants.spacing))
                $0.top.equalToSuperview().offset(CGFloat(row) * (Constants.circleSize + Constants.spacing))
            }
            
            let label = UILabel()
            label.text = emotion.0
            label.font = Metrics.Fonts.circleSmallFont
            label.textColor = Metrics.Colors.circleText
            label.textAlignment = .center
            label.numberOfLines = 0
            circle.addSubview(label)
            
            label.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.leading.trailing.equalToSuperview().inset(Constants.smallSpacing)
            }
        }
        return groupContainer
    }
}

// MARK: - Selection Handling

extension EmotionSelectionViewController {
    
    private func animateSelection(for circle: UIView) {
        view.layoutIfNeeded()
        resetSelection(animated: false)
        
        selectedCircle = circle
        allCircles.forEach { originalFrames[$0] = $0.frame }
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: [.curveEaseInOut, .beginFromCurrentState]
        ) {
            circle.snp.updateConstraints {
                $0.width.height.equalTo(Constants.selectedCircleSize)
                $0.leading.equalToSuperview().offset(circle.frame.origin.x - Constants.selectionOffset)
                $0.top.equalToSuperview().offset(circle.frame.origin.y - Constants.selectionOffset)
            }
            
            self.shiftNeighbors(for: circle)
            circle.superview?.layoutIfNeeded()
            circle.layer.cornerRadius = Constants.selectedCircleSize / 2
            
            if let label = circle.subviews.first(where: { $0 is UILabel }) as? UILabel {
                label.font = Metrics.Fonts.circleLargeFont
            }
        }
        
        if let label = circle.subviews.first(where: { $0 is UILabel }) as? UILabel,
           let color = circle.backgroundColor {
            emotionView.configure(
                state: .active,
                emotion: label.text,
                advice: Metrics.Strings.defaultAdvice,
                color: color
            )
        }
    }
    
    private func shiftNeighbors(for circle: UIView) {
        guard let container = circle.superview?.superview else { return }
        
        let selectedGlobalFrame = circle.superview!.convert(circle.frame, to: container)
        let selectedCenter = CGPoint(x: selectedGlobalFrame.midX, y: selectedGlobalFrame.midY)
        
        for other in allCircles where other != circle {
            guard let otherSuperview = other.superview else { continue }
            
            let otherGlobalFrame = otherSuperview.convert(other.frame, to: container)
            let otherCenter = CGPoint(x: otherGlobalFrame.midX, y: otherGlobalFrame.midY)
            
            var dx: CGFloat = 0
            var dy: CGFloat = 0
            
            if abs(otherCenter.y - selectedCenter.y) < 1.0 {
                dx = otherCenter.x > selectedCenter.x ? Constants.shiftOffset : -Constants.shiftOffset
            }
            
            if abs(otherCenter.x - selectedCenter.x) < 1.0 {
                dy = otherCenter.y > selectedCenter.y ? Constants.shiftOffset : -Constants.shiftOffset
            }
            
            if let original = originalFrames[other] {
                let newX = original.origin.x + dx
                let newY = original.origin.y + dy
                
                other.snp.updateConstraints {
                    $0.leading.equalToSuperview().offset(newX)
                    $0.top.equalToSuperview().offset(newY)
                }
            }
        }
    }
    
    private func resetSelection(animated: Bool = true) {
        guard selectedCircle != nil else { return }
        
        let resetBlock = {
            for circle in self.allCircles {
                if let original = self.originalFrames[circle] {
                    circle.snp.updateConstraints {
                        $0.width.height.equalTo(Constants.circleSize)
                        $0.leading.equalToSuperview().offset(original.origin.x)
                        $0.top.equalToSuperview().offset(original.origin.y)
                    }
                    circle.layer.cornerRadius = Constants.circleSize / 2
                    
                    if let label = circle.subviews.first(where: { $0 is UILabel }) as? UILabel {
                        label.font = Metrics.Fonts.circleSmallFont
                    }
                }
            }
            self.view.layoutIfNeeded()
        }
        
        
        if animated {
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0.5,
                options: [.curveEaseOut, .beginFromCurrentState]
            ) {
                resetBlock()
            }
        } else {
            resetBlock()
        }
        
        selectedCircle = nil
        originalFrames.removeAll()
        currentClosestCircle = nil
        emotionView.configure(state: .inactive, emotion: nil, advice: nil)
    }
    
    private func updateClosestSelection() {
        guard !isAutoSelecting else { return }
        isAutoSelecting = true
        
        let center = view.center
        var closestCircle: UIView?
        var minDistance = CGFloat.greatestFiniteMagnitude
        
        for circle in allCircles {
            let circleFrame = circle.convert(circle.bounds, to: view)
            let circleCenter = CGPoint(x: circleFrame.midX, y: circleFrame.midY)
            let distance = hypot(center.x - circleCenter.x, center.y - circleCenter.y)
            
            if distance < minDistance {
                minDistance = distance
                closestCircle = circle
            }
        }
        
        if closestCircle != currentClosestCircle {
            if let current = currentClosestCircle {
                resetSelection(animated: false)
            }
            
            if let closest = closestCircle {
                animateSelection(for: closest)
                currentClosestCircle = closest
            }
        }
        
        isAutoSelecting = false
    }
}

// MARK: - Actions

extension EmotionSelectionViewController {
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
        case .began:
            currentOffset = CGPoint(
                x: centerXConstraint?.layoutConstraints.first?.constant ?? 0,
                y: centerYConstraint?.layoutConstraints.first?.constant ?? 0
            )
            resetSelection()
            currentClosestCircle = nil
            
        case .changed:
            let newX = currentOffset.x + translation.x
            let newY = currentOffset.y + translation.y
            
            centerXConstraint?.update(offset: newX)
            centerYConstraint?.update(offset: newY)
            updateClosestSelection()
            
        case .ended, .cancelled:
            currentOffset = CGPoint(
                x: centerXConstraint?.layoutConstraints.first?.constant ?? 0,
                y: centerYConstraint?.layoutConstraints.first?.constant ?? 0
            )
            
        default:
            break
        }
    }
    
    @objc private func circleTapped(_ sender: UITapGestureRecognizer) {
        guard let circle = sender.view else { return }
        
        if selectedCircle == circle {
            resetSelection()
            return
        }
        
        animateSelection(for: circle)
    }
    
    @objc private func nextTapped() {
        viewModel.navigateToAddNote()
    }
}

// MARK: - Constants & Metrics

extension EmotionSelectionViewController {
    
    enum Constants {
        static let circleSize: CGFloat = 112
        static let selectedCircleSize: CGFloat = 152
        static let spacing: CGFloat = 4
        static let groupSize: CGFloat = 228
        static let contentInsets: CGFloat = 24
        static let smallSpacing: CGFloat = 8
        static let selectionOffset: CGFloat = 20
        static let shiftOffset: CGFloat = 24
    }
    
    enum Metrics {
        enum Colors {
            static let background = UIColor.black
            static let circleText = UIColor.black
        }
        
        enum Fonts {
            static let circleSmallFont = UIFont(name: "Gwen-Trial-Black", size: 10)!
            static let circleLargeFont = UIFont(name: "Gwen-Trial-Black", size: 16)!
        }
        
        enum Strings {
            static let defaultAdvice = LocalizedString.EmotionSelection.feelAdvice
        }
    }
}
