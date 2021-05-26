//
//  FavouriteReceipesViewController.swift
//  Foody CookBook
//
//  Created by ESHITA on 26/05/21.
//

import Foundation
import UIKit

class FavouriteReceipesViewController: UIViewController {
    
    @IBOutlet weak var savedReceipeTableView:UITableView!
    var savedReceipeList = ReceipesList()
    let mealService = TheMealDBWebService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("FavouriteReceipesViewController")
        self.savedReceipeTableView.delegate = self
        self.savedReceipeTableView.dataSource = self
        updateSavedView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateSavedView()
    }
    
    func updateSavedView() {
        self.savedReceipeList = self.mealService.retriveSavedReceipes()
        print(self.savedReceipeList)
        DispatchQueue.main.async {
            print("Table refreshed")
            self.savedReceipeTableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "savedToDetailViewSegue" {
            print("prepare details")
            guard let navC = segue.destination as? UINavigationController,
                  let mealDetailVC = navC.viewControllers.first as? MealDetailsViewController,
                  let index = sender as? Int else {
                fatalError("Error performing segue!!!")
            }
            mealDetailVC.mealId = self.savedReceipeList.meals[index].id
        }
    }
}

extension FavouriteReceipesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.savedReceipeList.meals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.savedReceipeTableView.dequeueReusableCell(withIdentifier: "savedCustomCellIdentifier") as! ReceipeCustomCell
        cell.populateSavedReceipeCell(receipe: self.savedReceipeList.meals[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "savedToDetailViewSegue", sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 150
   }
}

