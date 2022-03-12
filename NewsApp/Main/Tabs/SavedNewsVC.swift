//
//  SavedNewsViewController.swift
//  NewsApp
//
//  Created by Leyla Nyssanbayeva on 09.03.2022.
//

import UIKit

class SavedNewsViewController: UIViewController {

    static var newsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        return tableView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Saved"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: nil,
            action: nil
        )
        navigationItem.backBarButtonItem?.tintColor = .white
        
        SavedNewsViewController.newsTableView.delegate = self
        SavedNewsViewController.newsTableView.dataSource = self
        SavedNewsViewController.newsTableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "Saved")
                
        view.addSubview(SavedNewsViewController.newsTableView)
        SavedNewsViewController.newsTableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("SAVING: ", DataStorage.shared.savedNews.count)
            DataStorage.shared.savedNews.remove(at: indexPath.row)
            print("SAVING: ", DataStorage.shared.savedNews.count)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}

extension SavedNewsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        DataStorage.shared.savedNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = SavedNewsViewController.newsTableView.dequeueReusableCell(
            withIdentifier: "Saved",
            for: indexPath
        ) as? NewsTableViewCell else {
            fatalError()
        }
        
        cell.configure(with: DataStorage.shared.savedNews[indexPath.row])
        return cell
    }

}

extension SavedNewsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SavedNewsViewController.newsTableView.deselectRow(at: indexPath, animated: true)
        
        let vc = NewsDetailsViewController(isSavedNews: true)
        vc.news = DataStorage.shared.savedNews[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

