//
//  ViewController.swift
//  iJudge
//
//  Created by Ryan S on 2019-10-10.
//  Copyright © 2019 BCIT. All rights reserved.
//

import UIKit
import FirebaseAuth


extension UIViewController {
func dismissKey()
{
let tap: UITapGestureRecognizer = UITapGestureRecognizer( target: self, action: #selector(UIViewController.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
}
@objc func dismissKeyboard()
{
    view.endEditing(true)
}
}

class ViewController: UIViewController {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
 
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissKey()

        // Do any additional setup after loading the view.
    }



    
    @IBAction func signIn(_ sender: Any) {
        Auth.auth().signIn(withEmail: userName.text!, password: password.text!) { [weak self] authResult, error in
          guard let user = authResult?.user, error == nil else {
              print(error)
            let alert = UIAlertController(title: "failed", message: error?.localizedDescription, preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            self!.present(alert, animated: true)
            return
          }
            Auth.auth().addStateDidChangeListener() { auth, user in
                // 2
                if user != nil {
                  // 3
                    self!.performSegue(withIdentifier: "signInSegue", sender: self)
                    self!.userName.text = nil
                    self!.password.text = nil
                }
              }


          }
    }
    

}

