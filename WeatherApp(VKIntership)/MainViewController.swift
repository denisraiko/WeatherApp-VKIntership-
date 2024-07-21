//
//
//  WeatherApp(VKIntership)
//
//  Created by Denis Raiko on 21.07.24.
//

import UIKit
import AVKit
import AVFoundation

class MainViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var animationView = UIView()
    private var playerViewController = AVPlayerViewController()
    
    private let weatherTypes = WeatherType.allCases
    
    private lazy var forecastCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 50, height: 130)
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.layer.cornerRadius = 16
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ForecastCollectionViewCell.self, forCellWithReuseIdentifier: "ForecastCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        
        let randomWeather = weatherTypes.randomElement() ?? .clear
        displayWeatherAnimation(for: randomWeather)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupViews() {
        animationView = UIView()
        animationView.backgroundColor = .clear
        animationView.layer.cornerRadius = 16
        animationView.layer.masksToBounds = true
        
       
        view.addSubview(animationView)
        view.addSubview(forecastCollectionView)
    }
    
    private func setupConstraints() {
        animationView.translatesAutoresizingMaskIntoConstraints = false
        forecastCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: view.topAnchor),
            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            animationView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            forecastCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            forecastCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            forecastCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            forecastCollectionView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func displayWeatherAnimation(for weatherType: WeatherType) {
        playerViewController.view.removeFromSuperview()
        playerViewController.removeFromParent()
        
        let videoName: String
        switch weatherType {
        case .clear:
            videoName = "sunnyVideo"
        case .rain:
            videoName = "rainVideo"
        case .thunderstorm:
            videoName = "thunderstormVideo"
        case .fog:
            videoName = "fogVideo"
        case .rainbow:
            videoName = "rainbowVideo"
        case .moon:
            videoName = "moonVideo"
        }
        
        guard let path = Bundle.main.path(forResource: videoName, ofType: "mp4") else { return }
        
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        player.volume = 0
        
        NotificationCenter.default.addObserver(self, selector: #selector(restartVideo(_:)), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        
        let newPlayerViewController = AVPlayerViewController()
        newPlayerViewController.player = player
        newPlayerViewController.videoGravity = .resizeAspectFill
        newPlayerViewController.view.frame = animationView.bounds
        newPlayerViewController.view.alpha = 0
        
        animationView.addSubview(newPlayerViewController.view)
        
        UIView.transition(with: animationView, duration: 0.5, options: .transitionCrossDissolve, animations: {
            newPlayerViewController.view.alpha = 1
        }, completion: { _ in
            self.playerViewController.view.removeFromSuperview()
            self.playerViewController.removeFromParent()
            
            self.playerViewController = newPlayerViewController
            
            player.play()
        })
    }
    
    @objc private func restartVideo(_ notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: .zero, completionHandler: nil)
            playerViewController.player?.play()
        }
    }

    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForecastCollectionViewCell", for: indexPath) as? ForecastCollectionViewCell else {
            return UICollectionViewCell()
        }
        let weatherType = weatherTypes[indexPath.item]
        cell.textLabel.text = weatherType.displayName
        cell.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        cell.layer.cornerRadius = 16
        
        switch weatherType {
        case .clear:
            cell.imageView.image = UIImage(named: "sunny")
        case .rain:
            cell.imageView.image = UIImage(named: "rain")
        case .thunderstorm:
            cell.imageView.image = UIImage(named: "thunderstorm")
        case .fog:
            cell.imageView.image = UIImage(named: "fog")
        case .rainbow:
            cell.imageView.image = UIImage(named: "rainbow")
        case .moon:
            cell.imageView.image = UIImage(named: "moon")
        }
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let weatherType = weatherTypes[indexPath.item]
        displayWeatherAnimation(for: weatherType)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 70) 
    }
}
