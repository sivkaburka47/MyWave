//
//  EmotionSelectionViewController.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 22.02.2025.
//

import UIKit
import SnapKit

final class EmotionSelectionViewController: UIViewController {
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
    private var isActiveState = false
    
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
            $0.width.equalTo(460)
            $0.height.equalTo(460)
        }
        
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        container.addGestureRecognizer(panGesture)
        
        let redGroup = createColorGroup(with: Array(emotions[0..<4]))
        redGroup.frame = CGRect(x: 0, y: 0, width: 230, height: 230)
        
        let yellowGroup = createColorGroup(with: Array(emotions[4..<8]))
        yellowGroup.frame = CGRect(x: 230, y: 0, width: 230, height: 230)
        
        let blueGroup = createColorGroup(with: Array(emotions[8..<12]))
        blueGroup.frame = CGRect(x: 0, y: 230, width: 230, height: 230)
        
        let greenGroup = createColorGroup(with: Array(emotions[12..<16]))
        greenGroup.frame = CGRect(x: 230, y: 230, width: 230, height: 230)
        
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
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
        case .began:
            currentOffset = CGPoint(
                x: centerXConstraint?.layoutConstraints.first?.constant ?? 0,
                y: centerYConstraint?.layoutConstraints.first?.constant ?? 0
            )
            
        case .changed:
            let newX = currentOffset.x + translation.x
            let newY = currentOffset.y + translation.y
            
            centerXConstraint?.update(offset: newX)
            centerYConstraint?.update(offset: newY)
            view.layoutIfNeeded()
            
        case .ended, .cancelled:
            currentOffset = CGPoint(
                x: centerXConstraint?.layoutConstraints.first?.constant ?? 0,
                y: centerYConstraint?.layoutConstraints.first?.constant ?? 0
            )
            
        default:
            break
        }
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
                $0.width.height.equalTo(112)
                $0.leading.equalToSuperview().offset(column * (112 + 4))
                $0.top.equalToSuperview().offset(row * (112 + 4))
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

    @objc private func circleTapped(_ sender: UITapGestureRecognizer) {
        guard let circle = sender.view else { return }
        
        if selectedCircle == circle {
            resetSelection()
            emotionView.configure(state: .inactive, emotion: nil, advice: nil)
            return
        }

        
        animateSelection(for: circle)
        
        if let label = circle.subviews.first(where: { $0 is UILabel }) as? UILabel {
            emotionView.configure(state: .active, emotion: label.text, advice: "ощущение, что необходимо отдохнуть")
        }
    }

    private func animateSelection(for circle: UIView) {
        resetSelection(animated: false)
        
        selectedCircle = circle
        
        allCircles.forEach { originalFrames[$0] = $0.frame }
        
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.5,
                       options: [.curveEaseInOut]) {
            circle.snp.updateConstraints {
                $0.width.height.equalTo(152)
                $0.leading.equalToSuperview().offset(circle.frame.origin.x - 20)
                $0.top.equalToSuperview().offset(circle.frame.origin.y - 20)
            }
            
            self.shiftNeighbors(for: circle)
            
            circle.superview?.layoutIfNeeded()
            circle.layer.cornerRadius = 76
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
                }
            }
            self.view.layoutIfNeeded()
        }
        
        if animated {
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0.5,
                           options: [.curveEaseOut]) {
                resetBlock()
            }
        } else {
            resetBlock()
        }
        
        selectedCircle = nil
        originalFrames.removeAll()
    }
    
    
    @objc private func nextTapped() {
        viewModel.navigateToAddNote()
    }
    
    @objc private func toggleState() {
        isActiveState.toggle()
        
        if isActiveState {
            emotionView.configure(
                state: .active,
                emotion: "Усталость",
                advice: "ощущение, что необходимо отдохнуть"
            )
        } else {
            emotionView.configure(
                state: .inactive,
                emotion: nil,
                advice: nil
            )
        }
    }
}


