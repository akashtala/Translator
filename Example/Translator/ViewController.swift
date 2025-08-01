//
//  ViewController.swift
//  Translator
//
//  Created by Akash Tala on 08/02/2025.
//  Copyright (c) 2025 Akash Tala. All rights reserved.
//

import UIKit
import Translator

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Translator().translate("Hola traducir API", success: { translation in
            print("Translation: \(translation.translatedText)")
        }, failure: { error in
            print("Error: \(String(describing: error))")
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

