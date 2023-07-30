//
//  DisciplineMaterialsViewController.swift
//  UNES
//
//  Created by João Santos Sena on 29/07/23.
//

import UIKit
import Combine
import Firebase

class DisciplineMaterialsViewController: UIViewController {
    private let vm: DisciplineMaterialsViewModel
    
    enum Section: Int { case discipline }
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, ClassMaterialEntity>!
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var collection: UICollectionView = {
        let layout = createLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(DisciplineMaterialViewCell.self, forCellWithReuseIdentifier: DisciplineMaterialViewCell.identifier)
        view.delegate = self
        return view
    }()
    
    private var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Nenhum material foi postado"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(vm: DisciplineMaterialsViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        vm.loadMaterials()
        setupDataSource()
        setupViews()
        setupConstraints()
        observe()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        vm.registerListener()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        vm.onClose()
    }
    
    private func observe() {
        vm.$materials
            .receive(on: DispatchQueue.main)
            .sink { [weak self] materials in
                self?.reloadMaterials(materials)
            }
            .store(in: &cancellables)
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        title = "Materiais"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(collection)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collection.topAnchor.constraint(equalTo: view.topAnchor),
            collection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(70))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(70))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func setupDataSource() {
        dataSource = .init(collectionView: collection, cellProvider: { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DisciplineMaterialViewCell.identifier, for: indexPath) as! DisciplineMaterialViewCell
            cell.bind(item)
            return cell
        })
    }
    
    private func reloadMaterials(_ materials: [ClassMaterialEntity]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ClassMaterialEntity>()
        snapshot.appendSections([.discipline])
        snapshot.appendItems(materials, toSection: .discipline)
        dataSource.apply(snapshot, animatingDifferences: true)
        
        if materials.isEmpty {
            showEmptyMaterials()
        } else {
            removeEmptyMaterials()
        }
    }
    
    private func showEmptyMaterials() {
        collection.addSubview(emptyLabel)
        emptyLabel.centerXAnchor.constraint(equalTo: collection.centerXAnchor).isActive = true
        emptyLabel.centerYAnchor.constraint(equalTo: collection.safeAreaLayoutGuide.centerYAnchor).isActive = true
    }
    
    private func removeEmptyMaterials() {
        emptyLabel.removeFromSuperview()
    }
}

extension DisciplineMaterialsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = vm.materials[indexPath.row]
        if let link = item.link,
           let url = URL(string: link) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                return
            }
        }
        let error = NSError(domain: "Failed to open url", code: -1, userInfo: ["url": item.link ?? "nothing"])
        Crashlytics.crashlytics().record(error: error)
    }
}
