//
//  MovieDetailsViewController.swift
//  Flix
//
//  Created by Aisen Kim on 2021/02/21.
//

import UIKit
import AlamofireImage

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var backdropView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    var movie: [String:Any]!
    var movies = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        print(movie["id"] as! Int)
        let movieId = movie["id"] as! Int
        titleLabel.text = movie["title"] as? String
        titleLabel.sizeToFit() // tells to grow until everything is typed (Used only because not applied autolayout yet)
        
        synopsisLabel.text = movie["overview"] as? String
        synopsisLabel.sizeToFit()
        
        // for assignent 2 bonus 2
        posterView.isUserInteractionEnabled = true
        posterView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageTap)))
        
        //posterView rounded corner
        posterView.layer.cornerRadius = 20
        posterView.clipsToBounds = true
        
        // process for image
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        posterView.af_setImage(withURL: posterUrl!)
        
        let backdropPath = movie["backdrop_path"] as! String
        let backdropUrl = URL(string: "https://image.tmdb.org/t/p/w780" + backdropPath)
        backdropView.af_setImage(withURL: backdropUrl!)
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            self.movies = dataDictionary["results"] as! [[String:Any]]
           }
        }
        task.resume()
    }
    
    @objc func imageTap() {
        let videoObj = movies[0]
        let key = videoObj["key"] as! String
        guard let url = URL(string: "https://www.youtube.com/watch?v=\(key)") else {
            return
        }
        let vc = TrailerWebViewController(url: url, title: "Google")
        let navVC = UINavigationController(rootViewController: vc)
        // present modally
        self.present(navVC, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
