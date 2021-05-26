//
//  MealModel.swift
//  Foody CookBook
//
//  Created by ESHITA on 26/05/21.
//

import Foundation


struct ReceipesList : Decodable {
    var  meals: [MealModel]
    init(){
        self.meals = []
    }
}

struct MealModel: Decodable {
    var id:String
    var mealTitle:String
    var mealCategory : String
    var mealCusine: String
    var mealImage:String
    var mealInstructions:String
    
    private enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case mealTitle = "strMeal"
        case mealCategory = "strCategory"
        case mealCusine = "strArea"
        case mealImage = "strMealThumb"
        case mealInstructions = "strInstructions"
    }
    
    init(){
        self.id = ""
        self.mealTitle = ""
        self.mealCategory = ""
        self.mealCusine = ""
        self.mealImage = ""
        self.mealInstructions = ""
    }
    
}
