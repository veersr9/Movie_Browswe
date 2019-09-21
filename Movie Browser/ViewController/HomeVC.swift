//
//  HomeVC.swift
//  Movie Browser
//
//  Created by Veerendra Pratap Singh on 19/09/19.
//  Copyright © 2019 Veerendra Pratap Singh. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import DropDown

class HomeVC: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var txtFldSearch: UITextField!
    @IBOutlet weak var btnSettings: UIButton!
    
    let numberOfCellsPerRow: CGFloat = 2
    var pagination:Int = 1
    var page_number:Int = 1
    var total_pages:Int = 0
    
    var arrayMoviesList = [structMoviesList]()
    struct structMoviesList {
        let image:String
        let original_title:String
        let ids:Int
    }
    
    let settingsdropDown = DropDown()
    lazy var dropDowns: [DropDown] = {
        return [
            self.settingsdropDown,
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDropDowns()
        txtFldSearch.delegate = self
        txtFldSearch.layer.cornerRadius = 15
        MoviesAPI(page: pagination)
        applyShadowOnView(viewSearch)
        // Do any additional setup after loading the view.
    }
    
    
   
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchAPI(query: txtFldSearch.text!)
        
        return false
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayMoviesList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellRID", for: indexPath) as! HomeCell
        
        
        cell.layer.cornerRadius = 10
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOpacity = 1
        cell.layer.shadowOffset = .zero
        cell.layer.shadowRadius = 2
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        cell.imageMovies.layer.cornerRadius = 10
        cell.imageMovies.layer.shadowOffset = .zero
        cell.lblMovieTitle.text = arrayMoviesList[indexPath.row].original_title
        cell.imageMovies.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/original/\(arrayMoviesList[indexPath.row].image)"), placeholderImage: UIImage(named: "placeholder.png"))
        cell.imageMovies.contentMode = .scaleToFill
        if total_pages <= 61 {
            if arrayMoviesList.count - 1 == indexPath.row {
                pagination = pagination + 1
                MoviesAPI(page: pagination)
            }
        } else {
            
        }
        
        
       
        
        return cell
    }
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let horizontalSpacing = flowLayout.scrollDirection == .vertical ? flowLayout.minimumInteritemSpacing : flowLayout.minimumLineSpacing
            let cellWidth = (view.frame.width - max(0, numberOfCellsPerRow - 1)*horizontalSpacing)/numberOfCellsPerRow
            flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        }
        
        return CGSize(width: (self.view.frame.width - 8) / 2.0 , height: (self.view.frame.width - 8) / 2.0 + 100)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let movie_Id = arrayMoviesList[indexPath.row].ids
        let next = storyboard?.instantiateViewController(withIdentifier: "DetailsVCSID") as! DetailsVC
        next.movieId = movie_Id
        navigationController?.pushViewController(next, animated: true)
    }
  
    
    func setupDropDowns() {
        settingsdropDown.dataSource = ["Most Popular", "Most Rated"]
    }
    
    
    
    @IBAction func btnSettings(_ sender: Any) {
        settingsdropDown.show()
        settingsdropDown.anchorView = btnSettings
        settingsdropDown.bottomOffset = CGPoint(x: 0, y: 0)
        settingsdropDown.selectionAction = { [unowned self] (index, item) in
            if index == 0 {
                self.mostPopularAPI()
            } else {
                self.mostRatedAPI()
            }
        }
    }
    
    
    
    @IBAction func btnHome(_ sender: Any) {
        arrayMoviesList.removeAll()
        MoviesAPI(page: 1)
    }
    
    
    
    
}

class HomeCell: UICollectionViewCell {
    
    @IBOutlet weak var imageMovies: UIImageView!
    @IBOutlet weak var lblMovieTitle: UILabel!
    
}


extension HomeVC {
    func MoviesAPI(page:Int)
    {
        SwiftLoader.show(animated: true)
        //        arrayMoviesList.removeAll()
        let url = ViewController.homeAPi + "&page=\(page)"
        print(url)
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { response in
            switch response.result
            {
            case .success:
                let json = response.result.value
                SwiftLoader.hide()
                
                let results = (json as AnyObject).object(forKey: "results") as? NSArray ?? []
                self.page_number = (json as AnyObject).object(forKey: "page") as? Int ?? 1
                self.total_pages = (json as AnyObject).object(forKey: "total_pages") as? Int ?? 0
                for allresult in results {
                    let poster_path = (allresult as AnyObject).object(forKey: "poster_path") as? String ?? ""
                    let original_title = (allresult as AnyObject).object(forKey: "original_title") as? String ?? ""
                    let id = (allresult as AnyObject).object(forKey: "id") as? Int ?? 0
                    
                    let arr = structMoviesList(image: poster_path, original_title: original_title, ids: id)
                    self.arrayMoviesList.append(arr)
                }
                self.collectionview.reloadData()
                
            case .failure:
                self.alert(title: "", message: "Server error please try again later!!!")
            }
        })
    }
    
    
    func searchAPI(query:String)
    {
        arrayMoviesList.removeAll()
        SwiftLoader.show(animated: true)
        let url = ViewController.search + "&query=\(query)"
        print(url)
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { response in
            switch response.result
            {
            case .success:
                let json = response.result.value
                SwiftLoader.hide()
                self.txtFldSearch.resignFirstResponder()
                self.txtFldSearch.text = ""
                let results = (json as AnyObject).object(forKey: "results") as? NSArray ?? []
                self.page_number = (json as AnyObject).object(forKey: "page") as? Int ?? 1
                self.total_pages = (json as AnyObject).object(forKey: "total_pages") as? Int ?? 0
                for allresult in results {
                    let poster_path = (allresult as AnyObject).object(forKey: "poster_path") as? String ?? ""
                    let original_title = (allresult as AnyObject).object(forKey: "original_title") as? String ?? ""
                    let id = (allresult as AnyObject).object(forKey: "id") as? Int ?? 0
                    
                    let arr = structMoviesList(image: poster_path, original_title: original_title, ids: id)
                    self.arrayMoviesList.append(arr)
                }
                self.collectionview.reloadData()
                
            case .failure:
                self.alert(title: "", message: "Server error please try again later!!!")
            }
        })
    }
    
    
    func mostPopularAPI()
    {
        arrayMoviesList.removeAll()
        SwiftLoader.show(animated: true)
        let url = ViewController.mostPopular
        print(url)
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { response in
            switch response.result
            {
            case .success:
                let json = response.result.value
                SwiftLoader.hide()
                self.txtFldSearch.resignFirstResponder()
                self.txtFldSearch.text = ""
                let results = (json as AnyObject).object(forKey: "results") as? NSArray ?? []
                self.page_number = (json as AnyObject).object(forKey: "page") as? Int ?? 1
                self.total_pages = (json as AnyObject).object(forKey: "total_pages") as? Int ?? 0
                for allresult in results {
                    let poster_path = (allresult as AnyObject).object(forKey: "poster_path") as? String ?? ""
                    let original_title = (allresult as AnyObject).object(forKey: "original_title") as? String ?? ""
                    let id = (allresult as AnyObject).object(forKey: "id") as? Int ?? 0
                    let arr = structMoviesList(image: poster_path, original_title: original_title, ids: id)
                    self.arrayMoviesList.append(arr)
                }
                self.collectionview.reloadData()
                
            case .failure:
                self.alert(title: "", message: "Server error please try again later!!!")
            }
        })
    }
    
    
    func mostRatedAPI()
    {
        arrayMoviesList.removeAll()
        SwiftLoader.show(animated: true)
        let url = ViewController.mostRated
        print(url)
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { response in
            switch response.result
            {
            case .success:
                let json = response.result.value
                SwiftLoader.hide()
                self.txtFldSearch.resignFirstResponder()
                self.txtFldSearch.text = ""
                let results = (json as AnyObject).object(forKey: "results") as? NSArray ?? []
                self.page_number = (json as AnyObject).object(forKey: "page") as? Int ?? 1
                self.total_pages = (json as AnyObject).object(forKey: "total_pages") as? Int ?? 0
                for allresult in results {
                    let poster_path = (allresult as AnyObject).object(forKey: "poster_path") as? String ?? ""
                    let original_title = (allresult as AnyObject).object(forKey: "original_title") as? String ?? ""
                    let id = (allresult as AnyObject).object(forKey: "id") as? Int ?? 0
                    let arr = structMoviesList(image: poster_path, original_title: original_title, ids: id)
                    self.arrayMoviesList.append(arr)
                }
                self.collectionview.reloadData()
                
            case .failure:
                self.alert(title: "", message: "Server error please try again later!!!")
            }
        })
    }
    
}
