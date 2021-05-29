//
//  FullImageViewController.swift
//  CollectionView+Json
//
//  Created by GeoTech Infoservices on 03/05/21.
//

import UIKit
import Alamofire
import AlamofireImage
import UserNotifications

class FullImageViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var fullImage:UIImageView!
    @IBOutlet weak var btnSave:UIButton!
    @IBOutlet weak var spinner:UIActivityIndicatorView!
    var notificationcenter = UNUserNotificationCenter.current()
    
    var mainImage:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.startAnimating()
        AF.request(mainImage).responseImage { (imgresponse) in
            if case .success(let image) = imgresponse.result {
                DispatchQueue.main.async {
                    self.fullImage.image = image
                    self.spinner.stopAnimating()
                }
            }
    }
        
        notificationcenter.delegate = self
        notificationcenter.requestAuthorization(options: [.alert,.sound]) { (success, error) in
     
    }
    }
    
    @IBAction func saveImage(_ sender: Any) {
        savephoto()
    }
    

    
    @objc fileprivate func savephoto(){
        
        guard let photo = self.fullImage.image else {
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(photo, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        localnotification()
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved Succesfully!", message: "Image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func localnotification(){
        
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = "My Category Identifier"
        content.title = "Image Saved"
        content.body = "Image Saved Successfully to Photos"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 1, repeats: false)
        let identifier = "Main Identifier"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationcenter.add(request) { (error) in
            print("\(error?.localizedDescription ?? "")")
        }
        
    }

    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner,.sound])
    }
    
}
