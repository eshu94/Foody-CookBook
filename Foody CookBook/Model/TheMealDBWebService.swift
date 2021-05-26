//
//  TheMealDBWebService.swift
//  Foody CookBook
//
//  Created by ESHITA on 26/05/21.
//

import Foundation
import Foundation
import UIKit
import CoreData

class TheMealDBWebService {
  
    fileprivate func mealDBApi(_ url: URL, _ completion: @escaping (([MealModel]?) -> Void)) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            let receipesList = try? JSONDecoder().decode(ReceipesList.self, from: data)
            if let receipesList = receipesList {
                completion(receipesList.meals)
            }else {
                completion(nil)
            }
        }.resume()
    }
    
    // MARK:- Function to get random meals for Home Screen
    func getRandomMeals(completion: @escaping (([MealModel]?) -> Void)) {
        print("getRandomMeals: Start")
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/random.php") else {
                   fatalError("URL is not correct")
               }
        
        mealDBApi(url, completion)
        print("getRandomMeals: End")
    }
    
    // MARK:- Function to get searched meals for Searched Screen
    
    func getSearchedReceipes(searchInput:String, completion: @escaping (([MealModel]?) -> Void)) {
        print("getSearchedReceipes: Start")
        let url: URL
        if(searchInput.count == 1){
            //URl to List all meals by first letter
            guard let singleSearchedurl = URL(string: "https://www.themealdb.com/api/json/v1/1/search.php?f=\(searchInput)") else {
                       fatalError("URL is not correct")
                   }
            url = singleSearchedurl
            
        }else {
            guard let nameSearchedUrl = URL(string: "https://www.themealdb.com/api/json/v1/1/search.php?s=\(searchInput)") else {
                       fatalError("URL is not correct")
                   }
            url = nameSearchedUrl
        }
        
        mealDBApi(url, completion)
        print("getSearchedReceipes: End")
    }
    
    // MARK:- Function to save favourite receipe for Saved Screen
    
    func saveSelectedReceipe(selectedReceipe: MealModel) {
        print("saveSelectedReceipe: Start")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let receipeEntity = NSEntityDescription.entity(forEntityName: "Receipes", in: managedContext) else {
            return
        }
        
        let receipe = NSManagedObject(entity: receipeEntity, insertInto: managedContext)
        
        receipe.setValue(selectedReceipe.id, forKey: "mealId")
        receipe.setValue(selectedReceipe.mealTitle, forKey: "mealTitle")
        receipe.setValue(selectedReceipe.mealCategory, forKey: "mealCategory")
        receipe.setValue(selectedReceipe.mealCusine, forKey: "mealCusine")
        receipe.setValue(selectedReceipe.mealImage, forKey: "mealImage")
        receipe.setValue(selectedReceipe.mealInstructions, forKey: "mealInstructions")
        
        do {
            try managedContext.save()
        }catch let error as NSError {
            print("Error saving data.\(error), \(error.userInfo)")
        }
        print("saveSelectedReceipe: End")
    }
    
    func retriveSavedReceipes() -> ReceipesList {
        
        print("retriveSavedReceipes: Start")
        
        var finalResult: ReceipesList = ReceipesList()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Receipes")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            
            for data in result as! [NSManagedObject] {
                var receipeItem = MealModel()
                
                receipeItem.id = data.value(forKey: "mealId") as! String
                receipeItem.mealTitle = data.value(forKey: "mealTitle") as! String
                receipeItem.mealCategory = data.value(forKey: "mealCategory") as! String
                receipeItem.mealCusine = data.value(forKey: "mealCusine") as! String
                receipeItem.mealImage = data.value(forKey: "mealImage") as! String
                receipeItem.mealInstructions = data.value(forKey: "mealInstructions") as! String
        
                finalResult.meals.append(receipeItem)
            }
        }catch let error as NSError {
            print("Error retriving data.\(error), \(error.userInfo)")
        }
        
        print("retriveSavedReceipes: End")
        return finalResult
        
    }
    
    // MARK:- Function to get meal details for Details Screen
    
    func getReceipeDetail(mealID:String, completion: @escaping (([MealModel]?) -> Void)) {
        print("getReceipeDetail: Start")
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(mealID)") else {
               fatalError("URL is not correct")
        }
        mealDBApi(url, completion)
        print("getReceipeDetail: End")
    }
    
    // MARK:- Function to get meal Image for All Screens
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    func downloadImage(from url: URL, to uiImageView: UIImageView) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print("Download Finished")
            DispatchQueue.main.async() {
                uiImageView.image = UIImage(data: data)
            }
        }
    }
    
}
