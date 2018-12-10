//
//  InfoTableTableViewController.swift
//  MyLife
//
//  Created by Susan Kohler on 4/7/16.
//  Copyright © 2016 Susan Kohler. All rights reserved.
//

import UIKit

class InfoTableTableViewController: UITableViewController {

    let cellIdentifier = "cellIdentifier"
    var eachInfoMessageKey:String = ""
    var infoMessageArray:Array<InfoMessage>

    @IBAction func doneButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "unwindToMainVC", sender: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        infoMessageArray = []
        var myDict: NSDictionary?
        if let path = Bundle.main.path(forResource: "InfoMessage", ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path)
        }
        
        if let rawInfoMessageDictionary = myDict {
            var tempArray:[InfoMessage] = []
            //var eachInfoMessage = Dictionary<String, InfoMessage>()
            for (key, _) in rawInfoMessageDictionary {
                if let key = key as? NSString {
                    let eachInfoMessage = rawInfoMessageDictionary[key]! as! [String : AnyObject]
                    let aMessage:InfoMessage = InfoMessage(aDictionary: eachInfoMessage)
                    //self.infoMessageArray.append(aMessage)
                    tempArray.append(aMessage)
                }
                
            }
            
            self.infoMessageArray = tempArray.sorted(by: {
                (item1:InfoMessage, item2:InfoMessage) -> Bool in
                let item1 = item1.rank as Int
                let item2 = item2.rank as Int
                return item1 < item2
            })
            
            
            
        }
        super.init(coder: aDecoder)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = UIColor(red:0.875, green:0.88, blue:0.91, alpha:1)
        // Register the UITableViewCell class with the tableView
        self.tableView?.register(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // UITableViewDataSource methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoMessageArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier)as UITableViewCell?
        let currentMessage = infoMessageArray[indexPath.row]
        cell!.textLabel?.text = currentMessage.messageName
        
        return cell!
    }
    
    // UITableViewDelegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailViewController = InfoMessageViewController()
        let currentMessage = infoMessageArray[indexPath.row]
        detailViewController.message = currentMessage
        self.navigationController?.pushViewController(detailViewController, animated: true)
        
    }
}
