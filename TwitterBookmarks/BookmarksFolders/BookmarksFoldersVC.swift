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
    @IBOutlet weak var tableview: UITableView!
    
    private var fetchedResultsController: NSFetchedResultsController<Folder>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.delegate = self
        tableview.dataSource = self
        
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
        
       return folders.numberOfObjects
   }
    
    private func createFolder(_ folderName: String){
        _ = CoreDataManager.shared.createFolder(folderName)
      
    }
    
    
    
    private func deleteFolder(_ folder: Folder) {
        
        CoreDataManager.shared.deleteFolder(folder)
      
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "FoldersTableViewCell", for: indexPath)
                as! FoldersTableViewCell
        
        let folder = fetchedResultsController.object(at: indexPath)
        
        cell.bookmarkLabel.text = folder.name
        
        return cell
        
    }
        
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            
            let folder = fetchedResultsController.object(at: indexPath)
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
            tableview.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableview.deleteRows(at: [indexPath!], with: .automatic)
        case.update:
            tableview.reloadRows(at: [indexPath!], with: .automatic)
            
        default: tableview.reloadData()
        }
    }
}
