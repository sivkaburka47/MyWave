//
//  StatisticsViewController.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 22.02.2025.
//

import UIKit
import SnapKit

final class StatisticsViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let pageControl = VerticalPageControl()
    private let pageSpacing: CGFloat = 0
    
    private var peekThreshold: CGFloat {
        return scrollView.bounds.height * 0.138
    }
    private var pageHeights: [CGFloat] {
        guard scrollView.bounds.height > 0 else { return [] }
        
        let baseHeight = scrollView.bounds.height * 0.862
        return [
            baseHeight,
            byDayViewContentHeight,
            baseHeight,
            scrollView.bounds.height
        ]
    }
    
    private var byDayViewContentHeight: CGFloat {
        guard let byDayView = pages[1] as? ByDayView else { return 0 }
        return byDayView.contentHeight
    }

    private let pages: [UIView] = [
        GeneralView(),
        ByDayView(),
        FrequentView(),
        MoodInDayView()
    ]
    
    private let viewModel: StatisticsViewModel
    private var weeks: [String] = []
    private var selectedIndex: Int = 0
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .black
        return collectionView
    }()
    
    init(viewModel: StatisticsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        setupWeeks()
        setupCollectionView()
        setupStatisticsContainer()
        setupPageControl()
        updatePagesForSelectedWeek()
        DispatchQueue.main.async {
            self.scrollToSelectedWeek(animated: false)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for (index, page) in pages.enumerated() {
            page.snp.remakeConstraints { make in
                make.height.equalTo(pageHeights[index])
            }
        }
        
        view.layoutIfNeeded()
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = pages.count
        view.addSubview(pageControl)
        
        pageControl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(8)
        }
    }
    
    
    private func setupWeeks() {
        weeks = viewModel.getAvailableWeeks()
        selectedIndex = weeks.count - 1
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(WeekCell.self, forCellWithReuseIdentifier: WeekCell.identifier)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
        }
        
        let divider = UIView()
        divider.backgroundColor = UIColor(named: "statItemBG")
        view.addSubview(divider)
        
        divider.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }

    private func setupStatisticsContainer() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.backgroundColor = .clear
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(1)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        stackView.axis = .vertical
        stackView.spacing = pageSpacing
        scrollView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        for page in pages {
            stackView.addArrangedSubview(page)
        }
    }
    
    private func scrollToSelectedWeek(animated: Bool) {
        let indexPath = IndexPath(item: selectedIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
    }
    

    
    @objc private func pageControlChanged() {
            let newOffset = offsetForPage(pageControl.currentPage)
            scrollView.setContentOffset(CGPoint(x: 0, y: newOffset), animated: true)
        }
        
    private func offsetForPage(_ pageIndex: Int) -> CGFloat {
        (0..<pageIndex).reduce(0) { $0 + pageHeights[$1] + pageSpacing }
    }
    
    private func updatePagesForSelectedWeek() {
        let selectedWeek = weeks[selectedIndex]
        
        let weekStatistics = viewModel.getStatistics(for: selectedWeek)
        
        let allNotes = weekStatistics.notesByDate
        for page in pages {
            if let generalView = page as? GeneralView {
                generalView.update(with: allNotes)
            } else if let byDayView = page as? ByDayView {
                byDayView.update(with: (week: selectedWeek, notes: allNotes))
            } else if let frequentView = page as? FrequentView {
                frequentView.updateWeekLabel(with: selectedWeek)
            } else if let moodInDayView = page as? MoodInDayView {
                moodInDayView.updateWeekLabel(with: selectedWeek)
            }
        }
        scrollView.setContentOffset(.zero, animated: true)
        pageControl.currentPage = 0
    }
}

extension StatisticsViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let targetY = targetContentOffset.pointee.y
        let currentPage = findNearestPage(for: targetY)
        let pageStart = offsetForPage(currentPage)
        let pageHeight = pageHeights[currentPage]
        let scrollHeight = scrollView.bounds.height
        
        let maxAllowedOffset: CGFloat
        if pageHeight < scrollHeight {
            maxAllowedOffset = pageStart + pageHeight - scrollHeight
        } else {
            maxAllowedOffset = min(
                pageStart + pageHeight - (scrollHeight - peekThreshold) + pageSpacing,
                scrollView.contentSize.height - scrollHeight
            )
        }
        
        let minAllowedOffset = pageStart
        
        var finalOffset = targetY
        var newPage = currentPage
        
        if finalOffset <= 0 {
            newPage = 0
            finalOffset = 0
        } else if finalOffset < minAllowedOffset {
            newPage = max(currentPage - 1, 0)
            finalOffset = offsetForPage(newPage)
        } else if finalOffset > maxAllowedOffset {
            newPage = min(currentPage + 1, pages.count - 1)
            finalOffset = offsetForPage(newPage)
        }
        
        pageControl.currentPage = newPage
        targetContentOffset.pointee.y = finalOffset
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
            scrollView.contentOffset.y = finalOffset
        })
    }
    
    private func findNearestPage(for offset: CGFloat) -> Int {
        var accumulatedOffset: CGFloat = 0
        for (index, height) in pageHeights.enumerated() {
            let nextOffset = accumulatedOffset + height + (index < pageHeights.count - 1 ? pageSpacing : 0)
            if offset < nextOffset {
                return index
            }
            accumulatedOffset = nextOffset
        }
        return pageHeights.count - 1
    }
}

// MARK: - Collection View
extension StatisticsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weeks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeekCell.identifier, for: indexPath) as! WeekCell
        cell.configure(with: weeks[indexPath.item], isSelected: indexPath.item == selectedIndex)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        collectionView.reloadData()
        scrollToSelectedWeek(animated: true)
        updatePagesForSelectedWeek()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = weeks[indexPath.item]
        let font = UIFont(name: "VelaSans-Regular", size: 16)!
        
        let textSize = NSString(string: text).boundingRect(
            with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 48),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        )
        let textWidth = ceil(textSize.width) + 32
        
        let minWidth: CGFloat = 108
        return CGSize(width: max(textWidth, minWidth), height: 48)
    }
}

