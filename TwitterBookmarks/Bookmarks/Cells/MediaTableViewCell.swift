//
//  MediaTableViewCell.swift
//  TwitterBookmarks
//
//  Created by mac on 16/07/2022.
//

import UIKit


struct saveTweetData{
    var id: UUID
    var text: String
    var type: String
    var key: String
    var media: [String]
}

struct savedTweetsMediaViewModel{
    
    let networker: NetworkManager = NetworkManager.shared
    
    var id: String
    var posttext: String
    var type: String
    var urls: [String]?
    
    //key of post mapped to keys of images attached
    var xImagesDic = [String: [String]]()
    
    //key of post mapped to data of images attached
    
    var imagesDataDisc = NSCache<NSString, NSArray>()
    
    var representedIdentifier = ""
    
    init(tweet: localTweet){
        id = tweet.id
        posttext = tweet.posttext
        type = tweet.type
        urls = tweet.urls
        
    }
    
    
    //if loaded, retrieve image from cache
    //else
    //load from network
    
    
    //function accepts a closure as param and returns an image
    
    func LoadImages(completion: @escaping ([UIImage]?) -> ()){
        
        if let imagesData = imagesDataDisc.object(forKey: (id) as NSString){
            
            var images = [UIImage]()
            
            for picture in imagesData{
                
                let image = UIImage(data: picture as! Data)
          
                images.append(image!)
            }
            
            
            completion(images)
            
            
        }else{
            
            retrieveMultipleImages2(urls: urls ?? []) { download_images in
                if let images = download_images{
                    DispatchQueue.main.async {
                    completion(images)
                    }
                }else{
                    DispatchQueue.main.async {
                    completion(nil)
                    }
                }
            }
            
        }
    }
    
    func LoadImage(completion: @escaping (UIImage?) -> ()){
        
      
        
        if let imageData = imagesDataDisc.object(forKey: (id) as NSString){
            
            let data = imageData[0]
            let image = UIImage(data: data as! Data)
            
            
            completion(image)
     
            
        }else{
            
           
            
           retrieveOneImage2(url: urls?[0] ?? "") { downloadedImage  in
                
                
            
                if let image_data = downloadedImage{
                    
                    
                    DispatchQueue.main.async {
                        
                        //using return value from callbakc as return value for LoadImage function
                        completion(image_data)
                      
                        
                    }
                    
                }else{
                    DispatchQueue.main.async {
                        completion(nil)
                        
                    }
                }
                
                
            }
        }
        
    
            
        
        
    }
    
    //retrieve l=images from APi
    //store in cache
    //convert data to uiimage
    
    //i want to return a value when the request is done so i pass a closure as a param
    func retrieveOneImage2(url: String, completion: @escaping (UIImage?) -> ()) {
        
        
        networker.image(url: url) { data, error in
            if let data = data {
                
                //append image in array because we want to make this function usable for photos when we append it in images array in cache
                var imagesData = [Data]()
                imagesData.append(data)
                
                //append image to local cache
                self.imagesDataDisc.setObject(imagesData as NSArray, forKey: (id) as NSString)
                
                let image = UIImage(data: data)
                
                //return data from retrieveOneImage func
                completion(image)
               
               
                
                
                    
                }else{
               
                    completion(nil)
                    
                }
                
            }
        
            
        }
    
    func retrieveMultipleImages2(urls: [String], completion: @escaping ([UIImage]?) -> ()){
        
        
        //pass in urls and result of complettion
        networker.downloadImages(urls: urls) { data, images,error in
            
            
                var imagesData = [Data]()
            
            var UIImages = [UIImage]()
                
                for picture in images{
                    
                    let image = UIImage(data: picture)
                    
                    UIImages.append(image!)
                    
                imagesData.append(picture)
                    
                imagesDataDisc.setObject(imagesData as NSArray, forKey: (id) as NSString)
                    
                }
            
            
            completion(UIImages)

        }
        
     
        }
    
    
    
    
    
    
}

struct mediaTableViewCellViewModel{
    
    
    
    //viewmodel doesnt depend on view
    
  //  let bookmarksViewModel = BookmarksViewModel()
    
    var savedTweets = [String:saveTweetData]()
    
    
    let networker = NetworkManager.shared
    
    
    //receives data from BookmarksVc that listens to ntoifc from bookmarksVM
    //data is received from BookmarksVc through cell.feedTableViewCellViewModel.tweetImagesData
    var tweetImagesData: [Media]? = []
    
   
 /*   let coreDataManager: CoreDataManagerProtocol

        init(coreDataManager: CoreDataManagerProtocol) { // "initializer based" injection
            self.coreDataManager = coreDataManager
        }
    */
    
    
    func saveToFolder(post: Tweet,type: String, urls: [String],folderName: String ){
        
      
        
        //save post to Core Data with Unique ID
      //  CoreDataManager.addTweetToFolder(folderId, post, type, urls)
        
        CoreDataManager.shared.addTweetToFolder(folderName, post, type, urls)
        
        /*
      if(CoreDataManager.defaultClass != "localTweets"){
        
        CoreDataManager.shared = CoreDataManager(modelName: "localTweets")
            CoreDataManager.defaultClass = "localTweets"
            
            CoreDataManager.shared.load(completion: nil)
            
            
        }
        
       
        
        CoreDataManager.shared = CoreDataManager(modelName: "MyFolders")
            CoreDataManager.defaultClass = "MyFolders"
            
            CoreDataManager.shared.load(completion: nil)
       */
     
        
    }
    
    
    
    
    
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
    
    func loadVideoImage(){
        
    }
    
    func retrieveMultipleImages(urls: [String], completion: @escaping ([Data]?) -> ()){
        
        
        //pass in urls and result of complettion
        networker.downloadImages(urls: urls) { data, images,error in
            
            completion(images)

        }
        
     
        }
    
    //text: String?
    //id: String
    //media: [String]?
    
}



class MediaTableViewCell: UITableViewCell {
    
  

    

    var mainStack: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.distribution = .fill
        stackview.spacing = 16
        
        
        
       
        return stackview
        
    }()

    var imagesView: UIView = {
        let imagesView = UIView()
      
        imagesView.clipsToBounds = true
        imagesView.layer.cornerRadius = 8
        
        return imagesView
        
    }()

    var menuBtn: UIButton = {
        let button = UIButton()
        
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        
        button.setImage(UIImage(systemName: "ellipsis"), for:.normal)
            
        return button
        
    }()

    var imagesStack: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.distribution = .fillEqually
        stackview.spacing = 2
        //stackview.layer.masksToBounds = true
     
       
        return stackview
        
    }()

    var imagesStackViewL: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.distribution = .fillEqually
        stackview.spacing = 2
        
        

       
        return stackview
        
    }()
    
    

    var imagesStackViewR: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.distribution = .fill
        stackview.spacing = 2
        
     
       
        return stackview
        
    }()

    var image1: UIImageView = {
        let image = UIImageView()
       
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        
     //   image.layer.masksToBounds = true

    //
        return image
    }()

    var image2: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        
        image.clipsToBounds = true
        return image
    }()

    var image3: UIImageView = {
        let image = UIImageView()
       
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()

    var image4: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        
        image.clipsToBounds = true
        return image
    }()

    var userImgView: UIImageView = {
        let myimage = UIImageView()
        myimage.contentMode = .scaleAspectFill
        
        myimage.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        myimage.layer.cornerRadius =   myimage.frame.size.width / 2
        myimage.clipsToBounds = true
        return myimage
    }()

    var nameLabel: UILabel = {
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
    
    var playButton: UIButton = {
        let button = UIButton(type: .custom)
        button.clipsToBounds = true
        
        button.setImage(UIImage(named: "play.png"), for: .normal)
        


        //3
     //   button.frame = CGRect(x: buttonX, y: buttonY, width: buttonWidth, height: buttonHeight)
        
        return button
    }()

    //key of post mapped to keys of images attached
   var xImagesDic = [String: [String]]()
    
    //key of post mapped to data of images attached
   // var imagesDataDisc = NSCache [String: [Data]]()
    
    var imagesDataDisc = NSCache<NSString, NSArray>()


    func addViewsToimageStackL(){
        imagesStackViewL.addArrangedSubview(image1)
        imagesStackViewL.addArrangedSubview(image3)
    }

    func addViewsToimageStackR(){
        imagesStackViewR.addArrangedSubview(image2)
        imagesStackViewR.addArrangedSubview(image4)
    }

    func addViewsToImagesStack(){
        imagesStack.addArrangedSubview(imagesStackViewL)
        imagesStack.addArrangedSubview(imagesStackViewR)
    }

    func addViewsToMainStack(){
        mainStack.addArrangedSubview(postTextLabel)
        
     //   mainStack.addArrangedSubview(imagesView)

        
    }


    /* override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    // setupConstrains()
    }*/

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        Images.append(image1)
        Images.append(image2)
        Images.append(image3)
        Images.append(image4)
        
        image1.isHidden = true
        image2.isHidden = true
        image3.isHidden = true
        image4.isHidden = true
        
        
        
        menuBtn.addTarget(self, action: #selector(didTapMenu), for: .touchUpInside)
        
        
        playButton.isHidden = true
        
        setupConstrains()
        
        
        
    }
    
    
    @objc func didTapMenu(sender: UIButton){
        
        menuButtonAction?()
        
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var viewModel = mediaTableViewCellViewModel()
    
    
    
    
    
    var menuButtonAction : (() -> ())?

    var Images = [UIImageView?]()

    var representedIdentifier = ""

    static let identifier = "MediaTableViewCell"
    
    
    //using data from view MOdel to load views
    func loadSavedTweet(_ savedTweetViewModel: savedTweetsMediaViewModel){
        
        postTextLabel.text = savedTweetViewModel.posttext
        
        image1.image = nil
        
       
        
        let postIdentifier = savedTweetViewModel.id
        
         representedIdentifier = postIdentifier
        
        //if cell id == post.id
        //cell hasnt bn recycled
        
        if(representedIdentifier == postIdentifier){
        if(savedTweetViewModel.type == "video"){
             
             playButton.isHidden = false
            
             imagesView.isHidden = false
             imagesView.layer.cornerRadius = 8
             imagesStackViewR.isHidden = true
             image1.isHidden = false
       
            
            savedTweetViewModel.LoadImage{ downloadedImage in
                if let image = downloadedImage{
                    self.image1.image = image
                }
                
            }
            
            
        }
            
            if(savedTweetViewModel.type == "photo"){
                  
                  playButton.isHidden = true
                
               
                
                
                let savedTweetUrls = savedTweetViewModel.urls ?? []
                
                if(savedTweetUrls.count == 1){
                
                 imagesView.isHidden = false
                 imagesView.layer.cornerRadius = 8
                 imagesStackViewR.isHidden = true
                 image1.isHidden = false
                    
                    savedTweetViewModel.LoadImage{ downloadedImage in
                        if let image = downloadedImage{
                            self.image1.image = image
                        }
                        
                    }
                    
                    
                }
                
                if(savedTweetUrls.count > 1){
                    
                    imagesStackViewR.isHidden = false
                   
                    imagesView.isHidden = false
                    
                    savedTweetViewModel.LoadImages{ downloadedImages in
                        if let images = downloadedImages{
                            var i = 0
                            
                            for image in images{
                                
                            self.Images[i]?.image = nil
                            self.Images[i]?.isHidden = false
                        
                            self.imagesView.layer.cornerRadius = 8
                        
                            self.Images[i]?.image = image
                            
                            
                        i = i + 1
                            }
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
        
        
        
        
      /*
       
       var Imageurl = ""
       
       if(savedTweetViewModel.type == "video"){
            
            playButton.isHidden = false
           
            imagesView.isHidden = false
            imagesView.layer.cornerRadius = 8
            imagesStackViewR.isHidden = true
            image1.isHidden = false
           
           
            
            Imageurl = savedTweetViewModel.urls?[0] ?? ""
            
            if let imageData = imagesDataDisc.object(forKey: (savedTweetViewModel.id) as NSString){
                
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
                    //image from API
                    let image = UIImage(data: image_data)
                    
                    //append image in array because we want to make this function usable for photos
                    var imagesData = [Data]()
                    imagesData.append(image_data)
                    
                    //checking if image is appended to right cell
                    
                    if( self.representedIdentifier == representedCellIdentifier){
                        DispatchQueue.main.async {
                        self.image1.image = image
                            
                            //append image to local cache
                            self.imagesDataDisc.setObject(imagesData as NSArray, forKey: (savedTweetViewModel.id) as NSString)
                            
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
            
        }*/
        
     /*   if(savedTweetViewModel.type == "photo"){
            
            playButton.isHidden = true
            
            var imageUrls = [String]()
            Imageurl = savedTweetViewModel.urls?[0] ?? ""
            
            
            
            for image in savedTweetViewModel.urls ?? [] {
                imageUrls.append(image)
            }
            
            var savedTweetUrls = savedTweetViewModel.urls ?? []
          
            
            
            if(savedTweetUrls.count == 1){
            
             imagesView.isHidden = false
             imagesView.layer.cornerRadius = 8
             imagesStackViewR.isHidden = true
             image1.isHidden = false
            
             image1.image = nil
                
                if let imageData = imagesDataDisc.object(forKey: (savedTweetViewModel.id) as NSString){
                    
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
                                    
                                    self.imagesDataDisc.setObject(imagesData as NSArray, forKey: (savedTweetViewModel.id) as NSString)
                                    
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
            
            if(savedTweetUrls.count > 1){
                 imagesStackViewR.isHidden = false
                
                 imagesView.isHidden = false
                
                if let imagesData = imagesDataDisc.object(forKey: (savedTweetViewModel.id) as NSString){
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
                                    
                                    self.imagesDataDisc.setObject(imagesData as NSArray, forKey: (savedTweetViewModel.id) as NSString)
                                    
                               // self.imagesDataDisc[(feedposts?.id)!] = imagesData
                                
                                i = i + 1
                                }
                            }
                        }
                        }
                    }
                    
                 
            }
            }
            
        }*/
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
                 
                 imagesStackViewR.isHidden = true
                 image1.isHidden = false
                
                 image1.image = nil
                
                // playButton.isHidden = false
                
                Imageurl = imageDetatils[0].preview_image_url ?? ""
                
                var savedTweetImageUrls = [String]()
                
                savedTweetImageUrls.append(Imageurl)
                
                let savedTweet = saveTweetData(id: UUID(), text: (feedposts?.text) ?? ""  , type: imageDetatils[0].type, key: (feedposts?.id) ?? "" , media: savedTweetImageUrls)
                
                
                viewModel.savedTweets[(feedposts?.id)!] = savedTweet
                
               
                
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
                
                playButton.isHidden = true
                
                var imageUrls = [String]()
                Imageurl = imageDetatils[0].url ?? ""
                
                for image in imageDetatils {
                    imageUrls.append(image.url ?? "")
                }
                
                let savedTweet = saveTweetData(id: UUID(), text: (feedposts?.text) ?? ""  , type: imageDetatils[0].type, key: (feedposts?.id) ?? "" , media: imageUrls)
                
                
                viewModel.savedTweets[(feedposts?.id)!] = savedTweet
                
                
                
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
                                
                                    
                                
                                    self.Images[i]?.image = image
                                    self.imagesView.layer.cornerRadius = 8
                                    
                                
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
                                    
                                        
                                    
                                        self.Images[i]?.image = image
                                        
                                        self.imagesView.layer.cornerRadius = 8
                                        
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
    
    func setupConstrains(){
        
        contentView.addSubview(mainStack)
        contentView.addSubview(userImgView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(menuBtn)
        contentView.addSubview(imagesView)
        contentView.addSubview(imagesStack)
        contentView.addSubview(playButton)
        
        
        addViewsToMainStack()
        addViewsToImagesStack()
        addViewsToimageStackL()
        addViewsToimageStackR()
        
        
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        userImgView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        menuBtn.translatesAutoresizingMaskIntoConstraints = false
        playButton.translatesAutoresizingMaskIntoConstraints = false
        imagesView.translatesAutoresizingMaskIntoConstraints = false
        imagesStack.translatesAutoresizingMaskIntoConstraints = false
        
        userImgView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        userImgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        userImgView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        userImgView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        menuBtn.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -32).isActive = true
        menuBtn.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        menuBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        menuBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        nameLabel.leftAnchor.constraint(equalTo: userImgView.rightAnchor, constant: 8).isActive = true
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        
        mainStack.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        mainStack.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor, constant:-32).isActive = true
        mainStack.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16).isActive = true
        mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        
      /*  imagesView.setContentHuggingPriority(UILayoutPriority(240), for: .vertical)
        postLabel.setContentHuggingPriority(UILayoutPriority(100), for: .vertical)
        mainStack.setContentHuggingPriority(UILayoutPriority(250), for: .vertical)*/
       
        imagesView.leadingAnchor.constraint(equalTo: imagesStack.leadingAnchor).isActive = true
        imagesView.trailingAnchor.constraint(equalTo: imagesStack.trailingAnchor).isActive = true
        imagesView.topAnchor.constraint(equalTo: imagesStack.topAnchor).isActive = true
        imagesView.bottomAnchor.constraint(equalTo: imagesStack.bottomAnchor).isActive = true
        
        imagesView.heightAnchor.constraint(equalTo: imagesView.widthAnchor, multiplier: 2/3).isActive = true
        
        
        playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
         playButton.centerXAnchor.constraint(equalTo: imagesView.centerXAnchor).isActive = true
         playButton.centerYAnchor.constraint(equalTo: imagesView.centerYAnchor).isActive = true
   
        
        
       // playButton.center = imagesView.convert(imagesView.center, from:imagesView.superview)
        
       
        
        mainStack.addArrangedSubview(imagesView)
        
        imagesStackViewL.leadingAnchor.constraint(equalTo: image1.leadingAnchor).isActive = true
        imagesStackViewL.widthAnchor.constraint(equalTo: image1.widthAnchor).isActive = true
        imagesStackViewL.topAnchor.constraint(equalTo: image1.topAnchor).isActive = true
       
        imagesStackViewR.leadingAnchor.constraint(equalTo: image2.leadingAnchor).isActive = true
        imagesStackViewR.widthAnchor.constraint(equalTo: image2.widthAnchor).isActive = true
        imagesStackViewR.topAnchor.constraint(equalTo: image2.topAnchor).isActive = true
        imagesStackViewR.trailingAnchor.constraint(equalTo: image2.trailingAnchor).isActive = true
        
        image4.heightAnchor.constraint(equalTo: image2.heightAnchor).isActive = true
    
      
        
        
    }
    

}
