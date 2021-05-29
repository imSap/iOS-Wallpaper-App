//
//  ImageListViewController.swift
//  CollectionView+Json
//
//  Created by GeoTech Infoservices on 03/05/21.
//

import UIKit

class ImageListViewController: UIViewController {
    
    @IBOutlet weak var tableview:UITableView!
    
    var imageCategory = ["Nature","Dogs","Cats","Cars","Abstract","Birds","Sea","Mountains","Sky","Rain","Tigers","Football","Cricket","Fire","Woods","Universe","Wildlife","Roads","Rainbow","Waterfalls","Architecture","Flower","Satelite","Moon","Thunder","Toys","Cartoon","Baby","Movies","Books","Art","Portraits","Holy","Gods","Glacier","Snow","Boats"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.register(UINib(nibName: "ImageCategoryCell", bundle: nil), forCellReuseIdentifier: "catcell")
        tableview.dataSource = self
        tableview.delegate = self
        tableview.tableFooterView = UIView()

      
    }
    

}

extension ImageListViewController:UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        imageCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "catcell") as!
        ImageCategoryCell
        cell.lblCategory.text = imageCategory[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let imagedetail:ViewController = self.storyboard?.instantiateViewController(identifier: "imageview") as! ViewController
        imagedetail.imgquery = imageCategory[indexPath.row]
        self.navigationController?.pushViewController(imagedetail, animated: true)
    }
    
    
}
