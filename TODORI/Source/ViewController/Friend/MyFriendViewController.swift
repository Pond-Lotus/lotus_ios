//
//  MyFriendViewController.swift
//  TODORI
//
//  Created by 제임스 on 2023/10/06.
//

import UIKit
import SnapKit

class MyFriendViewController: UIViewController {
    var entireButton = ButtonManager.shared.getManagementButton(title: "전체")
    var favoriteButton = ButtonManager.shared.getManagementButton(title: "즐겨찾기")
    var managementButton = ButtonManager.shared.getManagementButton(title: "관리하기")
    var tabStatus: Int = 0 //전체: 0, 즐겨찾기: 1, 관리하기: 2
    var tableView: UITableView = {
        let tableview = UITableView()
        tableview.separatorStyle = .none
        tableview.backgroundColor = UIColor.todoriWhite
        return tableview
    }()
    var buttonStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.distribution = .equalSpacing
        stackview.spacing = 8
        stackview.backgroundColor = UIColor.todoriWhite
        return stackview
    }()
    var deleteButtonBlackView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.5)
        return view
    }()
    var nothingExistLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 친구를 맺지 않았어요.\n친구를 추가하여 일정을 공유해 보세요."
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = UIColor(white: 0.62, alpha: 1)
        label.isHidden = true
        return label
    }()
    var popupVC: TwoButtonPopupViewController = {
        let popup = TwoButtonPopupViewController()
        popup.titleLabel.text = "친구 끊기"
        popup.messageLabel.text = "정말 친구를 끊으시나요?"
        popup.negativeActionButton.setTitle("취소", for: .normal)
        popup.positiveActionButton.setTitle("확인", for: .normal)
        popup.modalPresentationStyle = .overCurrentContext
        return popup
    }()

    
    let orangeBorderColor = UIColor(red: 1, green: 0.616, blue: 0.302, alpha: 1)
    let orangeBackgroundColor = UIColor(red: 1, green: 0.855, blue: 0.725, alpha: 1)
    
    var friendList: [Friend] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        addFunction()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchFriend()
    }
    
    private func setUI(){
        buttonStackView.addArrangedSubviews([entireButton, favoriteButton, managementButton])
        self.view.addSubViews([buttonStackView, tableView, nothingExistLabel])
        entireButton.layer.borderColor = orangeBorderColor.cgColor

        if self.traitCollection.userInterfaceStyle == .dark {
            entireButton.backgroundColor = .clear
            entireButton.setTitleColor(orangeBorderColor, for: .normal)
        } else {
            entireButton.backgroundColor = orangeBackgroundColor
            entireButton.setTitleColor(UIColor.black, for: .normal)
        }
        
        entireButton.snp.makeConstraints { make in
            make.height.equalTo(28)
            make.width.equalTo(51)
        }

        favoriteButton.snp.makeConstraints { make in
            make.height.equalTo(28)
            make.width.equalTo(68)
        }
        
        managementButton.snp.makeConstraints { make in
            make.height.equalTo(28)
            make.width.equalTo(68)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(29)
            make.left.equalToSuperview().offset(25)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        nothingExistLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
                
    }
    
    private func addFunction(){
        entireButton.addTarget(self, action: #selector(tapEntireButton), for: .touchDown)
        favoriteButton.addTarget(self, action: #selector(tapFavoriteButton), for: .touchDown)
        managementButton.addTarget(self, action: #selector(tapManagementButton), for: .touchDown)
    }
    
    @objc private func tapEntireButton(){
        setTapButtonColorSetting(selectedButton: entireButton, deselectedButtons: [favoriteButton, managementButton])
        tabStatus = 0
        searchFriend()
    }
    
    @objc private func tapFavoriteButton(){
        setTapButtonColorSetting(selectedButton: favoriteButton, deselectedButtons: [entireButton, managementButton])
        tabStatus = 1
        deleteNoStarFriend()
    }
    
    @objc private func tapManagementButton(){
        setTapButtonColorSetting(selectedButton: managementButton, deselectedButtons: [entireButton, favoriteButton])
        tabStatus = 2
        searchFriend()
        sortByNickname()
    }
    
    private func setTapButtonColorSetting(selectedButton: UIButton, deselectedButtons: [UIButton]){
        
        if self.traitCollection.userInterfaceStyle == .dark {
            selectedButton.layer.borderColor = orangeBorderColor.cgColor
            selectedButton.backgroundColor = .clear
            selectedButton.setTitleColor(orangeBorderColor, for: .normal)
        } else {
            selectedButton.layer.borderColor = orangeBorderColor.cgColor
            selectedButton.backgroundColor = orangeBackgroundColor
            selectedButton.setTitleColor(UIColor.black, for: .normal)
        }
        
        deselectedButtons.forEach { button in
            button.layer.borderColor = UIColor.dg04?.cgColor
            button.backgroundColor = .clear
            button.setTitleColor(.textColor, for: .normal)
        }
    }
    
    private func sortByStar(){
        friendList.sort { friend1, friend2 in
            if let star1 = friend1.star, let star2 = friend2.star {
                return star1 && !star2
            }
            return false
        }
    }
    
    private func sortByNickname(){
        friendList.sort { friend1, friend2 in
            return friend1.nickname < friend2.nickname
        }
    }
    
    private func deleteNoStarFriend(){
        friendList.removeAll { friend in
            friend.star == false
        }
        tableView.reloadData()
    }
}
extension MyFriendViewController{
    private func searchFriend(){
        FriendService.shared.searchFriend { (response) in
            switch(response){
            case .success(let data):
                if let result = data as? FriendResponseData{
                    if result.resultCode == 200 {
                        print("friend 200")
                        self.friendList = result.data
                        self.tableView.reloadData()
                        self.sortByNickname()
                        self.sortByStar()
                        self.nothingExistLabel.isHidden = !self.friendList.isEmpty
                    }else{
                        print("request error")
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
extension MyFriendViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 73
    }
}

extension MyFriendViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friend = friendList[indexPath.row]
        let nextVC = FriendToDoViewController()
        nextVC.friend = friend
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        friendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let friend = friendList[indexPath.row]
        
        switch(tabStatus){
        case 0, 1:
            let cell = FriendTableViewCell(friend: friend)
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        case 2:
            let cell = DeleteFriendTableViewCell(friend: friend)
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        default:
            let cell = FriendTableViewCell(friend: friend)
            cell.selectionStyle = .none
            return cell
        }
        
    }
}

extension MyFriendViewController: FriendTableViewCellDelegate {
    func updateStar(friend: Friend) {
        if let row = friendList.firstIndex(where: { person in
            person.email == friend.email
        }){
            friendList[row] = friend
            tableView.reloadData()
            sortByNickname()
            sortByStar()
        }
    }
}

extension MyFriendViewController: DeleteFriendTableViewCellDelegate{
    func tapDeleteFriend(friend: Friend) {
        popupVC.action = {
            FriendService.shared.deleteFriend(friend: friend) { response in
                switch(response){
                case .success(let data):
                    if let result = data as? ResultCodeResponse {
                        if result.resultCode == 200 {
                            print("del friend 200")
                            self.popupVC.dismiss(animated: false)
                            self.friendList.removeAll(where: {$0.email == friend.email})
                            self.tableView.reloadData()
                        }else {
                            print("del friend error")
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        self.present(popupVC, animated: false)
        
    }
}
