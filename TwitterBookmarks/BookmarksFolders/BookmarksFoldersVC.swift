//
//  BookmarksFoldersVC.swift
//  TwitterBookmarks
//
//  Created by mac on 14/07/2022.
//

import UIKit
import CoreData


class BookmarksFoldersVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var FAB = UIButton(type: .custom)
    
    
    private let tableview: UITableView = {
        let tableview = UITableView()
        tableview.register(FoldersTableViewCell.self, forCellReuseIdentifier: FoldersTableViewCell.identifier)
        
        
        return tableview
        
    }()
    
    private var fetchedResultsController: NSFetchedResultsController<TweetFolder>!
    
    struct Note{
        let name:String
        let id:UUID
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Twitter Bookmarks Folders"
        
        _ = UINavigationController(rootViewController: BookmarksFoldersVC())
       
        tableview.delegate = self
        tableview.dataSource = self
        view.addSubview(tableview)
        
        tableview.translatesAutoresizingMaskIntoConstraints = false
        
        
        tableview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        tableview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 8).isActive = true
        tableview.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 8).isActive = true
        tableview.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 8).isActive = true
        
        
        
        setupFetchedResultsController()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        FAB.removeFromSuperview()
        
  
       
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
        
        floatingButton()
        
    }
    
    func floatingButton(){
      //  let trailing = UIScreen.main.bounds.width - 80
        //let bottom = UIScreen.main.bounds.height - 180
        
        //FAB.frame = CGRect(x: trailing, y: bottom, width: 60, height: 60)
        
       
        
       // FAB.addTarget(self,action: #selector(DestinationVC.buttonTapped), for: .touchUpInside)
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }){
            window.addSubview(FAB)
            
            
            let screenSize: CGRect = UIScreen.main.bounds
            print("screensize \(screenSize)")
            
            FAB.translatesAutoresizingMaskIntoConstraints = false
            

          //  FAB.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            FAB.widthAnchor.constraint(equalToConstant: 60).isActive = true
            FAB.heightAnchor.constraint(equalToConstant: 60).isActive = true
        //    FAB.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
            FAB.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -20).isActive = true
            FAB.bottomAnchor.constraint(equalTo: window.bottomAnchor, constant: -100).isActive = true
            
            FAB.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
            
            FAB.tintColor = UIColor.white
            
          
            
            FAB.imageView?.contentMode = .scaleAspectFit
            FAB.imageEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
            
            
            FAB.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
            FAB.clipsToBounds = true
            FAB.layer.cornerRadius = 30
            FAB.layer.borderColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
            FAB.layer.borderWidth = 3.0
            
            FAB.addTarget(self, action: #selector(didTapFab), for: .touchUpInside)
            
        }
    }
    
    @objc func didTapFab(sender: UIButton){
        
        let alert = UIAlertController(title: "Creating Bookmark Folder", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Enter name of bookmark folder..."
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            if let report = alert.textFields?.first?.text {
               
                
                self.createFolder(report)
                
            }
        }))
        
       present(alert, animated: true)
        
            
        
        
    }
    
   
    
    func setupFetchedResultsController(){
        fetchedResultsController = CoreDataManager.shared.createFoldersFetchedResultsController()
        
       
        
        fetchedResultsController.delegate = self
        
        try? fetchedResultsController.performFetch()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
       // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController.sections?.count ?? 1
   }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // #warning Incomplete implementation, return the number of rows
        
        let folders = fetchedResultsController.sections![section]
        
       return folders.numberOfObjects + 1
   }
    
    private func createFolder(_ folderName: String){
        _ = CoreDataManager.shared.createFolder(folderName)
      //  _ = CoreDataManager(modelName: "MyFolders").createFolder(folderName)
    }
    
    
    
    private func deleteFolder(_ folder: TweetFolder) {
        
        CoreDataManager.shared.deleteFolder(folder)
      
    }
    
    func  tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(indexPath.row == 0){
            
            
            let myVC = BookmarksVC()
            
            myVC.VCtitle = "All Bookmarks"
            
            self.navigationController?.pushViewController(myVC, animated: true)
            
            
          //  navVC.pushViewController(loadVC, animated: true)
        }else{
            let IndexPath = IndexPath(item: indexPath.row - 1, section: 0)
            
            let folder = fetchedResultsController.object(at: IndexPath )
            
            let myVC = SavedBookmarksVC()
            
            myVC.VCtitle = folder.name ?? ""
            myVC.folderName = folder.name ?? ""
            
            self.navigationController?.pushViewController(myVC, animated: true)
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "FoldersTableViewCell", for: indexPath)
                as! FoldersTableViewCell
        
        
        if(indexPath.row != 0){
            
            let IndexPath = IndexPath(item: indexPath.row - 1, section: 0)
            
            let folder = fetchedResultsController.object(at: IndexPath )
            
            cell.bookmarkLabel.text = folder.name
        }else{
            
            cell.bookmarkView.backgroundColor = #colorLiteral(red: 0, green: 0.6711869624, blue: 1, alpha: 1)
            cell.bookmarkView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.bookmarkView.layer.borderWidth = 3.0
            
            cell.bkmImage.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            let folder = Note(name: "All Bookmarks", id: UUID())
            
            
            cell.bookmarkLabel.text = folder.name
            
            cell.bookmarkLabel.textColor = #colorLiteral(red: 0, green: 0.6711869624, blue: 1, alpha: 1)
        }
        
        
        
        return cell
        
    }
        
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        //disable editing for first row
        if(editingStyle == .delete){
           
            let IndexPath = IndexPath(item: indexPath.row - 1, section: 0)
            let folder = fetchedResultsController.object(at: IndexPath)
            deleteFolder(folder)
            }
        
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
extension BookmarksFoldersVC: NSFetchedResultsControllerDelegate{
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableview.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableview.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type{
        case .insert:
            
            //aranges items alphabetically, Capitals first in alphabetical order, then smaller alphabets
            
            let NewIndexPath = IndexPath(item: newIndexPath!.row + 1, section: 0)
            tableview.insertRows(at: [NewIndexPath], with: .automatic)
            
            //tableview.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            
            let IndexPath = IndexPath(item: indexPath!.row + 1, section: 0)
            
            tableview.deleteRows(at: [IndexPath], with: .automatic)
            //tableview.deleteRows(at: [indexPath!], with: .automatic)
        case.update:
            
            let IndexPath = IndexPath(item: indexPath!.row + 1, section: 0)
            tableview.reloadRows(at: [IndexPath], with: .automatic)
           // tableview.reloadRows(at: [indexPath!], with: .automatic)
            
        default: tableview.reloadData()
        }
    }
}
