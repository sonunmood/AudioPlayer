//
//  HomeView.swift
//  AudioPlayer
//
//  Created by Sonun Usubalieva on 8/11/24.
//

import UIKit

class HomeView: UIViewController {
    
    var trackList: [Track] = [Track(title: "", artist: "", duration: 0.0, fileName: "")]
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(TrackCell.self, forCellReuseIdentifier: "TableViewCell")
        table.backgroundColor = .systemCyan
        table.translatesAutoresizingMaskIntoConstraints  = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSubViews()
    }
    
    private func setUpSubViews() {
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
}

extension HomeView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        trackList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TrackCell
        let model = trackList[indexPath.row]
        cell.setData(data: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
