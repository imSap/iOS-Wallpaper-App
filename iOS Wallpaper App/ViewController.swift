//
//  ViewController.swift
//  CollectionView+Json
//
//  Created by GeoTech Infoservices on 03/05/21.
//

import UIKit
import Alamofire
import AlamofireImage

struct APIResponse:Codable {
    let toatl:Int?
    let total_pages:Int?
    let results:[Result]
}
struct Result:Codable {
    let id:String?
    let urls:URLS
}

struct URLS:Codable{
    let full:String
    let raw:String
}

class ViewController: UIViewController {

    
    @IBOutlet weak var collectionView: UICollectionView!
    var mainImage:UIImage!
    var imgArray:[Result] = []
    var imgquery:String = ""
    var urlStartponit:String = "https://api.unsplash.com/search/photos?page=1&per_page=50&query="
    var urlEndpoint:String = "&client_id=P9tJyD92kcLAU9z4lTmgeajEbAUxBN1WiEmlHcVuE4I"
    
    var myurl:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        title = imgquery + " Images"
        myurl = urlStartponit + imgquery + urlEndpoint
       
        fetchPhotos()
       
        // Do any additional setup after loading the view.
    }


    func fetchPhotos(){
        
        
        guard let url = URL(string: myurl) else {
            return
        }
        //MARK: URLSession
        
        /*let task = URLSession.shared.dataTask(with: url){ data , _,error in
            guard let data = data , error == nil else{
                return
            }
            do{
                print("success")
                let Jsonresult = try JSONDecoder().decode(APIResponse.self, from: data)
                DispatchQueue.main.async {
                    self.imgArray = Jsonresult.results
                    self.collectionView.reloadData()
                    
                }
            }catch {
                print(error)
            }
        }
        task.resume()*/
        
        //MARK: Alamofire
        
        AF.request(url).response { myresponse in
            
            if let data = myresponse.data{
                do{
                    let jsonResponse:APIResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                    
                    DispatchQueue.main.async {
                        self.imgArray = jsonResponse.results
                        self.collectionView.reloadData()
                    }
                   
                    
                }catch let err{
                    print(err.localizedDescription)
                    
                }
                
            }
        }
}
    
}

extension ViewController:UICollectionViewDataSource , UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imgArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! ImageViewCell
        
        let imageurl = imgArray[indexPath.row].urls.raw + "&w=198&dpr=2"
        AF.request(imageurl).responseImage { (imgresponse) in
            if case .success(let image) = imgresponse.result {
                self.mainImage = image
                cell.imageView.image = self.mainImage
                }
       
    }
    
    return cell
}
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageView:FullImageViewController = self.storyboard?.instantiateViewController(identifier: "fullimage") as! FullImageViewController
            imageView.mainImage = imgArray[indexPath.row].urls.full
        self.navigationController?.pushViewController(imageView, animated: true)
    }
}

extension ViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.bounds.width
        return CGSize(width: cellWidth/2-5, height: cellWidth/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    
    }


