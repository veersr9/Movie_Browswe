//
//  DetailsVC.swift
//  Movie Browser
//
//  Created by Veerendra Pratap Singh on 21/09/19.
//  Copyright © 2019 Veerendra Pratap Singh. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class DetailsVC: UIViewController , UITableViewDelegate{
    
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var imageShow: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblReleaseDate: UILabel!
    var movieId:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieDetailsAPI(movieID: movieId)
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func movieDetailsAPI(movieID:Int)
    {
        SwiftLoader.show(animated: true)
        let url = ViewController.movieMainURL + "\(movieID)" + ViewController.movieLastURL
        print(url)
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { response in
            switch response.result
            {
            case .success:
                let json = response.result.value
                SwiftLoader.hide()
                let original_title = (json as AnyObject).object(forKey: "original_title") as? String ?? ""
                let overview = (json as AnyObject).object(forKey: "overview") as? String ?? ""
                let poster_path = (json as AnyObject).object(forKey: "poster_path") as? String ?? ""
                let vote_average = (json as AnyObject).object(forKey: "vote_average") as? Double ?? 0.0
                let release_date = (json as AnyObject).object(forKey: "release_date") as? String ?? ""
                self.imageShow.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/original/\(poster_path)"), placeholderImage: UIImage(named: "placeholder.png"))
//                self.imageShow.contentMode = .scaleAspectFill
                self.lblTitle.text = original_title
                self.lblDesc.text = overview
                self.lblRating.text = "Vote Average:- \(vote_average)"
                self.lblReleaseDate.text = "Release Date:- \(release_date)"
                
                self.navigationItem.title = original_title
                
            case .failure:
                self.alert(title: "", message: "Server error please try again later!!!")
            }
        })
    }
    

}
