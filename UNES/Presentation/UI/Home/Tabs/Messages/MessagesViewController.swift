//
//  MessagesViewController.swift
//  UNES
//
//  Created by João Santos Sena on 15/07/23.
//

import UIKit
import Combine

class MessagesViewControler: UIViewController {
    private let vm: MessagesViewModel
    
    enum Section: Int { case portal }
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, MessageEntity>!
    private var cancellables = Set<AnyCancellable>()
    
    lazy var collection: UICollectionView = {
        let layout = createLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(MessageViewCell.self, forCellWithReuseIdentifier: MessageViewCell.identifier)
        return view
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        return control
    }()
    
    init(vm: MessagesViewModel) {
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
        observe()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        vm.loadMessages()
    }
    
    private func observe() {
        vm.$messages
            .receive(on: DispatchQueue.main)
            .sink { [weak self] messages in
                self?.reloadMessages(messages)
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
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        title = "Mensagens"
        navigationController?.navigationBar.prefersLargeTitles = true
        collection.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(startRefresh), for: .valueChanged)
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(130))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(130))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func setupDataSource() {
        dataSource = .init(collectionView: collection, cellProvider: { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageViewCell.identifier, for: indexPath) as! MessageViewCell
            cell.bind(item)
            return cell
        })
    }
    
    private func reloadMessages(_ messages: [MessageEntity]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MessageEntity>()
        snapshot.appendSections([.portal])
        snapshot.appendItems(messages, toSection: .portal)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    @objc func startRefresh() {
        vm.refreshData()
    }
}


//import SwiftUI
//struct MessagesViewController_Previews : PreviewProvider {
//    static var previews: some View {
//        Container().edgesIgnoringSafeArea(.all)
//    }
//
//    struct Container: UIViewControllerRepresentable {
//        func makeUIViewController(context: Context) -> some UIViewController {
//            MessagesViewControler(vm: MessagesViewModel())
//        }
//
//        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
//        }
//    }
//}
