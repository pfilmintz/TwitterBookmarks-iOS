//
//  TextTableViewCell.swift
//  TwitterBookmarks
//
//  Created by mac on 10/07/2022.
//


import UIKit


class TextTableViewCell: UITableViewCell {
    static let identifier = "TextTableViewCell"
    
    var menuButtonAction : (() -> ())?
    
    
  /*  @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var userImgView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!*/
    
    var menuBtn: UIView = {
        let button = UIButton()
        
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        
        button.setImage(UIImage(systemName: "ellipsis"), for:.normal)
            
        return button
        
    }()
    
    var userImgView: UIImageView = {
        let myimage = UIImageView()
        myimage.contentMode = .scaleAspectFill
        
        myimage.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        myimage.layer.cornerRadius =   myimage.frame.size.width / 2
        myimage.clipsToBounds = true
        return myimage
    }()
    
    var userNameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .lightGray
        nameLabel.clipsToBounds = true
        return nameLabel
    }()

    var postTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.clipsToBounds = true
        label.font = label.font.withSize(12)
        label.numberOfLines = 0
        return label
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupConstrainsts()
        
        selectionStyle = .none
        
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        
        
    }
    
    func setupConstrainsts(){
        
        contentView.addSubview(userImgView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(postTextLabel)
        
        
        userImgView.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
    
        postTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        userImgView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        userImgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        userImgView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        userImgView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        userNameLabel.leftAnchor.constraint(equalTo: userImgView.rightAnchor, constant: 8).isActive = true
        userNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        
        postTextLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor).isActive = true
        postTextLabel.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor, constant:-32).isActive = true
        postTextLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 16).isActive = true
        postTextLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        
    }
    
    func loadViews(feedposts: Tweet?) {
        
        
        
        
        userImgView.layer.cornerRadius =  userImgView.frame.size.width / 2
        
        
        
      //  userImgView.image = #imageLiteral(resourceName: "user")
        
        
        
         //userNameLabel.text = feedposts.name
        
        postTextLabel.text = feedposts?.text
        
        
        
        
        
        
        
       }
    
     

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    @IBAction func menuBtnAction(_  sender: UIButton) {
        menuButtonAction?()
    }
    
    
    
}

