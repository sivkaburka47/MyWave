//
//  StatisticsViewController.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 22.02.2025.
//

import UIKit
import SnapKit

final class StatisticsViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: StatisticsViewModel
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let pageControl = VerticalPageControl()
    private let collectionView: UICollectionView
    
    private var pages: [UIView] = [
        GeneralView(),
        ByDayView(),
        FrequentView(),
        MoodInDayView()
    ]
    
    // MARK: - Initialization
    
    init(viewModel: StatisticsViewModel) {
        self.viewModel = viewModel
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
        updatePageHeights()
    }
}

// MARK: - UI Setup

extension StatisticsViewController {
    
    private func setupUI() {
        view.backgroundColor = Metrics.Colors.background
        configureWeeks()
        configureCollectionView()
        configureScrollView()
        configurePageControl()
        updatePagesForSelectedWeek()
    }
    
    private func configureWeeks() {
        viewModel.setupWeeks()
    }
    
    private func configureCollectionView() {
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = Metrics.Colors.background
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(WeekCell.self, forCellWithReuseIdentifier: WeekCell.identifier)
        view.addSubview(collectionView)
        
        let divider = UIView()
        divider.backgroundColor = Metrics.Colors.divider
        view.addSubview(divider)
        
        divider.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Constants.dividerHeight)
        }
    }
    
    private func configureScrollView() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.backgroundColor = .clear
        view.addSubview(scrollView)
        
        stackView.axis = .vertical
        stackView.spacing = Constants.pageSpacing
        scrollView.addSubview(stackView)
        
        pages.forEach { stackView.addArrangedSubview($0) }
    }
    
    private func configurePageControl() {
        pageControl.numberOfPages = pages.count
        view.addSubview(pageControl)
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Constants.weekSelectorHeight)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(Constants.dividerHeight)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView)
        }
        
        pageControl.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(Constants.smallSpacing / 2)
        }
    }
}

// MARK: - Page Management

extension StatisticsViewController {
    
    private var peekThreshold: CGFloat {
        scrollView.bounds.height * Constants.peekThresholdPercent
    }
    
    private var pageHeights: [CGFloat] {
        guard scrollView.bounds.height > 0 else { return Array(repeating: 0, count: pages.count) }
        let baseHeight = scrollView.bounds.height * Constants.scrollViewPercent
        return [
            baseHeight,
            max(byDayViewContentHeight, baseHeight),
            baseHeight,
            scrollView.bounds.height
        ]
    }
    
    private var byDayViewContentHeight: CGFloat {
        guard let byDayView = pages[1] as? ByDayView else { return 0 }
        return byDayView.contentHeight
    }
    
    private func updatePageHeights() {
        for (index, page) in pages.enumerated() {
            page.snp.remakeConstraints {
                $0.height.equalTo(pageHeights[index])
            }
        }
        view.layoutIfNeeded()
    }
    
    private func scrollToSelectedWeek(animated: Bool) {
        let indexPath = IndexPath(item: viewModel.selectedIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
    }
    
    private func updatePagesForSelectedWeek() {
        scrollView.setContentOffset(.zero, animated: true)
        pageControl.currentPage = 0
        
        let selectedWeek = viewModel.weeks[viewModel.selectedIndex]
        let weekStatistics = viewModel.getStatistics(for: selectedWeek)
        let moodEntries = viewModel.getMoodEntries(for: weekStatistics)
        let allNotes = weekStatistics.notesByDate
        let topEmotions = viewModel.getTopEmotions(for: weekStatistics)
        
        pages.forEach { page in
            switch page {
            case let generalView as GeneralView:
                generalView.update(with: allNotes)
            case let byDayView as ByDayView:
                byDayView.update(with: (week: selectedWeek, notes: allNotes))
            case let frequentView as FrequentView:
                frequentView.update(with: topEmotions)
            case let moodInDayView as MoodInDayView:
                moodInDayView.update(with: moodEntries)
            default:
                break
            }
        }
    }
    
    private func offsetForPage(_ pageIndex: Int) -> CGFloat {
        (0..<pageIndex).reduce(0) { $0 + pageHeights[$1] + Constants.pageSpacing }
    }
}

// MARK: - UIScrollViewDelegate

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
        
        let maxAllowedOffset: CGFloat =
            pageHeight < scrollHeight
            ? pageStart + pageHeight - scrollHeight
            : min(
                pageStart + pageHeight - (scrollHeight - peekThreshold) + Constants.pageSpacing,
                scrollView.contentSize.height - scrollHeight
            )
        
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
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut]) {
            scrollView.contentOffset.y = finalOffset
        }
    }
    
    private func findNearestPage(for offset: CGFloat) -> Int {
        var accumulatedOffset: CGFloat = 0
        for (index, height) in pageHeights.enumerated() {
            let nextOffset = accumulatedOffset + height + (index < pageHeights.count - 1 ? Constants.pageSpacing : 0)
            if offset < nextOffset {
                return index
            }
            accumulatedOffset = nextOffset
        }
        return pageHeights.count - 1
    }
}

// MARK: - UICollectionViewDelegate & DataSource

extension StatisticsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.weeks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeekCell.identifier, for: indexPath) as! WeekCell
        cell.configure(with: viewModel.weeks[indexPath.item], isSelected: indexPath.item == viewModel.selectedIndex)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectedIndex = indexPath.item
        collectionView.reloadData()
        scrollToSelectedWeek(animated: true)
        updatePagesForSelectedWeek()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = viewModel.weeks[indexPath.item]
        let textSize = text.size(withAttributes: [.font: Metrics.Fonts.weekFont])
        let textWidth = ceil(textSize.width) + Constants.weekCellPadding
        let minWidth: CGFloat = Constants.weekItemMinWidth
        return CGSize(width: max(textWidth, minWidth), height: Constants.weekSelectorHeight)
    }
}

// MARK: - Constants & Metrics

extension StatisticsViewController {
    
    enum Constants {
        static let contentInsets: CGFloat = 24
        static let smallSpacing: CGFloat = 16
        static let pageSpacing: CGFloat = 0
        static let weekSelectorHeight: CGFloat = 48
        static let weekCellPadding: CGFloat = 32
        static let dividerHeight: CGFloat = 1
        static let peekThresholdPercent: CGFloat = 0.138
        static let scrollViewPercent: CGFloat = 0.862
        static let weekItemMinWidth: CGFloat = 108
    }
    
    enum Metrics {
        enum Colors {
            static let background = UIColor.black
            static let divider = UIColor(named: "statItemBG")!
        }
        
        enum Fonts {
            static let weekFont = UIFont(name: "VelaSans-Regular", size: 16)!
        }
    }
}
