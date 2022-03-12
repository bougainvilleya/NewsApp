//
//  TopHeadlinesViewController.swift
//  NewsApp
//
//  Created by Leyla Nyssanbayeva on 09.03.2022.
//

import UIKit
import SnapKit
import Alamofire

class TopHeadlinesViewController: UIViewController {
    
    private var timer: Timer?
    private var totalPage = 1
    private var currentPage = 1
    private var router = APIRouter(type: .topHeadlines)
    private let refreshControl = UIRefreshControl()
    private var newsEnvelope: NewsEnvelope = NewsEnvelope()
    private var newsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        return tableView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationItem.title = "Top Headlines"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: nil,
            action: nil
        )
        navigationItem.backBarButtonItem?.tintColor = .white

        
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsTableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "TopHeadlines")
        
        view.addSubview(newsTableView)
        newsTableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        refreshControl.tintColor = Colors.emerald
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        newsTableView.addSubview(refreshControl)
        
        
//        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { [weak self] (timer) in
//            self?.fetchData(page: 1, refresh: true)
//        })
        
        fetchData(page: 1, refresh: true)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        fetchData(page: 1, refresh: true)
    }

    func fetchData(page: Int, refresh: Bool = false) {
        DispatchQueue.main.async {
            if refresh {
                self.refreshControl.beginRefreshing()
            }
            
            self.router.page = page
            
            self.router.sendRequest { result in
                if refresh {
                    self.refreshControl.endRefreshing()
                }
                
                switch result {
                case .success(let newsEnvelope):
                    // очищаем массив если обновляем страницу свайпом вниз
                    // когда свайпаем вниз появляется SpinnerFooter сверху tableView
                    // и обновляем данные отправляя request
                    if self.router.page == 1 {
                        self.newsEnvelope.articles = []
                    }
                    
                    self.newsEnvelope.articles.append(contentsOf: newsEnvelope.articles)
                    self.newsTableView.reloadData()
                    
                    if newsEnvelope.totalResults < 15 {
                        self.totalPage = newsEnvelope.totalResults
                    } else {
                        self.totalPage = newsEnvelope.totalResults / 15
                    }
                case .failure(_):
                    break
                }
            }
        }
    }
    
    func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
}

extension TopHeadlinesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        newsEnvelope.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = newsTableView.dequeueReusableCell(
            withIdentifier: "TopHeadlines",
            for: indexPath
        ) as? NewsTableViewCell else {
            fatalError()
        }

        cell.configure(with: newsEnvelope.articles[indexPath.row])
        
        // если встречаем последнюю ячейку table view
        if(indexPath.row == newsEnvelope.articles.count - 1) {
            loadMoreData()
        }
        
        return cell
    }
    
    func loadMoreData() {
        print("SPINNING")
        self.newsTableView.tableFooterView = createSpinnerFooter()
        currentPage += 1
        fetchData(page: currentPage, refresh: false)
    }

}

extension TopHeadlinesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        newsTableView.deselectRow(at: indexPath, animated: true)
        
        let vc = NewsDetailsViewController(isSavedNews: false)
        vc.news = newsEnvelope.articles[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
