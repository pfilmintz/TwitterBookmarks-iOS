//
//  ViewController.swift
//  TwitterBookmarks
//
//  Created by mac on 10/07/2022.
//

import UIKit

class ViewController: UIViewController {
    
    var myStack: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.distribution = .fillEqually
        stackview.spacing = 20
        
        return stackview
        
    }()
    
    var bgView: UIView = {
        let bgview = UIView()
        bgview.backgroundColor = .cyan
        bgview.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        bgview.layer.cornerRadius =   bgview.frame.size.width / 2
        return bgview
        
    }()
    
    var bkmImage: UIImageView = {
        let myimage = UIImageView()
        myimage.image = UIImage(systemName: "square.and.pencil")
        myimage.clipsToBounds = true
        return myimage
    }()
    
    var editEmailTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter Email"
        textfield.clipsToBounds = true
        return textfield
        
        
    }()
    
    var editPasswordTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter Password"
        textfield.clipsToBounds = true
        return textfield
        
        
    }()
    
    var accountLabel: UILabel = {
        let label = UILabel()
        label.text = "Don't have an account, click here"
        label.textColor = .white
        label.numberOfLines = 0
        return label
        
    }()
    
    var button: UIButton = {
        let mybutton = UIButton()
        mybutton.layer.cornerRadius = 8
       // mybutton.titleLabel?.text = "login"
      //  mybutton.titleLabel?.textColor = .white
        mybutton.setTitle("login", for: .normal)
        mybutton.setTitleColor(.white, for: .normal)
        mybutton.clipsToBounds = true
        mybutton.backgroundColor = UIColor.systemBlue
        return mybutton
        
    }()
    
    func addViewsToStackView(){
        myStack.addArrangedSubview(editEmailTextfield)
        myStack.addArrangedSubview(editPasswordTextfield)
        myStack.addArrangedSubview(button)
    }
   

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.addSubview(myStack)
     //   view.addSubview(button)
        view.addSubview(accountLabel)
        view.addSubview(bgView)
        view.addSubview(bkmImage)
        
        addViewsToStackView()
        
        editEmailTextfield.translatesAutoresizingMaskIntoConstraints = false
        editPasswordTextfield.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        accountLabel.translatesAutoresizingMaskIntoConstraints = false
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bkmImage.translatesAutoresizingMaskIntoConstraints = false
        myStack.translatesAutoresizingMaskIntoConstraints = false
        
        
        myStack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
       // myStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        myStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        myStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true
        myStack.topAnchor.constraint(equalTo: bgView.bottomAnchor, constant: 32).isActive = true
        myStack.leadingAnchor.constraint(equalTo: editEmailTextfield.leadingAnchor).isActive = true
        myStack.trailingAnchor.constraint(equalTo: editEmailTextfield.trailingAnchor).isActive = true
        
        editEmailTextfield.widthAnchor.constraint(equalTo: editEmailTextfield.widthAnchor).isActive = true
   //     editEmailTextfield.leadingAnchor.constraint(equalTo: myStack.leftAnchor).isActive = true
   //     editEmailTextfield.trailingAnchor.constraint(equalTo: myStack.trailingAnchor).isActive = true
       // myStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
      //  myStack.topAnchor.constraint(equalTo: bgView.bottomAnchor, constant: 32).isActive = true
        
    
        
     //   button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
       // button.topAnchor.constraint(equalTo: editEmailTextfield.bottomAnchor, constant: 16).isActive = true
        button.widthAnchor.constraint(equalTo: editEmailTextfield.widthAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        accountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        accountLabel.leftAnchor.constraint(greaterThanOrEqualTo: view.leftAnchor, constant: 32).isActive = true
        accountLabel.rightAnchor.constraint(greaterThanOrEqualTo: view.leftAnchor, constant: 32).isActive = true
        accountLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32).isActive = true
        
        bgView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        bgView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        bgView.heightAnchor.constraint(equalToConstant: 100).isActive = true
       // bgView.bottomAnchor.constraint(equalTo: editEmailTextfield.topAnchor, constant: 32).isActive = true
        
        bkmImage.centerXAnchor.constraint(equalTo: bgView.centerXAnchor).isActive = true
        bkmImage.centerYAnchor.constraint(equalTo: bgView.centerYAnchor).isActive = true
        
       
        
    }


}

