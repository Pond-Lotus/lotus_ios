//
//  FriendTableViewCell.swift
//  TODORI
//
//  Created by 제임스 on 2023/10/13.
//

import UIKit
import SnapKit

class FriendTableViewCell: UITableViewCell {
    var imageString: String?
    var imageData: UIImage?
    var profileImageView: UIImageView = ImageViewManager.shared.getRequestProfileImageView()
    var nicknameLabel: UILabel = LabelManager.shared.getFriendNicknameLabel()
    var starButton: UIButton = ButtonManager.shared.getFavoriteButton()
    var background: UIView = UIView()
    var friend: Friend
    var delegate: FriendTableViewCellDelegate?
    
    init(friend: Friend) {
        self.friend = friend
        super.init(style: .default, reuseIdentifier: "FriendCell")
        nicknameLabel.text = friend.nickname
        starButton.setImage(friend.star! ? UIImage(named: "star-on") : UIImage(named: "star-off"), for: .normal)
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    private func addFunction(){
        starButton.addTarget(self, action: #selector(tapFavoriteButton), for: .touchDown)
    }
    
    private func setUI(){
        background.backgroundColor = UIColor.todoriWhite
        background.addSubViews([profileImageView, nicknameLabel, starButton])
        self.contentView.addSubview(background)

        background.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints { make in
            make.height.width.equalTo(40)
            make.left.equalToSuperview().offset(27)
            make.centerY.equalToSuperview()
        }
        
        starButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-27)
            make.centerY.equalToSuperview()
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.left.equalTo(profileImageView.snp.right).offset(12)
            make.centerY.equalToSuperview()
        }
        

    }
    
    @objc private func tapFavoriteButton(){
        //옵셔널 선언되어있는 friend 변수를 person 변수에 대입시켜 언랩핑함
        FriendService.shared.setStar(friend: self.friend) { (response) in
            switch(response){
            case .success(let data):
                if let result = data as? ResultCodeResponse {
                    if result.resultCode == 200 {
                        print("star 200")
                        self.friend.star = !(self.friend.star!)
                        self.starButton.setImage(self.friend.star! ? UIImage(named: "star-on") : UIImage(named: "star-off"), for: .normal)
                        self.delegate?.updateStar(friend: self.friend)
                    }else {
                        print("star 500")
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    

}

protocol FriendTableViewCellDelegate: AnyObject {
    func updateStar(friend: Friend)
}
