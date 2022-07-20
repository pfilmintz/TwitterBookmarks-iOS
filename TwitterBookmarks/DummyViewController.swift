//
//  DummyViewController.swift
//  TwitterBookmarks
//
//  Created by mac on 18/07/2022.
//

import UIKit

class DummyViewController: UIViewController {
    
    var testImage: UIImageView = {
        let images = UIImageView()
        images.clipsToBounds = true
        images.image = UIImage(systemName: "ellipsis")
        
        
        return images
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
       view.addSubview(testImage)
        
        testImage.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .systemBackground
        
        testImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        testImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        testImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        
        testImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
       
     //   view.safeAreaLayoutGuide.bottomAnchor.constraint( greaterThanOrEqualTo: testImage.bottomAnchor, constant: 32).isActive = true
        
        testImage.bottomAnchor.constraint( lessThanOrEqualTo: view.bottomAnchor, constant: -32).isActive = true
        
       
        
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
