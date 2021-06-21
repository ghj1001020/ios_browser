//
//  HtmlElementViewController.swift
//  Browser
//
//  Created by 권혁준 on 2021/06/20.
//  Copyright © 2021 권혁준. All rights reserved.
//

import UIKit

class HtmlElementViewController: UIViewController {
    
    @IBOutlet var tvHtmlElement: HJTextView!
    var element : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        tvHtmlElement.text = element
    }

    @IBAction func onBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
