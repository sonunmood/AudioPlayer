//
//  TrackListVC.swift
//  AudioPlayer
//
//  Created by Sonun Usubalieva on 9/11/24.
//

import UIKit

final class TrackListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    private let viewModel: TrackListVMProtocol = TrackListVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

extension TrackListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel.getTracks().count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let track = viewModel.getTrack(indexPath.row) else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackTVCell.identity,
                                                 for: indexPath) as! TrackTVCell
        cell.setData(track)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension TrackListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        let vc = PlayerViewController.shared
        vc.resetState(with: viewModel.getTracks(), startingAt: indexPath.row)
        vc.modalPresentationStyle = .popover
        navigationController?.present(vc, animated: true)
    }
}

private
extension TrackListVC {
    func setup() {
        title = "Songs"
        view.backgroundColor = .black
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .black
        tableView.register(UINib(
            nibName: TrackTVCell.identity,bundle: nil),
                           forCellReuseIdentifier: TrackTVCell.identity)
    }
}
