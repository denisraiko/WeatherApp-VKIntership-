//
//  Cell.swift
//  WeatherApp(VKIntership)
//
//  Created by Denis Raiko on 21.07.24.
//

import UIKit

class ForecastCollectionViewCell: UICollectionViewCell {
    
    var textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Helvetica Neue Bold", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [imageView, textLabel])
        view.axis = .vertical
        view.distribution = .fillEqually
        view.alignment = .center
        view.spacing = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        contentView.addSubview(stackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with weatherType: WeatherType) {
        textLabel.text = weatherType.displayName
        
        switch weatherType {
        case .clear:
            imageView.image = UIImage(named: "sunny")
        case .rain:
            imageView.image = UIImage(named: "rain")
        case .thunderstorm:
            imageView.image = UIImage(named: "thunderstorm")
        case .fog:
            imageView.image = UIImage(named: "fog")
        case .rainbow:
            imageView.image = UIImage(named: "rainbow")
        case .moon:
            imageView.image = UIImage(named: "moon")
        }
    }
}
