//
//  DetailViewController.swift
//  ImageSearch
//
//  Created by Roman Arriaga on 9/10/21.
//

import UIKit

class DetailViewController: UIViewController {

    var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    var heightWidthLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    var publishedLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    
    let viewModel: ItemViewModelType
    
    init(viewModel: ItemViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI() {
        self.view.backgroundColor = .white
        let stack = UIStackView(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 8
        
        stack.addArrangedSubview(self.imageView)
        stack.addArrangedSubview(self.titleLabel)
        stack.addArrangedSubview(self.heightWidthLabel)
        stack.addArrangedSubview(self.publishedLabel)
        
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        stack.addArrangedSubview(view)
        
        self.view.addSubview(stack)
        
        stack.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        stack.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        stack.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        stack.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        
        self.imageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.33).isActive = true
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        
        if let data = self.viewModel.imageData {
            imageView.image = UIImage(data: data)
        }
        self.titleLabel.text = "Title: \(self.viewModel.title)"
        self.heightWidthLabel.text = "H:: \(self.viewModel.height), W: \(self.viewModel.width)"
        self.publishedLabel.text = "Date: \(self.viewModel.published)"
    }

}
