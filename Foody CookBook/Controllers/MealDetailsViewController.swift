//
//  MealDetailsViewController.swift
//  Foody CookBook
//
//  Created by ESHITA on 26/05/21.
//

import Foundation
import UIKit

class MealDetailsViewController: UIViewController {
    
    var mealId:String = ""
    
    @IBOutlet weak var detailMealTitleLbl: UILabel!
    @IBOutlet weak var detailMealImageView: UIImageView!
    @IBOutlet weak var detailMealCategoryLbl: UILabel!
    @IBOutlet weak var detailMealCusineLbl: UILabel!
    @IBOutlet weak var detailMealInstructionTxtView: UITextView!
    
    var receipe = ReceipesList()
    let mealService = TheMealDBWebService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MealDetailsViewController")
        print(self.mealId)
        
        updateDetailView()
    }
    
    func updateDetailView(){
        
        self.mealService.getReceipeDetail(mealID: self.mealId) { mealItem in
            if let mealItem = mealItem {
                self.receipe.meals = mealItem
            }
            print(self.receipe.meals)
            DispatchQueue.main.async {
                self.detailMealTitleLbl.text = self.receipe.meals[0].mealTitle
                self.detailMealInstructionTxtView.text = self.receipe.meals[0].mealInstructions
                self.detailMealCategoryLbl.text = self.receipe.meals[0].mealCategory
                self.detailMealCusineLbl.text = self.receipe.meals[0].mealCusine
                guard let mealImgUrl = URL(string: self.receipe.meals[0].mealImage) else{
                    print("Image Not Avaiable!!!")
                    return
                }
                self.mealService.downloadImage(from:mealImgUrl , to: self.detailMealImageView)
                self.detailMealInstructionTxtView.font = UIFont(name: Theme.labelFontName, size: 20)
                self.detailMealTitleLbl.font = UIFont(name: Theme.labelFontNameBold, size: 25)
                self.detailMealCategoryLbl.font = UIFont(name: Theme.labelFontNameBold, size: 20)
                self.detailMealCusineLbl.font = UIFont(name: Theme.labelFontNameBold, size: 20)
            }
            
        }
        
    }
    
    @IBAction func backBtnPressed() {
        self.dismiss(animated: true, completion: nil)
    }
}

