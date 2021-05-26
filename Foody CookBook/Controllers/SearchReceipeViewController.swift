//
//  SearchReceipeViewController.swift
//  Foody CookBook
//
//  Created by ESHITA on 26/05/21.
//

import Foundation
import UIKit

class SearchReceipeViewController: UIViewController {
    
    @IBOutlet weak var searchReceipeTableView:UITableView!
    @IBOutlet weak var searchedReceipeTextField:UITextField!
    @IBOutlet weak var noDataLbl:UILabel!
    
    var searchReceipeList = ReceipesList()
    let mealService = TheMealDBWebService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SearchReceipeViewController")
        self.searchReceipeTableView.delegate = self
        self.searchReceipeTableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchToDetailViewSegue" {
            print("prepare details")
            guard let navC = segue.destination as? UINavigationController,
                  let mealDetailVC = navC.viewControllers.first as? MealDetailsViewController,
                  let index = sender as? Int else {
                fatalError("Error performing segue!!!")
            }
            mealDetailVC.mealId = self.searchReceipeList.meals[index].id
        }
    }
    
    fileprivate func updateSearchView() {
        DispatchQueue.main.async {
            print("reload data")
            self.searchReceipeTableView.reloadData()
            
        }
    }
    
    @IBAction func textFieldEditingDidChange(_ sender: Any) {
        if self.searchedReceipeTextField.text!.isEmpty {
            self.searchReceipeList.meals = []
            self.updateSearchView()
        }
    }

    
    fileprivate func updateNoData(for value:String) {
        DispatchQueue.main.async {
            if value == "success" {
                self.noDataLbl.isHidden = true
            }else {
                self.noDataLbl.isHidden = false
            }
        }
    }
    
    @IBAction func searchIconPressed(_ sender:UIButton){
        print("searchIconPressed")
        self.searchedReceipeTextField.textColor = .black
        guard let searchInput = self.searchedReceipeTextField.text else {
            return
        }
        if searchInput.isEmpty {
            let alert = UIAlertController(title: "Enter dish name", message: "Please enter dish name to continue.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            print(searchInput.count)
            self.searchReceipeList.meals = []
            self.updateSearchView()
            self.present(alert, animated: true)
            
        }else {
            self.mealService.getSearchedReceipes(searchInput: searchInput) { mealList in
                if let mealList = mealList {
                    self.searchReceipeList.meals = mealList
                    self.updateNoData(for: "success")
               }else {
                self.updateNoData(for: "fail")
               }
                self.updateSearchView()
           }
        }
    }
}

extension SearchReceipeViewController:  UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchReceipeList.meals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.searchReceipeTableView.dequeueReusableCell(withIdentifier: "searchCustomCellIdentifier") as! ReceipeCustomCell
        cell.populateSearchReceipeCell(receipe: self.searchReceipeList.meals[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "searchToDetailViewSegue", sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {

            if let cell = tableView.cellForRow(at: indexPath) as? ReceipeCustomCell{
                if let spvcell = cell.superview{
                    for svswipe in spvcell.subviews{
                        let typeview = type(of: svswipe.self)
                        if typeview.description() == "UISwipeActionPullView"{
                            svswipe.frame = cell.searchCellView.frame
                        }
                    }
                }
            }
        }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let save = UIContextualAction(style: .normal, title: "Save") { (contextualAction, view, actionPerformed: @escaping (Bool) -> ()) in
          print("save")
            self.mealService.saveSelectedReceipe(selectedReceipe: self.searchReceipeList.meals[indexPath.row])
           actionPerformed(true)
        }
        save.backgroundColor = Theme.label
        save.image = UIImage(systemName: "folder.fill")
        return UISwipeActionsConfiguration(actions: [save])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 150
   }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = Theme.backGround?.withAlphaComponent(1.0)
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = Theme.label
        (view as! UITableViewHeaderFooterView).textLabel?.font = UIFont(name: Theme.labelFontNameBold, size:20)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if( self.searchReceipeList.meals.count == 0){
            return ""
        }else {
            return "Searched:"
        }
    }
    
}


