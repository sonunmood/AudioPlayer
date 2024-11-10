//
//  NEEVC.swift
//  AudioPlayer
//
//  Created by Sonun Usubalieva on 9/11/24.
//

import UIKit

class SongListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let names: [String] = ["a","e","s"]
    private var tracks: [Track] = []
    private var viewModel: SongListVMProtocol = SongListVM()
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Songs"
        view.backgroundColor = .black
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .black
        tableView.register(UINib(nibName: SongTVCell.identity,
                                 bundle: nil),
                           forCellReuseIdentifier: SongTVCell.identity)
        
        Task {
            let tracks = await viewModel.loadTracks()
              DispatchQueue.main.async {
                  // Reload your UI with the tracks data
                  self.tracks = tracks
                  self.tableView.reloadData()
              }
          }
    }
}

extension SongListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SongTVCell.identity, for: indexPath) as! SongTVCell
        
        let track = tracks[indexPath.row]
        
        // ispravit'
        cell.songNameLbl.text = track.title
        cell.durationLbl.text = track.duration
        
        
        return cell
        
    }
}

extension SongListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didi idid")
        
        let selectedTrack = names[indexPath.row]
        
         PlayerManager.shared.playTrack(named: selectedTrack)
         
         let vc = PlayerViewController.shared
        vc.trackIndex = indexPath.row
         vc.modalPresentationStyle = .popover
         navigationController?.present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
