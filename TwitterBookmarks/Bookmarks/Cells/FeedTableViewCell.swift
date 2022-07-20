//
//  FeedTableView  swift
//  Minztership
//
//  Created by mac on 17/09/2021.
//

import UIKit


struct feedTableViewCellViewModel{
    
    let bookmarksViewModel = BookmarksViewModel()
    
    
 
    
    let networker = NetworkManager.shared
    
    
    //receives data from BookmarksVc that listens to ntoifc from bookmarksVM
    //data is received from BookmarksVc through cell.feedTableViewCellViewModel.tweetImagesData
    var tweetImagesData: [Media]? = []
    
    
    
    
    
    //i want to return a value when the request is done so i pass a closure as a param
    func retrieveOneImage(url: String, completion: @escaping (Data?) -> ()){
        
        
        networker.image(url: url) { data, error in
            if let data = data {
               // let image = UIImage(data: data)
                
                //return data from retrieveOneImage func
                completion(data)
                
                
                    
                }else{
               
                    completion(data)
                }
                
            }
        
            
        }
    
    func retrieveMultipleImages(urls: [String], completion: @escaping ([Data]?) -> ()){
        
        
        //pass in urls and result of complettion
        networker.downloadImages(urls: urls) { data, images,error in
            
            completion(images)

        }
        
     
        }
    
    
    
}


class FeedTableViewCell: UITableViewCell {
    
    var viewModel = feedTableViewCellViewModel()
    
    var menuButtonAction : (() -> ())?
    var multipleImagesAction : (() -> ())?
    
    var playButton: UIButton!

    @IBOutlet weak var userImgView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var imagesView: UIView!
    
    @IBOutlet weak var imagesStackViewR: UIStackView!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var imagesStackViewL: UIStackView!
    
    
    
    @IBOutlet weak var imagesViewHeight: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var imagesViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    
    var Images = [UIImageView?]()
    
    var representedIdentifier = ""
    
    
    
    
    
    
   // var retrievedData: TwitterAPIResponse
    
    
    
    //key of post mapped to keys of images attached
    var xImagesDic = [String: [String]]()
    
    //key of post mapped to data of images attached
  //  var imagesDataDisc = NSCache [String: [Data]]()
    
    var imagesDataDisc = NSCache<NSString, NSArray>()
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
      
        
        Images.append(image1)
        Images.append(image2)
        Images.append(image3)
        Images.append(image4)
        
        image1.isHidden = true
        image2.isHidden = true
        image3.isHidden = true
        image4.isHidden = true
        
        
        
        //1
        let buttonX = 0
        let buttonY = 0
        let buttonWidth = 100
        let buttonHeight = 50

        //2
       
        playButton  = UIButton(type: .custom)
        playButton.setImage(UIImage(named: "play.png"), for: .normal)
        


        //3
        playButton.frame = CGRect(x: buttonX, y: buttonY, width: buttonWidth, height: buttonHeight)
        
        playButton.center = imagesView.convert(imagesView.center, from:imagesView.superview)
        
        playButton.isHidden = true
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // your cleanup cod
        //     repostViewHidden = nil
        //   repostView.isHidden = true
        
        
        
        image1.isHidden = true
        image2.isHidden = true
        image3.isHidden = true
        image4.isHidden = true
        
        playButton.isHidden = true
        
        
    }
    
    func loadViews(feedposts: Tweet?) {
        
        
          userImgView.layer.cornerRadius =   userImgView.frame.size.width / 2
        
          selectionStyle = .none
        
        
        
        postTextLabel.text = feedposts?.text
        
        if let imageKeys = feedposts?.attachments{
            
            if let images = viewModel.tweetImagesData {
                
            
            xImagesDic[(feedposts?.id)!] = imageKeys.media_keys
                
                
                let representedCellIdentifier = feedposts?.id
                
                 representedIdentifier = representedCellIdentifier!
            
           
            
            let imageKeys = imageKeys.media_keys
            
            
            var imageDetatils = [Media]()
            
            
                
                for imageData in images{
                    
                    let key = imageData.media_key
                    
                    if(imageKeys.contains(key)){
                        //get url
                        
                        let imageDetail = Media(media_key: imageData.media_key , type: imageData.type , url: imageData.url ?? "" , preview_image_url: imageData.preview_image_url ?? "")
                        
                        imageDetatils.append(imageDetail)
                        
                    }
                     
                    
                 }
            
            
            
                
            
            var Imageurl = ""
            
            if(imageDetatils[0].type == "video"){
                
                 playButton.isHidden = false
                
                 imagesView.isHidden = false
                 imagesView.layer.cornerRadius = 8
                 imagesStackViewR.isHidden = true
                 image1.isHidden = false
                
                 image1.image = nil
                
                // playButton.isHidden = false
                
                Imageurl = imageDetatils[0].preview_image_url ?? ""
                
                if let imageData = imagesDataDisc.object(forKey: (feedposts?.id)! as NSString){
                    
                   // let data = imagesDataDisc[(feedposts?.id)!]![0]
                    
                    let data = imageData[0]
                    let image = UIImage(data: data as! Data)
                    if( representedIdentifier == representedIdentifier){
                     image1.image = image
                        
                    }
                    
                }
                else{
                
                viewModel.retrieveOneImage(url: Imageurl) { downloadedImage in
                    if let image_data = downloadedImage{
                        let image = UIImage(data: image_data)
                        
                        var imagesData = [Data]()
                        imagesData.append(image_data)
                        
                        if( self.representedIdentifier == representedCellIdentifier){
                            DispatchQueue.main.async {
                            self.image1.image = image
                                
                                self.imagesDataDisc.setObject(imagesData as NSArray, forKey: (feedposts?.id)! as NSString)
                                
                            }
                        }
                        if(self.representedIdentifier != representedCellIdentifier){
                            DispatchQueue.main.async {
                            self.image1.image = nil
                            }
                        }
                    }else{
                        DispatchQueue.main.async {
                        self.image1.image = nil
                        }
                    }
                }
            }
                
            
              
                
                
                
            }
            
            if(imageDetatils[0].type == "photo"){
                
                var imageUrls = [String]()
                Imageurl = imageDetatils[0].url ?? ""
                
                for image in imageDetatils {
                    imageUrls.append(image.url ?? "")
                }
                
                if(imageDetatils.count == 1){
                
                 imagesView.isHidden = false
                 imagesView.layer.cornerRadius = 8
                 imagesStackViewR.isHidden = true
                 image1.isHidden = false
                
                 image1.image = nil
                    
                    if let imageData = imagesDataDisc.object(forKey: (feedposts?.id)! as NSString){
                        
                       // let data = imagesDataDisc[(feedposts?.id)!]![0]
                        
                        let data = imageData[0]
                        let image = UIImage(data: data as! Data)
                        if( representedIdentifier == representedIdentifier){
                         image1.image = image
                            
                        }
                        
                    }
                   
                    else{
                        
                        viewModel.retrieveOneImage(url: Imageurl) { downloadedImage in
                            if let image_data = downloadedImage{
                                let image = UIImage(data: image_data)
                                
                                var imagesData = [Data]()
                                imagesData.append(image_data)
                                
                                if( self.representedIdentifier == representedCellIdentifier){
                                    DispatchQueue.main.async {
                                    self.image1.image = image
                                        
                                        self.imagesDataDisc.setObject(imagesData as NSArray, forKey: (feedposts?.id)! as NSString)
                                        
                                    }
                                }
                                if(self.representedIdentifier != representedCellIdentifier){
                                    DispatchQueue.main.async {
                                    self.image1.image = nil
                                    }
                                }
                            }else{
                                DispatchQueue.main.async {
                                self.image1.image = nil
                                }
                            }
                        }
                        
                     
                    
                }
                }
                
                if(imageDetatils.count > 1){
                     imagesStackViewR.isHidden = false
                    
                     imagesView.isHidden = false
                    
                    if let imagesData = imagesDataDisc.object(forKey: (feedposts?.id)! as NSString){
                        var i = 0
                        for picture in imagesData{
                            
                            let image = UIImage(data: picture as! Data)
                            
                            DispatchQueue.main.async {
                                if( self.representedIdentifier == representedCellIdentifier){
                                    self.Images[i]?.image = nil
                                    self.Images[i]?.isHidden = false
                                
                                    self.imagesView.layer.cornerRadius = 8
                                
                                    self.Images[i]?.image = image
                                    
                                    
                                
                                i = i + 1
                                }
                            }
                        }
                        
                    }else{
                        
                        
                        viewModel.retrieveMultipleImages(urls: imageUrls) { downloaded_images in
                            
                            if let images = downloaded_images{
                                var i = 0
                            var imagesData = [Data]()
                                
                                for picture in images{
                                let image = UIImage(data: picture)
                                    imagesData.append(picture)
                                DispatchQueue.main.async {
                                    
                                    if( self.representedIdentifier == representedCellIdentifier){
                                        
                                        self.Images[i]?.image = nil
                                        self.Images[i]?.isHidden = false
                                    
                                        self.imagesView.layer.cornerRadius = 8
                                    
                                        self.Images[i]?.image = image
                                        
                                        self.imagesDataDisc.setObject(imagesData as NSArray, forKey: (feedposts?.id)! as NSString)
                                        
                                   // self.imagesDataDisc[(feedposts?.id)!] = imagesData
                                    
                                    i = i + 1
                                    }
                                }
                            }
                            }
                        }
                        
                     
                }
                }
                
            }
            
            
            
           
                
           
                
           
        
        
            
        }
        }
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   
    
    
    
    
    
    @IBAction func menuBtnAction(_ sender: UIButton) {
        menuButtonAction?()
    }
    
    
}
