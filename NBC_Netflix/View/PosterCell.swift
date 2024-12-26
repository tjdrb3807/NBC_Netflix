//
//  PosterCell.swift
//  NBC_Netflix
//
//  Created by 전성규 on 12/26/24.
//

import UIKit
import SnapKit

final class PosterCell: UICollectionViewCell {
    static let identifier = "PosterCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .darkGray
        imageView.contentMode = .scaleAspectFill
        
        imageView.layer.cornerRadius = 10.0
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
    
    private func configureUI() {
        contentView.addSubview(imageView)
        imageView.frame = contentView.bounds
    }
    
    func configureImage(with movie: Movie) {
        guard let posterPath = movie.posterPath else { return }
        let urlString = "https://image.tmdb.org/t/p/w500/\(posterPath).jpg"
        guard let url = URL(string: urlString) else { return }
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            }
        }
    }
}
