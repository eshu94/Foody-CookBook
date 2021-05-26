//
//  ReceipeCustomCell.swift
//  Foody CookBook
//
//  Created by ESHITA on 26/05/21.
//

import Foundation
import UIKit

class ReceipeCustomCell:UITableViewCell{
    
    @IBOutlet weak var savedReceipeImageView:UIImageView!
    @IBOutlet weak var savedReceipeTitleLbl:UILabel!
    @IBOutlet weak var savedCellView:UIView!
    
    @IBOutlet weak var searchReceipeImageView:UIImageView!
    @IBOutlet weak var searchReceipeTitleLbl:UILabel!
    @IBOutlet weak var searchCellView:UIView!
    
    let mealService = TheMealDBWebService()
    
    
    func populateSavedReceipeCell(receipe:MealModel) {
        
        updateCell(to: self.savedCellView, titleLable: self.savedReceipeTitleLbl, backgroundImageView: self.savedReceipeImageView, with: receipe)
    }
    
    func populateSearchReceipeCell(receipe:MealModel) {
        
        updateCell(to: self.searchCellView, titleLable: self.searchReceipeTitleLbl, backgroundImageView: self.searchReceipeImageView, with: receipe)
    }
    
    fileprivate func updateCell(to outerView:UIView, titleLable: UILabel, backgroundImageView: UIImageView,with receipe:MealModel){
        
        outerView.addShadowAndRoundedCorner()
        titleLable.text = receipe.mealTitle
        titleLable.font = UIFont(name: Theme.labelFontNameBold, size: 20)
           
           guard let url = URL(string: receipe.mealImage) else{
               print("Image Not Avaiable!!!")
               return
           }
           
           self.mealService.downloadImage(from: url, to: backgroundImageView)
        backgroundImageView.alpha = 0.8
           UIView.animate(withDuration: 1) {
            backgroundImageView.alpha = 0.3
           }
        
    }

    
}

