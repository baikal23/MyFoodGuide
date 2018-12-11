//
//  WebChooserViewController.swift
//  MyFoodGuide
//
//  Created by Susan Kohler on 10/26/18.
//  Copyright © 2018 Susan Kohler. All rights reserved.
//

import UIKit
import WebKit

class WebChooserViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, WKNavigationDelegate, WKUIDelegate,UIScrollViewDelegate, WKScriptMessageHandler, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    
    
    @IBOutlet weak var webPicker: UIPickerView!
   
    @IBOutlet weak var caloriesTextField: UITextField!
    @IBOutlet weak var fatTextField: UITextField!
    @IBOutlet weak var fat2TF: UITextField!
    
    @IBOutlet weak var fat1TF: UITextField!
    @IBOutlet weak var sugarTextField: UITextField!
    @IBOutlet weak var sugar2TF: UITextField!
    @IBOutlet weak var sugar1TF: UITextField!
    @IBOutlet weak var sodiumTextField: UITextField!

    @IBOutlet weak var sodium1TF: UITextField!
    @IBOutlet weak var sodium2TF: UITextField!
    @IBOutlet weak var calories2TF: UITextField!
    
    @IBOutlet weak var calories1TF: UITextField!
    @IBOutlet weak var saltLabel: UILabel!
    @IBOutlet weak var sugarLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var webContainer: UIView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var pickerData = ["Applebee’s",
                      "Burger King",
                      "Chipotle",
                      "Cumberland Farms",
                      "Domino’s",
                      "Dunkin’ Donuts",
                      "MacDonald's",
                      "Moe’s",
                      "Panera Bread",
                      "Pizza Hut",
                      "Starbuck's",
                      "Subway",
                      "Taco Bell",
                      "Wendy’s",
                      "99 Restaurant",
                      "MyFoodDiary",
                      "MyFoodDiary-Brands",
                      "Nutrition Facts"]
    var webView: WKWebView!
    var webViewLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.assignBackground()
        self.webContainer.backgroundColor = UIColor.gray
        self.activityIndicator.color = UIColor.black
        print("In ViewDidLoad")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapBackground(_:)))
        tapGesture.cancelsTouchesInView = true
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
        self.webPicker.delegate = self
        self.webPicker.dataSource = self
        sugarTextField.delegate = self
        sugar1TF.delegate = self
        sugar2TF.delegate = self
        sodiumTextField.delegate = self
        sodium1TF.delegate = self
        sodium2TF.delegate = self
        fatTextField.delegate = self
        fat1TF.delegate    = self
        fat2TF.delegate = self
        caloriesTextField.delegate = self
        calories1TF.delegate = self
        calories2TF.delegate = self
    }
    // this would put an image in the background
    func assignBackground(){
        let background = UIImage(named: "food.png")
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        imageView.alpha = 0.3
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    override func viewDidLayoutSubviews() {
        print("Layout subview done")
        if (!webViewLoaded) {
            let request = URLRequest(url: URL(string: "https://www.myfooddiary.com/brand/applebees")!)
            let config = WKWebViewConfiguration()
             let js = "document.addEventListener('click', function(){ window.webkit.messageHandlers.clickListener.postMessage('My hovercraft is full of eels!'); })"
            let js2 = "document.querySelector('meta[name=viewport]').setAttribute('content','width=device-width,initial-scale=1,maximum-scale=10,user-scalable=yes');"
            let js3 = "var meta = document.createElement('meta');meta.setAttribute('name', 'viewport');meta.setAttribute('content', 'width=device-width, initial-scale=0.5, maximum-scale=10.0, user-scalable=yes');document.getElementsByTagName('head')[0].appendChild(meta);"
            let script = WKUserScript(source: js3, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
            config.userContentController.addUserScript(script)
            config.userContentController.add(self, name: "clickListener")
            config.ignoresViewportScaleLimits = true
            webView = WKWebView(frame: webContainer.bounds, configuration: config)
            webContainer.addSubview(webView)
            webView.navigationDelegate = self
            webView.load(request)
            webView.allowsBackForwardNavigationGestures = true
            webViewLoaded = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self,name: UIResponder.keyboardWillHideNotification, object: nil)
        // NotificationCenter.default.removeObserver(self,name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func donePushed(_ sender: Any) {
        performSegue(withIdentifier: "unwindSegueToVC1", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindSegueToVC1" {
            print("Unwinding")
            let mainVC = segue.destination as! ViewController
           /* mainVC.caloriesTextField.text = caloriesTextField.text
            mainVC.fatTextField.text = fatTextField.text
            mainVC.sodiumTextField.text = sodiumTextField.text
            mainVC.sugarTextField.text = sugarTextField.text*/
            var calories:Double = 0.0
            if calories1TF.text!.isNumeric {
                calories = calories + Double(calories1TF.text!)!
            }
            if calories2TF.text!.isNumeric {
                calories = calories + Double(calories2TF.text!)!
            }
            if caloriesTextField.text!.isNumeric {
                calories = calories + Double(caloriesTextField.text!)!
            }
            mainVC.caloriesTextField.text = String(Int(calories)) // no fractional cals
            
            var satFat:Double = 0
            if fat1TF.text!.isNumeric {
                satFat = satFat + Double(fat1TF.text!)!
            }
            if fat2TF.text!.isNumeric {
                satFat = satFat + Double(fat2TF.text!)!
            }
            if fatTextField.text!.isNumeric {
                satFat = satFat + Double(fatTextField.text!)!
            }
            mainVC.fatTextField.text = String(satFat)
            
            var sodium:Double = 0
            if sodium1TF.text!.isNumeric {
                sodium = sodium + Double(sodium1TF.text!)!
            }
            if sodium2TF.text!.isNumeric {
                sodium = sodium + Double(sodium2TF.text!)!
            }
            if sodiumTextField.text!.isNumeric {
                sodium = sodium + Double(sodiumTextField.text!)!
            }
            mainVC.sodiumTextField.text = String(Int(sodium)) // mg Na is integer
            
            var sugar:Double = 0
            if sugar1TF.text!.isNumeric {
                sugar = sugar + Double(sugar1TF.text!)!
            }
            if sugar2TF.text!.isNumeric {
                sugar = sugar + Double(sugar2TF.text!)!
            }
            if sugarTextField.text!.isNumeric {
                sugar = sugar + Double(sugarTextField.text!)!
            }
            mainVC.sugarTextField.text = String(sugar)
            mainVC.barChartUpdate()
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("We selected \(pickerData[row])")
        let selection = pickerData[row]
        
        if selection == "MacDonald's" {
            print("Displaying Mac")
            let url = URL(string: "https://www.mcdonalds.com/us/en-us/about-our-food/nutrition-calculator.html")!
            webView.load(URLRequest(url: url))
        } else if selection == "Subway" {
            print("Displaying Subway")
            let url = URL(string: "https://www.subway.com/en-US/MenuNutrition/Nutrition/NutritionGrid")!
            webView.load(URLRequest(url: url))
        } else if selection == "Taco Bell" {
            print("Displaying Taco Bell")
            let url = URL(string: "https://www.tacobell.com/nutrition/info")!
            webView.load(URLRequest(url: url))
        } else if selection == "Nutrition Facts" {
            let url = Bundle.main.url(forResource: "NutritionFacts", withExtension: "html")!
            webView.loadFileURL(url, allowingReadAccessTo: url)
            let request = URLRequest(url: url)
            webView.load(request)
        } else if selection == "Cumberland Farms" {
            let url = URL(string: "https://www.cumberlandfarms.com/food/nutrition-information")!
            webView.load(URLRequest(url: url))
        } else if selection == "Burger King" {
            let url = URL(string: "https://www.bk.com/pdfs/nutrition.pdf")!
            webView.load(URLRequest(url: url))
        } else if selection == "Dunkin’ Donuts" {
            let url = URL(string: "https://www.dunkindonuts.com/content/dam/dd/pdf/nutrition.pdf")!
            webView.load(URLRequest(url: url))
        } else if selection == "Wendy’s" {
            let url = URL(string: "https://menu.wendys.com/en_US/categories/?_ga=2.16799417.1675749095.1542375685-1660908970.1542375685")!
            webView.load(URLRequest(url: url))
        } else if selection == "99 Restaurant" {
            let url = URL(string: "https://www.99restaurants.com/media/1774/ninety-nine-restaurant-nutritional-menu.pdf")!
            webView.load(URLRequest(url: url))
        } else if selection == "Panera Bread" {
            let url = URL(string: "https://www.panerabread.com/content/dam/panerabread/documents/nutrition/Panera-Nutrition.pdf")!
            webView.load(URLRequest(url: url))
        } else if selection == "Chipotle" {
            let url = URL(string: "https://www.chipotle.com/nutrition-calculator#")!
            webView.load(URLRequest(url: url))
        } else if selection == "Moe’s" {
            let url = URL(string: "https://www.moes.com/nutrition")!
            webView.load(URLRequest(url: url))
        } else if selection == "Starbuck's" {
            let url = URL(string: "https://www.starbucks.com/menu/catalog/nutrition?food=all#food=all&page=undefined")!
            webView.load(URLRequest(url: url))
        } else if selection == "Applebee’s" {
            let url = URL(string: "https://www.myfooddiary.com/brand/applebees")!
            webView.load(URLRequest(url: url))
        } else if selection == "Pizza Hut" {
            let url = URL(string: "https://m.nutritionix.com/pizza-hut/menu/premium/")!
            webView.load(URLRequest(url: url))
        } else if selection == "Domino’s" {
            let url = URL(string: "https://cache.dominos.com/olo/5_46_3/assets/build/market/US/_en/pdf/DominosNutritionGuide.pdf")!
            webView.load(URLRequest(url: url))
        } else if selection == "MyFoodDiary" {
            let url = URL(string: "https://www.myfooddiary.com")!
            webView.load(URLRequest(url: url))
        } else if selection == "MyFoodDiary-Brands" {
            let url = URL(string: "https://www.myfooddiary.com/brand")!
            webView.load(URLRequest(url: url))
        }
        
        
    }
    // MARK: - Keyboard Control
    @objc func tapBackground(_ sender: UITapGestureRecognizer) {
        print("Background tapped")
        self.view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //textField.resignFirstResponder()
        //return true
        print("Return pressed")
        self.view.endEditing(true)
        return false
    }
    
    // MARK: NavigationDelagate finctions
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!)
    {
        print(#function)
        self.activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print(#function)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(#function)
        self.activityIndicator.stopAnimating()
        title = webView.title
        webView.evaluateJavaScript("navigator.userAgent", completionHandler: { result, error in
            if let userAgent = result as? String {
                print(userAgent)
            }
        })
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error)
        self.activityIndicator.stopAnimating()
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error)
        self.activityIndicator.stopAnimating()
    }
    
    // MARK: WKMessageHandler methods
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage)
    {
        print(message.body)
    }

    
}

