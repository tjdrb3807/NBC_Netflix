//
//  MainViewController.swift
//  NBC_Netflix
//
//  Created by 전성규 on 12/26/24.
//

import UIKit
import SnapKit
import RxSwift

enum Section: Int, CaseIterable {
    case popularMovies
    case topRatedMovies
    case popularTVShows
    
    var title: String {
        switch self {
        case .popularMovies: return "이 시간 핫한 영화"
        case .topRatedMovies: return "가장 평점이 높은 영화"
        case .popularTVShows: return "곧 개방되는 영화"
        }
    }
}

final class MainViewController: UIViewController {
    private let viewModel = MainViewModel()
    private let disposeBag = DisposeBag()
    
    private var popularMovies = [Movie]()
    private var topRatedMovies = [Movie]()
    private var popularTVShows = [Movie]()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "NETFLIX"
        label.textColor = UIColor(red: 229/255, green: 9/255, blue: 20/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 28, weight: .heavy)
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .black
        
        collectionView.register(PosterCell.self, forCellWithReuseIdentifier: PosterCell.identifier)
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.identifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bind()
        self.configureUI()
    }
    
    private func bind() {
        viewModel.popularMovieSubject
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { vc, movies in
                vc.popularMovies = movies
                vc.collectionView.reloadData()
            }, onError: { error in
                print("ERROR: \(error)")
            }).disposed(by: disposeBag)
        
        viewModel.topRatedMovieSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] movies in
                self?.topRatedMovies = movies
                self?.collectionView.reloadData()
            }, onError: { error in
                print("에러 발생: \(error)")
            }).disposed(by: disposeBag)
        
        viewModel.popularTVShowSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] movies in
                self?.popularTVShows = movies
                self?.collectionView.reloadData()
            }, onError: { error in
                print("에러 발생: \(error)")
            }).disposed(by: disposeBag)
    }
    
    private func configureUI() {
        view.backgroundColor = .black
        
        [label, collectionView].forEach { view.addSubview($0) }
        
        label.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(10)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide.snp.horizontalEdges)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.25),
            heightDimension: .fractionalHeight(0.4))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group )
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 10
        section.contentInsets = .init(top: 10, leading: 10, bottom: 20, trailing: 10)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(44))
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        
        section.boundarySupplementaryItems = [header]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .popularMovies: return popularMovies.count
        case .topRatedMovies: return topRatedMovies.count
        case .popularTVShows: return popularTVShows.count
        case .none: return 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCell.identifier, for: indexPath) as? PosterCell else { return UICollectionViewCell() }
        
        switch Section(rawValue: indexPath.section) {
        case .popularMovies:
            cell.configureImage(with: popularMovies[indexPath.row])
        case .topRatedMovies:
            cell.configureImage(with: topRatedMovies[indexPath.row])
        case .popularTVShows:
            cell.configureImage(with: popularTVShows[indexPath.row])
        case .none:
            break
        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        // 헤더인 경우에만 구현.
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SectionHeaderView.identifier,
            for: indexPath
        ) as? SectionHeaderView else { return UICollectionReusableView() }
        
        let sectionType = Section.allCases[indexPath.section]
        headerView.configureTitle(with: sectionType.title)
        
        return headerView
    }
}
