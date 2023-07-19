//
//  ScheduleViewController.swift
//  UNES
//
//  Created by João Santos Sena on 15/07/23.
//

import UIKit
import Combine

class ScheduleViewController: UIViewController {
    private let vm: ScheduleViewModel
    
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var scheduleBlockView: UICollectionView = {
        let layout = createLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentInsetAdjustmentBehavior = .always
        view.register(ScheduleBlockViewCell.self, forCellWithReuseIdentifier: ScheduleBlockViewCell.identifier)
        view.register(ScheduleDayViewCell.self, forCellWithReuseIdentifier: ScheduleDayViewCell.identifier)
        view.register(ScheduleEmptyViewCell.self, forCellWithReuseIdentifier: ScheduleEmptyViewCell.identifier)
        view.register(ScheduleTimeViewCell.self, forCellWithReuseIdentifier: ScheduleTimeViewCell.identifier)
        view.register(ScheduleLineLocationViewCell.self, forCellWithReuseIdentifier: ScheduleLineLocationViewCell.identifier)
        view.register(ScheduleLineDayViewCell.self, forCellWithReuseIdentifier: ScheduleLineDayViewCell.identifier)
        return view
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        return control
    }()
    
    init(vm: ScheduleViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        vm.registerListener()
        setupDataSource()
        setupViews()
        setupConstraints()
        fetchData()
        observe()
        NotificationManager.shared.requestPermission()
    }
    
    private func fetchData() {
        vm.fetchSchedule()
    }
    
    private func observe() {
        vm.$schedule
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.updateBlockSchedule(data)
            }
            .store(in: &cancellables)
        
        vm.$refreshing
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                if value {
                    self?.refreshControl.beginRefreshing()
                } else {
                    self?.refreshControl.endRefreshing()
                }
            }
            .store(in: &cancellables)
    }
    

    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { sectionIdx, env in
            let sec = self.vm.sections[sectionIdx]
            switch(sec) {
            case .block(_):
                var count = 1
                if self.vm.schedule.keys.count > 1 {
                    count = self.vm.schedule.keys.count
                }
                
                let calc = env.container.contentSize.width / CGFloat(count)
                let width = min(calc, 56)
                
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(width), heightDimension: .absolute(50))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: count)
                // I'll switch to iOS 16 pepela
                // let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: count)
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)
                return section
            case .list(_):
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                return section
            }
        }
    }
    
    private func updateBlockSchedule(_ data: [Int16: [ProcessedClassLocation]]) {
        scheduleBlockView.collectionViewLayout = createLayout()
        scheduleBlockView.reloadData()
    }
    
    private func setupDataSource() {
        scheduleBlockView.delegate = self
        scheduleBlockView.dataSource = self
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        title = "Horários"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(scheduleBlockView)
        scheduleBlockView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(startRefresh), for: .valueChanged)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scheduleBlockView.topAnchor.constraint(equalTo: view.topAnchor),
            scheduleBlockView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scheduleBlockView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scheduleBlockView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    @objc func startRefresh() {
        vm.refreshData()
    }
}

extension ScheduleViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return vm.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sec = vm.sections[section]
        switch(sec) {
        case .block(let items):
            return items.count
        case .list(let items):
            return items.count
        }
//        return vm.sections[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch vm.sections[indexPath.section] {
        case .block(let all):
            return buildBlock(collectionView, items: all, atIndex: indexPath)
        case .list(let items):
            return buildList(collectionView, items: items, atIndex: indexPath)
        }
    }
    
    private func buildBlock(_ collectionView: UICollectionView, items: [ProcessedClassLocation], atIndex indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.row]
        switch(item) {
        case .element(let item):
            return bindBlockCell(collectionView, item: item, atIndex: indexPath)
        case .empty:
            return bindEmptyCell(collectionView, atIndex: indexPath)
        case .day(let item):
            return bindDayCell(collectionView, item: item, atIndex: indexPath)
        case .time(let item):
            return bindTimeCell(collectionView, item: item, atIndex: indexPath)
        }
    }
    
    private func buildList(_ collectionView: UICollectionView, items: [ProcessedClassLocation], atIndex indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.row]
        switch(item) {
        case .element(let item):
            return bindLineLocationCell(collectionView, item: item, atIndex: indexPath)
        case .day(let item):
            return bindLineDayCell(collectionView, item: item, atIndex: indexPath)
        default:
            fatalError("Nothing here :)")
        }
    }
    
    private func bindLineLocationCell(_ collectionView: UICollectionView, item: ElementSpace, atIndex indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScheduleLineLocationViewCell.identifier, for: indexPath) as! ScheduleLineLocationViewCell
        cell.setup(item.location)
        return cell
    }
    
    private func bindLineDayCell(_ collectionView: UICollectionView, item: DaySpace, atIndex indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScheduleLineDayViewCell.identifier, for: indexPath) as! ScheduleLineDayViewCell
        cell.setup(item)
        return cell
    }
    
    private func bindBlockCell(_ collectionView: UICollectionView, item: ElementSpace, atIndex indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScheduleBlockViewCell.identifier, for: indexPath) as! ScheduleBlockViewCell
        let code = item.location.group?.clazz?.discipline?.code ?? ""
        let colorIndex = vm.disciplineColors[code] ?? 0
        let color = DisciplineColors.colors[colorIndex]
        cell.bind(item.location, withColor: color)
        return cell
    }
    
    private func bindDayCell(_ collectionView: UICollectionView, item: DaySpace, atIndex indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScheduleDayViewCell.identifier, for: indexPath) as! ScheduleDayViewCell
        cell.bind(item)
        return cell
    }
    
    private func bindEmptyCell(_ collectionView: UICollectionView, atIndex indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: ScheduleEmptyViewCell.identifier, for: indexPath) as! ScheduleEmptyViewCell
    }
    
    private func bindTimeCell(_ collectionView: UICollectionView, item: TimeSpace, atIndex indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScheduleTimeViewCell.identifier, for: indexPath) as! ScheduleTimeViewCell
        cell.bind(item)
        return cell
    }
}
