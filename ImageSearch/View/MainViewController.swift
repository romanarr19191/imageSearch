//
//  MainViewController.swift
//  ImageSearch
//
//  Created by Roman Arriaga on 9/10/21.
//

import UIKit

class MainViewController: UIViewController {

    var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(frame: .zero)
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.color = .black
        return activity
    }()
    
    var searchBar: UISearchBar = {
        let bar = UISearchBar(frame: .zero)
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.placeholder = "Search Images"
        bar.heightAnchor.constraint(equalToConstant: 45).isActive = true
        return bar
    }()
    
    var collection: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseId)
        return collection
    }()
    
    let viewModel: ListViewModelType
    
    var imageQueryTask: DispatchWorkItem? {
        didSet {
            oldValue?.cancel()
            guard let task = self.imageQueryTask else { return }
            DispatchQueue.global().asyncAfter(deadline: .now() + 2, execute: task)
        }
    }
    
    init(viewModel: ListViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        
        self.viewModel.bind { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.collection.reloadData()
            }
        }

    }
    
    private func setUpUI() {
        self.title = "Image Search"
        self.view.backgroundColor = .white
        
        self.searchBar.delegate = self
        self.collection.dataSource = self
        self.collection.delegate = self
        
        let stack = UIStackView(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 8
        
        stack.addArrangedSubview(self.searchBar)
        stack.addArrangedSubview(self.collection)
        self.view.addSubview(stack)
        
        stack.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        stack.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        stack.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        stack.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    

}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseId, for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(viewModel: self.viewModel, index: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = self.viewModel.itemViewModel(for: indexPath.item) else { return }
        let detailVC = DetailViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collection.frame.width, height: self.collection.frame.height / 3)
    }

}

extension MainViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.activityIndicator.startAnimating()
        let task = DispatchWorkItem { [weak self] in
            self?.viewModel.getItems(query: searchText)
        }
        self.imageQueryTask = task
    }
    
}
