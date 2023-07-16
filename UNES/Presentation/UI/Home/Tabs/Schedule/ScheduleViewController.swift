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
            scheduleBlockView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScheduleBlockViewCell.identifier, for: indexPath) as! ScheduleBlockViewCell
        if let item = item as? ElementSpace {
            cell.bind(item.location, withColor: .blue)
        }
        return cell
    }
}
