//
//  NEEVC.swift
//  AudioPlayer
//
//  Created by Sonun Usubalieva on 9/11/24.
//

import UIKit

class SongListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Songs"
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: SongTVCell.identity,
                                 bundle: nil),
                           forCellReuseIdentifier: SongTVCell.identity)
    }
}

extension SongListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SongTVCell.identity, for: indexPath) as! SongTVCell
        
        return cell
        
    }
}

extension SongListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didi idid")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
