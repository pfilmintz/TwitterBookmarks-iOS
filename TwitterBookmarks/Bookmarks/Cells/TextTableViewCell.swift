//
//  TextTableViewCell.swift
//  TwitterBookmarks
//
//  Created by mac on 10/07/2022.
//


import UIKit


class TextTableViewCell: UITableViewCell {
    
    
    var menuButtonAction : (() -> ())?
    
    
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var userImgView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
        
        
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        
        
       
        
        
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
    
    
    
    
    @IBAction func repostBtnAction(_ sender: UIButton) {
  //      repostAction?()
    }
    
    
}

