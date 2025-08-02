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

    @IBOutlet private weak var messageTxt: UITextField!
    @IBOutlet private weak var sourceTxt: UITextField!
    @IBOutlet private weak var destinationTxt: UITextField!
    @IBOutlet private weak var outputLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction private func translateBtnTapped(_ sender: UIButton) {
        guard let message = messageTxt.text, let source = sourceTxt.text, let destination = destinationTxt.text, !message.isEmpty, !source.isEmpty, !destination.isEmpty else { return }
        
        Translator().translate(from: source, to: destination, sourceText: message, completion: { result in
            switch result {
            case .success(let translation):
                self.outputLbl.text = translation.translatedText
            case .failure(let error):
                self.outputLbl.text = error.localizedDescription
            }
        })
    }

}

