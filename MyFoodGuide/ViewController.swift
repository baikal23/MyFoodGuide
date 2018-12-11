//
//  ViewController.swift
//  MyFoodGuide
//
//  Created by Susan Kohler on 10/26/18.
//  Copyright © 2018 Susan Kohler. All rights reserved.
//

import UIKit
import Charts


class ViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    var caloriePercent = 0
    var sodiumPercent = 0
    var sugarPercent = 0
    var satFatPercent = 0
    var sodium = Double(0.0)
    var calories = Double(0.0)
    var satFat = Double(0.0)
    var sugar = Double(0.0)
    
    @IBOutlet weak var caloriesTextField: UITextField!
    
    @IBOutlet weak var fatTextField: UITextField!
    
    @IBOutlet weak var sodiumTextField: UITextField!
    @IBOutlet weak var sugarTextField: UITextField!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var saltLabel: UILabel!
    @IBOutlet weak var sugarLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    
    @IBOutlet weak var barChart: BarChartView!
    
    @IBOutlet weak var infoButton: UIButton!
    @IBAction func webButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "WebSegue", sender: self)
    }
   
    @IBAction func unwindToVC1(segue:UIStoryboardSegue) { }
    @IBAction func unwindToMainMenu(_ sender: UIStoryboardSegue)
    {
    }
    @IBAction func infoButtonPushed(_ sender: Any) {
        performSegue(withIdentifier: "infoSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  self.assignBackground()
        sugarTextField.delegate = self
        sodiumTextField.delegate = self
        fatTextField.delegate = self
        caloriesTextField.delegate = self
        self.barChart.backgroundColor = UIColor.white
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapBackground(_:)))
        tapGesture.cancelsTouchesInView = true
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
       // NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
        print("In VC ViewDidLoad")
       // barChart.backgroundColor = UIColor.clear
        barChartUpdate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self,name: UIResponder.keyboardWillHideNotification, object: nil)
       // NotificationCenter.default.removeObserver(self,name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func barChartUpdate () {
       // self.updateLabels()
        // Basic set up of plan chart
        let color1 = UIColor.black
        let color2 = UIColor.black
        let color3 = UIColor.black
        let color4 = UIColor.black
        var colorSet = [color1, color2, color3, color4]
        var barsToPlot = [BarChartDataEntry]()
        let labels = ["Calories", "Sat Fat", "Sodium", "Sugar"]
        
        let calorieValue = caloriesTextField.text!
        if calorieValue.isNumeric {
            calories = Double(calorieValue) ?? 0.0
            caloriePercent = Int(calories * 100 / kCalories)
        } else {
            caloriePercent = 0
        }
        if caloriePercent == 0 {
            caloriePercent = 1 // so column remains on graph
        }
        
        let satFatValue = fatTextField.text!
        if satFatValue.isNumeric {
            satFat = Double(satFatValue) ?? 0.0
            satFatPercent = Int(satFat * 100 / kSatFat)
        } else {
            satFatPercent = 0
        }
        if satFatPercent == 0 {
            satFatPercent = 1 // so column remains on graph
        }
        
        let sodiumValue = sodiumTextField.text!
        if sodiumValue.isNumeric {
            sodium = Double(sodiumValue) ?? 0.0
            sodiumPercent = Int(sodium * 100 / kSalt)
        } else {
            sodiumPercent = 0
        }
        if sodiumPercent == 0 {
            sodiumPercent = 1 // so column remains on graph
        }
       
        let sugarValue = sugarTextField.text!
        if sugarValue.isNumeric {
            sugar = Double(sugarValue) ?? 0.0
            sugarPercent = Int(sugar * 100 / kSugar)
        } else {
            sugarPercent = 0
        }
        if sugarPercent == 0 {
            sugarPercent = 1 // so column remains on graph
        }
        
        let numbers = [caloriePercent, satFatPercent, sodiumPercent, sugarPercent]
        barsToPlot = [] // start with empty array
        for (index, element) in numbers.enumerated() {
            if element > 0 {
                let entry = BarChartDataEntry(x: (Double(index)), y: Double(element))
                barsToPlot.append(entry)
            }
            if element <= 33 {
                colorSet[index] = UIColor.green
            } else if ((element > 33) && (element <= 50)) {
                colorSet[index] = UIColor.yellow
            } else {
                colorSet[index] = UIColor.red
            }
        }
        
        //let dataSet = BarChartDataSet(values: [entry1, entry2, entry3], label: "Daily Value")
        let dataSet = BarChartDataSet(values: barsToPlot, label: "")
        dataSet.colors = colorSet
        barChart.chartDescription?.text = ""
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:labels)
        barChart.xAxis.granularity = 1
        barChart.leftAxis.axisMaximum = Double(100.0)
        barChart.leftAxis.axisMinimum = Double(0.0)
        barChart.rightAxis.axisMinimum = barChart.leftAxis.axisMinimum
        barChart.rightAxis.axisMaximum = barChart.leftAxis.axisMaximum
        barChart.xAxis.labelPosition = .bottom
        barChart.xAxis.drawGridLinesEnabled = false
        // barChart.leftAxis.drawGridLinesEnabled = false
        // barChart.rightAxis.drawGridLinesEnabled = false
        
        
        let limitLine = ChartLimitLine(limit: 100.0, label: "Target")
        barChart.rightAxis.addLimitLine(limitLine)
        barChart.leftAxis.granularity = Double(100.0)
        barChart.rightAxis.granularity = Double(100.0)
        let data = BarChartData(dataSets: [dataSet])
        data.setDrawValues(false) // this eliminates the number
        data.setValueFont(UIFont.systemFont(ofSize: 20.0))
        barChart.data = data
        //barChart.chartDescription?.text = "Number of Widgets by Type"
        barChart.xAxis.labelFont = UIFont.init(name: "AvenirNext-Regular", size: 20)!
        let myFormatter = MyValueFormatter()
        myFormatter.valueArray[0] = calories
        myFormatter.valueArray[1] = satFat
        myFormatter.valueArray[2] = sodium
        myFormatter.valueArray[3] = sugar
        barChart.barData?.setValueFormatter(myFormatter)
        barChart.barData?.setDrawValues(true)
        // Color
        //dataSet.colors = ChartColorTemplates.vordiplom()
        
        // Refresh chart with new data
        barChart.notifyDataSetChanged()
    }
    
    // MARK: - Keyboard Control
    @objc func tapBackground(_ sender: UITapGestureRecognizer) {
        print("Background tapped")
        self.barChartUpdate()
        self.view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.barChartUpdate()
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //textField.resignFirstResponder()
        print("Return pressed")
        self.barChartUpdate()
        self.view.endEditing(true)
        return false
    }
   @objc func keyboardWillHide(notification: NSNotification) {
        //if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
           // self.view.frame.origin.y += keyboardSize.height
        //}
        self.barChartUpdate()
        
    }
}

extension String {

    var isNumeric: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "."]
        return Set(self).isSubset(of: nums)
    }
    
    var hasWhitespaceOrEmpty: Bool {
        guard self.count > 0 else { return true }
        let white = " "
        let result = self.contains(white)
        return result
    }
}

class MyValueFormatter: IValueFormatter {
    var valueArray:[Double] = [1, 2, 3, 4]
    //var xValueForToday: Double?  // Set a value
    // problem with roundoff error - this is not good to convert back
   func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        if entry.x == 0 {
            //return String((value / 100.0) * kCalories)
            if (valueArray[0] > 0) {
                return String(Int(valueArray[0]))
            } else {
                return ""
            }
        } else if entry.x == 1 {
            if (valueArray[1] > 0) {
                return String((valueArray[1])) + " g"
            } else {
                return ""
            }
        } else if entry.x == 2 {
            if (valueArray[2] > 0) {
                return String(Int(valueArray[2])) + " mg"
            } else {
                return ""
            }
        } else {
            if (valueArray[3] > 0) {
                return String((valueArray[3])) + " g"
            } else {
                return ""
            }
        }
    }
}
