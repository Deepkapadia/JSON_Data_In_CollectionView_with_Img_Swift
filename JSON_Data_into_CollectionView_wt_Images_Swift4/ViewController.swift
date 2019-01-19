//
//  ViewController.swift
//  JSON_Data_into_CollectionView_wt_Images_Swift4
//
//  Created by DeEp KapaDia on 28/05/18.
//  Copyright © 2018 DeEp KapaDia. All rights reserved.
//

import UIKit

struct Heroes : Decodable {

    let localized_name : String
    let img : String
    
}

class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate{

    @IBOutlet weak var collectionview: UICollectionView!
    
    var Hero = [Heroes]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://api.opendota.com/api/heroStats")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error == nil {
                do{
                    self.Hero = try JSONDecoder().decode([Heroes].self, from: data!)
                    
                }catch{
                    
                    print("parse error")
                    
                }
                
                DispatchQueue.main.async {
                    
                    self.collectionview.reloadData()
                    
                }
                
            }
            
            }.resume()
        
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Hero.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as!imageCellFile
        
        
        cell.NAmeLBL.text = Hero[indexPath.row].localized_name.capitalized
        
        let defaultlink = "https://api.opendota.com"
        
        let completelink = defaultlink + Hero[indexPath.row].img
        
        cell.Image.downloadedFrom(link: completelink)
        
        cell.Image.layer.cornerRadius = cell.Image.frame.height / 2
        
        cell.Image.contentMode = .scaleAspectFill
        
        return cell
        
    }
    

}

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}







