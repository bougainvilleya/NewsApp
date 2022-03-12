//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Leyla Nyssanbayeva on 09.03.2022.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    private var news = News()
    
    lazy var image: UIImageView = {
        return UIImageView(image: UIImage(named: "default-image")?.cropImage(width: 140, height: 100))
    }()
    
    lazy var sourceName: UILabel = {
        let label = UILabel()
        label.text = "..."
        label.textColor = Colors.darkEmerald
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 1
        return label
    }()
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.text = "..."
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 3
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 8
        
        let items = [title, sourceName, image]
        items.forEach { item in contentView.addSubview(item) }
        
        setViews()
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setViews() {
        image.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.width.equalTo(140)
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        sourceName.snp.makeConstraints { make in
            
            make.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(24)
            make.leading.equalTo(image.snp.trailing).offset(16)
        }
        
        title.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.top.equalTo(sourceName.snp.bottom).offset(6)
            make.leading.equalTo(image.snp.trailing).offset(16)
        }
        
    }
    
    func configure(with viewModel: News) {
        news = viewModel
        sourceName.text = viewModel.source?.name
        title.text = viewModel.title
        
        let defaultImage = "https://zonerantivirus.com/wp-content/uploads/default-image.png"
        image.load(url: URL(string: viewModel.urlToImage ?? defaultImage)!)
    }
    
}
