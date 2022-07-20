//
//  FoldersTableViewCell.swift
//  TwitterBookmarks
//
//  Created by mac on 14/07/2022.
//

import UIKit

class FoldersTableViewCell: UITableViewCell {
    
    
    
    static let identifier = "FoldersTableViewCell"
      
      var bookmarkView: UIView = {
          let bgview = UIView()
          bgview.clipsToBounds = true
          bgview.backgroundColor = .white
          bgview.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
          bgview.layer.cornerRadius =   bgview.frame.size.width / 2
          return bgview
          
      }()
      
      var bookmarkLabel: UILabel = {
          let titleLabel = UILabel()
          titleLabel.textColor = .lightGray
          titleLabel.clipsToBounds = true
          return titleLabel
      }()
      
      var bkmImage: UIImageView = {
          let myimage = UIImageView()
          myimage.image = UIImage(systemName: "bookmark.fill")
          myimage.clipsToBounds = true
          return myimage
      }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessoryType = .disclosureIndicator
        
        setupConstrainsts()
        
        selectionStyle = .none
        
    }
    
    func setupConstrainsts(){
        contentView.addSubview(bookmarkView)
        contentView.addSubview(bkmImage)
        contentView.addSubview(bookmarkLabel)
        
        
        bookmarkView.translatesAutoresizingMaskIntoConstraints = false
        bkmImage.translatesAutoresizingMaskIntoConstraints = false
    
        bookmarkLabel.translatesAutoresizingMaskIntoConstraints = false
        
        bookmarkView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        bookmarkView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        bookmarkView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        bookmarkView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        bkmImage.centerXAnchor.constraint(equalTo: bookmarkView.centerXAnchor).isActive = true
        bkmImage.centerYAnchor.constraint(equalTo: bookmarkView.centerYAnchor).isActive = true
        
        bkmImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        bkmImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        bookmarkLabel.leftAnchor.constraint(equalTo: bookmarkView.rightAnchor, constant: 16).isActive = true
        bookmarkLabel.centerYAnchor.constraint(equalTo: bookmarkView.centerYAnchor).isActive = true
        
        
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
