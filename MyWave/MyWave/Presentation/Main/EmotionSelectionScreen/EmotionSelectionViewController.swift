//
//  EmotionSelectionViewController.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 22.02.2025.
//

import UIKit
import SnapKit

final class EmotionSelectionViewController: UIViewController {
    private let circleSize: CGFloat = 112
    private let spacing: CGFloat = 4
    private let groupSize: CGFloat  = 228
    private let emotions = [
        ("Ярость", UIColor(named: "cusRed")!), ("Напряжение", UIColor(named: "cusRed")!),
        ("Зависть", UIColor(named: "cusRed")!), ("Беспокойство", UIColor(named: "cusRed")!),
        ("Возбуждение", UIColor(named: "cusYellow")!), ("Восторг", UIColor(named: "cusYellow")!),
        ("Уверенность", UIColor(named: "cusYellow")!), ("Счастье", UIColor(named: "cusYellow")!),
        ("Выгорание", UIColor(named: "cusBlue")!), ("Усталость", UIColor(named: "cusBlue")!),
        ("Депрессия", UIColor(named: "cusBlue")!), ("Апатия", UIColor(named: "cusBlue")!),
        ("Спокойствие", UIColor(named: "cusGreen")!), ("Удовлетворённость", UIColor(named: "cusGreen")!),
        ("Благодарность", UIColor(named: "cusGreen")!), ("Защищённость", UIColor(named: "cusGreen")!)
    ]
    
    private var selectedCircle: UIView?
    private var originalFrames = [UIView: CGRect]()
    private var allCircles = [UIView]()
    
    private let viewModel: EmotionSelectionViewModel
    
    private var emotionView: EmotionSelectionView!
    
    private var currentClosestCircle: UIView?
    private var isAutoSelecting = false
    
    init(viewModel: EmotionSelectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private var container: UIView!
    private var centerXConstraint: Constraint?
    private var centerYConstraint: Constraint?
    private var currentOffset: CGPoint = .zero

    private func setupUI() {
        view.backgroundColor = .black
        
        container = UIView()
        container.backgroundColor = .clear
        view.addSubview(container)
        
        container.snp.makeConstraints {
            self.centerXConstraint = $0.centerX.equalToSuperview().constraint
            self.centerYConstraint = $0.centerY.equalToSuperview().constraint
            $0.width.equalTo(groupSize * 2 + spacing)
            $0.height.equalTo(groupSize * 2 + spacing)
        }
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        container.addGestureRecognizer(panGesture)
        
        let redGroup = createColorGroup(with: Array(emotions[0..<4]))
        redGroup.frame = CGRect(x: 0, y: 0, width: groupSize, height: groupSize)
        
        let yellowGroup = createColorGroup(with: Array(emotions[4..<8]))
        yellowGroup.frame = CGRect(x: groupSize + spacing, y: 0, width: groupSize, height: groupSize)
        
        let blueGroup = createColorGroup(with: Array(emotions[8..<12]))
        blueGroup.frame = CGRect(x: 0, y: groupSize + spacing, width: groupSize, height: groupSize)
        
        let greenGroup = createColorGroup(with: Array(emotions[12..<16]))
        greenGroup.frame = CGRect(x: groupSize + spacing, y: groupSize + spacing, width: groupSize, height: groupSize)
        
        [redGroup, yellowGroup, blueGroup, greenGroup].forEach {
            container.addSubview($0)
            allCircles.append(contentsOf: $0.subviews)
        }
        
        emotionView = EmotionSelectionView(
            state: .inactive,
            emotion: nil,
            advice: nil
        ) {
            self.nextTapped()
        }
        
        view.addSubview(emotionView)
        
        emotionView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
            make.left.right.equalToSuperview().inset(24)
        }
        view.clipsToBounds = true
    }
    
    private func createColorGroup(with emotions: [(String, UIColor)]) -> UIView {
        let container = UIView()
        
        for (index, emotion) in emotions.enumerated() {
            let row = index / 2
            let column = index % 2
            
            let circle = UIView()
            circle.backgroundColor = emotion.1
            circle.layer.cornerRadius = 56
            circle.isUserInteractionEnabled = true
            circle.tag = row * 10 + column
            container.addSubview(circle)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(circleTapped(_:)))
            circle.addGestureRecognizer(tap)
            
            circle.snp.makeConstraints {
                $0.size.equalTo(circleSize)
                $0.leading.equalToSuperview().offset(CGFloat(column) * (circleSize + spacing))
                $0.top.equalToSuperview().offset(CGFloat(row) * (circleSize + spacing))
            }
            
            let label = UILabel()
            label.text = emotion.0
            label.font = UIFont(name: "Gwen-Trial-Black", size: 10)!
            label.textColor = .black
            label.textAlignment = .center
            label.numberOfLines = 0
            circle.addSubview(label)
            
            label.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.leading.trailing.equalToSuperview().inset(8)
            }
        }
        return container
    }
    
    private func animateSelection(for circle: UIView) {
        view.layoutIfNeeded()
        resetSelection(animated: false)
        
        selectedCircle = circle
        allCircles.forEach { originalFrames[$0] = $0.frame }
        
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.5,
                       options: [.curveEaseInOut, .beginFromCurrentState]) {
            circle.snp.updateConstraints {
                $0.width.height.equalTo(152)
                $0.leading.equalToSuperview().offset(circle.frame.origin.x - 20)
                $0.top.equalToSuperview().offset(circle.frame.origin.y - 20)
            }
            
            self.shiftNeighbors(for: circle)
            circle.superview?.layoutIfNeeded()
            circle.layer.cornerRadius = 76
            
            if let label = circle.subviews.first(where: { $0 is UILabel }) as? UILabel {
                label.font = UIFont(name: "Gwen-Trial-Black", size: 16)
            }
        }
        
        if let label = circle.subviews.first(where: { $0 is UILabel }) as? UILabel,
           let color = circle.backgroundColor {
            emotionView.configure(
                state: .active,
                emotion: label.text,
                advice: "ощущение, что необходимо отдохнуть",
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
                dx = otherCenter.x > selectedCenter.x ? 24 : -24
            }
            
            if abs(otherCenter.x - selectedCenter.x) < 1.0 {
                dy = otherCenter.y > selectedCenter.y ? 24 : -24
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
                        $0.width.height.equalTo(112)
                        $0.leading.equalToSuperview().offset(original.origin.x)
                        $0.top.equalToSuperview().offset(original.origin.y)
                    }
                    circle.layer.cornerRadius = 56
                    
                    if let label = circle.subviews.first(where: { $0 is UILabel }) as? UILabel {
                        label.font = UIFont(name: "Gwen-Trial-Black", size: 10)
                    }
                }
            }
            self.view.layoutIfNeeded()
        }
        
        if animated {
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0.5,
                           options: [.curveEaseOut, .beginFromCurrentState]) {
                resetBlock()
            }
        } else {
            resetBlock()
        }
        
        selectedCircle = nil
        originalFrames.removeAll()
        currentClosestCircle = nil
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
            emotionView.configure(state: .inactive, emotion: nil, advice: nil)
            return
        }
        
        animateSelection(for: circle)
    }
    
    @objc private func nextTapped() {
        viewModel.navigateToAddNote()
    }
}
