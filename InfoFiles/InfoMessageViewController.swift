//
//  InfoMessageViewController.swift
//  MyLife
//
//  Created by Susan Kohler on 4/8/16.
//  Copyright © 2016 Susan Kohler. All rights reserved.
//

import UIKit

class InfoMessageViewController: UIViewController {

    var infoMessageView:UITextView?
    var infoHTMLView:UIWebView?
    var message:InfoMessage!
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor(red:0.875, green:0.88, blue:0.91, alpha:1)
        
        infoMessageView = UITextView(frame: view.bounds)
        infoMessageView!.frame.size = CGSize(width: self.view.frame.width * 0.85, height: self.view.frame.height * 0.75)
        infoMessageView!.center = self.view.center
        infoMessageView!.font = UIFont(name:"arial",size:20)
        infoMessageView!.text = message.messageContent
        infoMessageView!.isEditable = false
        infoMessageView!.textAlignment = NSTextAlignment.justified
        self.view.addSubview(infoMessageView!)
        
    }

}
