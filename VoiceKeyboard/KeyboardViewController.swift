//
//  KeyboardViewController.swift
//  VoiceKeyboard
//
//  Created by Apple on 20/11/25.
//

import UIKit
import SwiftUI

class KeyboardViewController: UIInputViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - 1. Create the SwiftUI Keyboard View
        // Pass a closure to handle text insertion into host app
        let keyboardView = KeyboardView { [weak self] text in
            self?.insertText(text)
        }
        
        // MARK: - 2. Host SwiftUI view in UIHostingController
        let hostingController = UIHostingController(rootView: keyboardView)
        
        // MARK: - 3. Add as child view controller
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        // MARK: - 4. Setup Auto Layout constraints
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            hostingController.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Fixed height for custom keyboard
            hostingController.view.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    // MARK: - Insert text helper
    func insertText(_ text: String) {
        // textDocumentProxy is the standard interface to host text field
        self.textDocumentProxy.insertText(text)
    }
    
    // MARK: - Optional overrides (boilerplate)
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // Allow keyboard to resize/layout if needed
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // App is about to change text
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // App just changed text
    }
}
