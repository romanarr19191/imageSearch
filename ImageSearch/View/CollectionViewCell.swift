//
//  CollectionViewCell.swift
//  ImageSearch
//
//  Created by Roman Arriaga on 9/10/21.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "\(CollectionViewCell.self)"
    
    var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var imageURL: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
    
    private func setUpUI() {
        self.contentView.addSubview(self.imageView)
        self.imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8).isActive = true
        self.imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8).isActive = true
        self.imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8).isActive = true
        self.imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8).isActive = true
    }
    
    func configure(viewModel: ListViewModelType, index: Int) {
        viewModel.image(for: index) { [weak self] data in
            DispatchQueue.main.async {
                if let data = data {
                    self?.imageView.image = UIImage(data: data)
                }
            }
        }
    
    }
    
}
