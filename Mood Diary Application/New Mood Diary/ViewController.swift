//
//  ViewController.swift
//  New Mood Diary
//
//  Created by 胡远 on 2016/12/3.
//  Copyright © 2016年 Wentaile Wu. All rights reserved.
//

import UIKit
import CoreData

var filteredItems = [Item]()

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    var items: [Item] = []
    var searchController = UISearchController()
    var resultsController = UITableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.resultsController.tableView.dataSource = self
        self.resultsController.tableView.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
/*
        self.searchController = ({
            searchController.dimsBackgroundDuringPresentation = false
            searchController.searchBar.sizeToFit()
            searchController.searchBar.barStyle = UIBarStyle.black
            searchController.searchBar.barTintColor = UIColor.white
            searchController.searchBar.backgroundColor = UIColor.clear
            self.tableView.tableHeaderView = searchController.searchBar
            return searchController
        })()
 */
        self.searchController = UISearchController(searchResultsController: self.resultsController)
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.searchController.searchResultsUpdater = self

        tableView.dataSource = self
        tableView.delegate = self
        // add new stuff
        self.tableView.reloadData()


    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
/*
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.title!
        cell.detailTextLabel?.text = item.content!
        //cell.imageView?.image = UIImage(data: item.image as! Data)
        // cell.imageView?.image = [UIImageimageWithData: self.item.image]
        if let imageCheck = item.image {
            cell.imageView?.image = UIImage(data: imageCheck as Data)
        } else {
            print("Default image")
        }
        return cell
 */
/*
        if tableView == self.tableView {
            let item = items[indexPath.row]
            cell.textLabel?.text = item.title!
            cell.detailTextLabel?.text = item.content!
            //cell.imageView?.image = UIImage(data: item.image as! Data)
            // cell.imageView?.image = [UIImageimageWithData: self.item.image]
            if let imageCheck = item.image {
                cell.imageView?.image = UIImage(data: imageCheck as Data)
            } else {
                print("Default image")
            }

        } else {
            //cell.textLabel?.text = filteredItems[indexPath.row]
            print(filteredItems[indexPath.row])
        }
        return cell
*/
        let item: Item
        if searchController.isActive && searchController.searchBar.text != "" {
            item = filteredItems[indexPath.row]
        } else {
            item = items[indexPath.row]
        }
        cell.textLabel?.text = item.title!
        cell.detailTextLabel?.text = item.content!
        if let imageCheck = item.image {
            cell.imageView?.image = UIImage(data: imageCheck as Data)
        } else {
            print("Default image")
        }
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // get the data from core data
        getData()
        // reload the table view
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredItems.count
        } else {
            return items.count
        }
    }
    
    func getData() {
       let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            items = try context.fetch(Item.fetchRequest())
        }
        catch {
            print("Fetching Failed")
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
        if editingStyle == .delete{
            let item = items[indexPath.row]
            context.delete(item)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            do {
               items = try context.fetch(Item.fetchRequest())
            } catch {
             print("")
            }
        }
        tableView.reloadData()

    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "ViewContent", sender: self)
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if searchController.isActive && searchController.searchBar.text != "" {
            if segue.identifier == "ViewContent" {
                let row = self.resultsController.tableView.indexPathForSelectedRow?.row
                let contentDetail = segue.destination as! ContentDetailsViewController
                contentDetail.item = items[row!]
            }
            searchController.isActive = false

        } else {
            if segue.identifier == "ViewContent" {
                let row = self.tableView.indexPathForSelectedRow?.row
                let contentDetail = segue.destination as! ContentDetailsViewController
                contentDetail.item = items[row!]

            }
            //itemController.item = item
        }
     }
    /*
    func updateSearchResults(for searchController: UISearchController) {
        //print(searchController.searchBar.text!)

        filteredItems.removeAll(keepingCapacity: false)
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = ( filteredItems as NSArray).filtered(using: searchPredicate)
        filteredItems = array as! [String]
        //self.tableView.reloadData()

        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
  */
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredItems = items.filter { item in
            return ((item.title?.lowercased())!.contains(searchText.lowercased())) }
        self.resultsController.tableView.reloadData()
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}

