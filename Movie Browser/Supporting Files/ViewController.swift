//
//  ViewController.swift
//  Movie Browser
//
//  Created by Veerendra Pratap Singh on 19/09/19.
//  Copyright © 2019 Veerendra Pratap Singh. All rights reserved.
//

import UIKit

class ViewController {
    

    static let homeAPi = "https://api.themoviedb.org/3/movie/now_playing?api_key=0245fc01c7c2d84a3d8e89887481ad6a"
    static let search = "https://api.themoviedb.org/3/search/movie?api_key=0245fc01c7c2d84a3d8e89887481ad6a&query=aveng&page=1&include_adult=false"
    static let mostPopular = "https://api.themoviedb.org/3/movie/popular?api_key=0245fc01c7c2d84a3d8e89887481ad6a"
    static let mostRated = "https://api.themoviedb.org/3/movie/top_rated?api_key=0245fc01c7c2d84a3d8e89887481ad6a"
    static let movieMainURL = "https://api.themoviedb.org/3/movie/"
    static let movieLastURL = "?api_key=0245fc01c7c2d84a3d8e89887481ad6a"
    
    


}

extension UIViewController {
    func alert(title : String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func applyShadowOnView(_ view: UIView) {
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 2
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.5
    }
    
}

