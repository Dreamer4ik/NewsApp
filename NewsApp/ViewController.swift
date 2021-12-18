//
//  ViewController.swift
//  NewsApp
//
//  Created by Ivan Potapenko on 17.12.2021.
//

import UIKit

// TableView
// Custom cell
// API Caller
// Open the News Story
// Search for News Stories
// GET https://newsapi.org/v2/top-headlines?country=us&apiKey=2c7df03b63f646a6a2e2c3961e22abc5

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(NewsTableViewCell.self,
                       forCellReuseIdentifier: NewsTableViewCell.identifier)
        
        return table
    }()
    
    private var viewModels = [NewsTableViewCellViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "News"
        view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        addSubViews()
        
        APICaller.shared.getTopStories { [weak self] result in
            switch result {
            case .success(let articles):
                self?.viewModels = articles.compactMap({
                    NewsTableViewCellViewModel(title: $0.title,
                                               subtitle: $0.description ?? "No description",
                                               imageURL: URL(string: $0.urlToImage ?? ""))
                })
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func addSubViews() {
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NewsTableViewCell.identifier,
            for: indexPath) as? NewsTableViewCell else {
                fatalError()
            }
        // deprecated
        // cell.textLabel?.text = "Something"
        //        var config = cell.defaultContentConfiguration()
        //        config.text = "Something"
        //        cell.contentConfiguration = config
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}

