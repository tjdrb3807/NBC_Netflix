//
//  SectionHeaderView.swift
//  NBC_Netflix
//
//  Created by 전성규 on 12/26/24.
//

import UIKit
import SnapKit

final class SectionHeaderView: UICollectionReusableView {
    static let identifier = "SectionHeader"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureUI()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() { addSubview(titleLabel) }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(5.0)
            $0.horizontalEdges.equalToSuperview().inset(10.0)
        }
    }
    
    func configureTitle(with title: String) { titleLabel.text = title }
}
