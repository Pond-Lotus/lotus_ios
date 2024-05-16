//
//  DeleteFriendTableViewCell.swift
//  TODORI
//
//  Created by 제임스 on 2023/10/13.
//

import UIKit

class DeleteFriendTableViewCell: UITableViewCell {
    var profileImageView: UIImageView = ImageViewManager.shared.getRequestProfileImageView()
    var nicknameLabel: UILabel = LabelManager.shared.getFriendNicknameLabel()
    var deleteButton: UIButton = ButtonManager.shared.getDeleteFriendButton()
    var background: UIView = UIView()
    var friend: Friend
    var delegate: DeleteFriendTableViewCellDelegate?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    init(friend: Friend) {
        self.friend = friend
        super.init(style: .default, reuseIdentifier: "RequestCell")
        self.nicknameLabel.text = friend.nickname
        if let image = friend.image {
            profileImageView.image = UserSession.shared.base64StringToImage(base64String: image)
        }else {
            profileImageView.image = UIImage(named: "default-profile")
        }
        setUI()
        addFunction()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func addFunction(){
        deleteButton.addTarget(self, action: #selector(tapDeleteButton), for: .touchUpInside)
    }
    
    private func setUI(){
        background.backgroundColor = UIColor.todoriWhite
        background.addSubViews([profileImageView, nicknameLabel, deleteButton])
        self.contentView.addSubview(background)

        background.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints { make in
            make.height.width.equalTo(40)
            make.left.equalToSuperview().offset(27)
            make.centerY.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-27)
            make.centerY.equalToSuperview()
            make.width.equalTo(66)
            make.height.equalTo(28)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.left.equalTo(profileImageView.snp.right).offset(12)
            make.centerY.equalToSuperview()
        }
        

    }
    
    @objc private func tapDeleteButton(){
        self.delegate?.tapDeleteFriend(friend: self.friend)
    }

}

protocol DeleteFriendTableViewCellDelegate: AnyObject {
    func tapDeleteFriend(friend: Friend)
}
