//
//  SelectBookmarkFolderVC.swift
//  TwitterBookmarks
//
//  Created by mac on 14/07/2022.
//

import UIKit
import CoreData

class SelectBookmarkFolderVC: UIViewController,UITableViewDelegate,UITableViewDataSource,CustomPresentable {

    private let tableview: UITableView = {
        let tableview = UITableView()
        tableview.register(FoldersTableViewCell.self, forCellReuseIdentifier: FoldersTableViewCell.identifier)
        
        
        return tableview
        
    }()
    
    private var fetchedResultsController: NSFetchedResultsController<TweetFolder>!
    
    var addToFolderCallback : ((String) -> ())?
    
    var transitionManager: UIViewControllerTransitioningDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableview)
        
        tableview.delegate = self
        tableview.dataSource = self
      
        
        
        tableview.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .systemBackground
        
        tableview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        tableview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 8).isActive = true
        tableview.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        tableview.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 8).isActive = true
        
        tableview.heightAnchor.constraint(equalToConstant: 600).isActive = true
        
        let screenHeight = UIScreen.main.bounds.height
        
        tableview.heightAnchor.constraint(equalToConstant: screenHeight * 0.5).isActive = true
        
        
      /*  tableview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableview.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true*/
        setupFetchedResultsController()
        
        updatePresentationLayout(animated: true)
       
        

        // Do any additional setup after loading the view.
    }
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
       // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController.sections?.count ?? 1
   }
    
    func setupFetchedResultsController(){
        fetchedResultsController = CoreDataManager.shared.createFoldersFetchedResultsController()
        
        fetchedResultsController.delegate = self
        
        try? fetchedResultsController.performFetch()
    }
    
    func  tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let folder = fetchedResultsController.object(at: indexPath)
        
        addToFolderCallback?(folder.name!)
        
        self.dismiss(animated: true, completion: nil)
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // #warning Incomplete implementation, return the number of rows
        
        let folders = fetchedResultsController.sections![section]
        
       return folders.numberOfObjects
   }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "FoldersTableViewCell", for: indexPath)
                as! FoldersTableViewCell
        
        let folder = fetchedResultsController.object(at: indexPath)
        
        cell.bookmarkLabel.text = folder.name
        
        return cell
        
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
extension SelectBookmarkFolderVC: NSFetchedResultsControllerDelegate{
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
            
            
            tableview.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            
           
            tableview.deleteRows(at: [indexPath!], with: .automatic)
        case.update:
            
            
            tableview.reloadRows(at: [indexPath!], with: .automatic)
            
        default: tableview.reloadData()
        }
    }
}
