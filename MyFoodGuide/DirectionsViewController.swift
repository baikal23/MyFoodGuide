//
//  DirectionsViewController.swift
//  MyFoodGuide
//
//  Created by Susan Kohler on 3/27/19.
//  Copyright © 2019 Susan Kohler. All rights reserved.
//

import UIKit

class DirectionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let imageName = "FoodBasketInfo.png"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = self.view.frame
        //imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 200)
        view.addSubview(imageView)
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "FoodBasketPageOne.png")!)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismiss(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }
    
    @objc func dismiss(_ sender: UITapGestureRecognizer) {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        appDelegate.mainVC = storyboard.instantiateViewController(withIdentifier: "WebVC")
        appDelegate.window?.rootViewController = appDelegate.mainVC
        //self.dismissViewControllerAnimated(true, completion: nil)
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
