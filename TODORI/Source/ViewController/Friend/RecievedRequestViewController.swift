//
//  RecievedRequestViewController.swift
//  TODORI
//
//  Created by 제임스 on 2023/10/06.
//

import UIKit


class RecievedRequestViewController: UIViewController {
    var nothingExistLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 받은 친구 요청이 없어요."
        label.textColor = UIColor(white: 0.62, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    var tableView: UITableView = {
        let tableview = UITableView()
        tableview.separatorStyle = .none
        tableview.backgroundColor = UIColor.todoriWhite
        return tableview
    }()
    var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        return control
    }()
    var progressView: UIProgressView = {
        let progress = UIProgressView()
        progress.isHidden = true
        return progress
    }()
    var friendArray: [Friend] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        tableView.delegate = self
        tableView.dataSource = self
        progressView.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchFriendRequest()
    }
    
    private func setUI(){
        self.view.addSubViews([tableView, nothingExistLabel, progressView])
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(searchFriendRequest), for: .valueChanged)
        
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(10)
        }
        
        nothingExistLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        progressView.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
    }
    
    @objc private func searchFriendRequest(){
        refreshControl.beginRefreshing()
        nothingExistLabel.isHidden = true
        FriendService.shared.searchRequest { (response) in
            switch(response){
            case .success(let data):
                if let result = data as? FriendResponseData{
                    if result.resultCode == 200 {
                        print("friend request 200")
                        self.friendArray = result.data
                        self.tableView.reloadData()
                        self.nothingExistLabel.isHidden = !self.friendArray.isEmpty
                        self.refreshControl.endRefreshing()
                        self.progressView.isHidden = true
                    }else{
                        print("friend request 500")
                    }
                }
            case .failure(let error):
                print(error)
            }
        }

    }
}
extension RecievedRequestViewController: UITableViewDelegate{
    
}

extension RecievedRequestViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let friend = friendArray[indexPath.row]
        let cell = RecievedRequestTableViewCell()
        cell.friend = friend
        cell.emailLabel.text = friend.email
        cell.nicknameLabel.text = friend.nickname
        if let image = friend.image {
            cell.profileImageView.image = UserSession.shared.base64StringToImage(base64String: image)
        } else {
            cell.profileImageView.image = UIImage(named: "default-profile")
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}
extension RecievedRequestViewController: HandleRequestDelegate {
    func handleRequest(email: String) {
        friendArray.removeAll(where: {$0.email == email})
        tableView.reloadData()
        nothingExistLabel.isHidden = !friendArray.isEmpty
    }
}

