//
//  DisciplinesViewController.swift
//  UNES
//
//  Created by João Santos Sena on 15/07/23.
//

import UIKit
import Combine

class DisciplinesViewController: UIViewController {
    private let vm: DisciplinesViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(vm: DisciplinesViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentInsetAdjustmentBehavior = .always
        view.delegate = self
        view.dataSource = self
        view.register(DisciplineHeaderViewCell.self, forCellWithReuseIdentifier: DisciplineHeaderViewCell.identifier)
        view.register(DisciplineGroupNameViewCell.self, forCellWithReuseIdentifier: DisciplineGroupNameViewCell.identifier)
        view.register(DisciplineMeanViewCell.self, forCellWithReuseIdentifier: DisciplineMeanViewCell.identifier)
        view.register(DisciplineFinalsViewCell.self, forCellWithReuseIdentifier: DisciplineFinalsViewCell.identifier)
        view.register(DisciplineGradeViewCell.self, forCellWithReuseIdentifier: DisciplineGradeViewCell.identifier)
        view.register(DisciplineDividerViewCell.self, forCellWithReuseIdentifier: DisciplineDividerViewCell.identifier)
        view.register(EmptySemesterViewCell.self, forCellWithReuseIdentifier: EmptySemesterViewCell.identifier)
        return view
    }()
    
    override func viewDidLoad() {
        vm.fetchData()
        setupViews()
        setupConstraints()
        observe()
    }
    
    private func observe() {
        vm.$disciplinesMapped
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        title = "Disciplinas"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(42))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(30))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension DisciplinesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        vm.disciplinesMapped.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = vm.disciplinesMapped[indexPath.row]
        switch(item) {
        case .header(let clazz):
            return bindHeaderCell(collectionView, item: clazz, atIndex: indexPath)
        case .score(let clazz, let grade):
            return bindScoreCell(collectionView, item: clazz, grade: grade, atIndex: indexPath)
        case .final(let clazz):
            return bindFinalCell(collectionView, item: clazz, atIndex: indexPath)
        case .mean(let clazz):
            return bindMeanCell(collectionView, item: clazz, atIndex: indexPath)
        case .groupName(let clazz, let groupName):
            return bindGroupCell(collectionView, item: clazz, groupName: groupName, atIndex: indexPath)
        case .emptySemester(let semester):
            return bindEmptySemesterCell(collectionView, item: semester, atIndex: indexPath)
        case .divider:
            return bindDividerCell(collectionView, atIndex: indexPath)
        }
    }
    
    private func bindHeaderCell(_ collectionView: UICollectionView, item: ClassEntity, atIndex indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DisciplineHeaderViewCell.identifier, for: indexPath) as! DisciplineHeaderViewCell
        cell.setup(item)
        return cell
    }
    
    private func bindScoreCell(_ collectionView: UICollectionView, item: ClassEntity, grade: GradeEntity, atIndex indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DisciplineGradeViewCell.identifier, for: indexPath) as! DisciplineGradeViewCell
        cell.setup(item, grade: grade)
        return cell
    }
    
    private func bindFinalCell(_ collectionView: UICollectionView, item: ClassEntity, atIndex indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DisciplineFinalsViewCell.identifier, for: indexPath) as! DisciplineFinalsViewCell
        cell.setup(item)
        return cell
    }
    
    private func bindMeanCell(_ collectionView: UICollectionView, item: ClassEntity, atIndex indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DisciplineMeanViewCell.identifier, for: indexPath) as! DisciplineMeanViewCell
        cell.setup(item)
        return cell
    }
    
    private func bindGroupCell(_ collectionView: UICollectionView, item: ClassEntity, groupName: String, atIndex indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DisciplineGroupNameViewCell.identifier, for: indexPath) as! DisciplineGroupNameViewCell
        cell.setup(item, groupName: groupName)
        return cell
    }
    
    private func bindEmptySemesterCell(_ collectionView: UICollectionView, item: SemesterEntity, atIndex indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptySemesterViewCell.identifier, for: indexPath) as! EmptySemesterViewCell
        return cell
    }
    
    private func bindDividerCell(_ collectionView: UICollectionView, atIndex indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: DisciplineDividerViewCell.identifier, for: indexPath) as! DisciplineDividerViewCell
    }
}
