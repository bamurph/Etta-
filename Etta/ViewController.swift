//
//  ViewController.swift
//  Etta
//
//  Created by Ben Murphy on 8/6/16.
//  Copyright © 2016 Constellation Software. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBox: UITextView!
    @IBOutlet weak var resultTextView: UITextView!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func searchChanged(_ sender: UITextField) {

        guard sender.text != nil else {
            return
        }
        let sq = SearchQuery(term: sender.text!)

        do {
            try sq.search { (response) in
                let p = Parser(rawContent: response!)

                /// TODO: return all results not just the first
                let c = p.parsedContent().first?.description.textContent
                DispatchQueue.main.async {
                    self.resultTextView.attributedText = c?.htmlAttributedString()
//                    print(["~", c], separator: " ", terminator: "\n")
//                    print(["~", c?.htmlAttributedString()], separator: " ", terminator: "\n")
                }
            }

        } catch let error {
            print(error)
        }

    }

    
}

