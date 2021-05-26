//
//  HomeViewController.swift
//  Foody CookBook
//
//  Created by ESHITA on 26/05/21.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var homeView:UIView!
    @IBOutlet weak var homeMealTitleLbl: UILabel!
    @IBOutlet weak var homeMealImageView: UIImageView!
    @IBOutlet weak var homeMealCategoryLbl: UILabel!
    @IBOutlet weak var homeMealCusineLbl: UILabel!
    var receipe = ReceipesList()
    let mealService = TheMealDBWebService()
    let loadingVC = LoadingViewController()
    var isDataUpdated:Bool = false

    override func viewDidLoad() {
            super.viewDidLoad()
        print("HomeViewController")
       self.loadingVC.modalPresentationStyle = .overCurrentContext
        self.loadingVC.modalTransitionStyle = .crossDissolve
        present(loadingVC, animated: true, completion: nil)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.tapAction))
        self.homeView.addGestureRecognizer(gesture)
            self.mealService.getRandomMeals() { receipeItem in
                if let receipeItem = receipeItem {
                    self.receipe.meals = receipeItem
                }
                self.updateHomeView()
            }
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
            self.loadingVC.dismiss(animated: true, completion: nil)
        }
    }
    
    fileprivate func updateHomeView() {
        DispatchQueue.main.async {
            print(self.receipe.meals)
            self.homeMealTitleLbl?.text = self.receipe.meals[0].mealTitle
            self.homeMealCusineLbl?.text = self.receipe.meals[0].mealCusine
            self.homeMealCategoryLbl?.text = self.receipe.meals[0].mealCategory
            guard let mealImgUrl = URL(string: self.receipe.meals[0].mealImage) else{
                print("Image Not Avaiable!!!")
                return
            }
            self.mealService.downloadImage(from:mealImgUrl , to: self.homeMealImageView)
            
            self.homeMealTitleLbl.font = UIFont(name: Theme.labelFontNameBold, size: 25)
            self.homeMealCategoryLbl.font = UIFont(name: Theme.labelFontNameBold, size: 25)
            self.homeMealCusineLbl.font = UIFont(name: Theme.labelFontNameBold, size: 25)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeToDetailViewSegue" {
            print("prepare details")
            guard let navC = segue.destination as? UINavigationController,
                  let mealDetailVC = navC.viewControllers.first as? MealDetailsViewController else {
                fatalError("Error performing segue!!!")
            }
           mealDetailVC.mealId = self.receipe.meals[0].id
        }
    }

    @objc func tapAction(sender : UITapGestureRecognizer) {
        print("tapAction")
        performSegue(withIdentifier: "homeToDetailViewSegue", sender: sender)
    }
    
    
}

