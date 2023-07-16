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
        let layout = ColumnFlowLayout(minimumInteritemSpacing: 4, minimumLineSpacing: 4)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentInsetAdjustmentBehavior = .always
        view.register(ScheduleBlockViewCell.self, forCellWithReuseIdentifier: ScheduleBlockViewCell.identifier)
        view.register(ScheduleDayViewCell.self, forCellWithReuseIdentifier: ScheduleDayViewCell.identifier)
        view.register(ScheduleEmptyViewCell.self, forCellWithReuseIdentifier: ScheduleEmptyViewCell.identifier)
        view.register(ScheduleTimeViewCell.self, forCellWithReuseIdentifier: ScheduleTimeViewCell.identifier)
        return view
    }()
    
    init(vm: ScheduleViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupDataSource()
        setupViews()
        setupConstraints()
        fetchData()
        observe()
    }
    
    private func fetchData() {
        vm.fetchSchedule()
    }
    
    private func observe() {
        vm.$schedule
            .sink { [weak self] data in
                self?.updateBlockSchedule(data)
            }
            .store(in: &cancellables)
    }
    
    private func updateBlockSchedule(_ data: [Int16: [ProcessedClassLocation]]) {
        if let layout = scheduleBlockView.collectionViewLayout as? ColumnFlowLayout {
            layout.itemsPerRow = data.keys.count
        }
        scheduleBlockView.reloadData()
        
        let lines = vm.built.count / data.keys.count
        NSLayoutConstraint.activate([
            scheduleBlockView.heightAnchor.constraint(equalToConstant: CGFloat(72 * lines))
        ])
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
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scheduleBlockView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            scheduleBlockView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            scheduleBlockView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
        ])
    }
}

extension ScheduleViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.built.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let all = vm.built
        
        let item = all[indexPath.row]
        switch(item) {
        case is ElementSpace:
            return bindBlockCell(collectionView, item: item as! ElementSpace, atIndex: indexPath)
        case is EmptySpace:
            return bindEmptyCell(collectionView, atIndex: indexPath)
        case is DaySpace:
            return bindDayCell(collectionView, item: item as! DaySpace, atIndex: indexPath)
        case is TimeSpace:
            return bindTimeCell(collectionView, item: item as! TimeSpace, atIndex: indexPath)
        default:
            fatalError("Failed to render schedule item \(item)")
        }
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
