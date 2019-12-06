//
//  SignUpController.swift
//  iJudge
//
//  Created by Ryan S on 2019-10-10.
//  Copyright © 2019 BCIT. All rights reserved.
//
import FirebaseAuth
import FirebaseDatabase
import UIKit


class SignUpController: UIViewController, UITextFieldDelegate {



    var handle: AuthStateDidChangeListenerHandle?


    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var fullName: UITextField!
    var ref: DatabaseReference! = Database.database().reference()
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      if textField == userName {
         textField.resignFirstResponder()
         fullName.becomeFirstResponder()
      } else if textField == fullName{
         textField.resignFirstResponder()
         password.becomeFirstResponder()
      } else if textField == password{
         textField.resignFirstResponder()
      }
     return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            self.dismissKey()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
          // ...
        }
        self.addKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      // [START remove_auth_listener]
      Auth.auth().removeStateDidChangeListener(handle!)
      // [END remove_auth_listener]
        self.removeKeyboardObserver()
    }

    @IBAction func didCreateAccount(_ sender: AnyObject) {
        Auth.auth().createUser(withEmail: userName.text!, password: password.text!) {authResult, error in
            guard let user = authResult?.user, error == nil else {
                print(error)
                let alert = UIAlertController(title: "failed", message: error?.localizedDescription, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                self.present(alert, animated: true)
                return
            }
            self.ref.child("users/\(user.uid)/username").setValue(self.fullName.text!)
            self.ref.child("users/\(user.uid)/user_id").setValue(user.uid)
            self.ref.child("users/\(user.uid)/scoreSum").setValue(0)
            self.ref.child("users/\(user.uid)/scoreCount").setValue(0)
            self.ref.child("users/\(user.uid)/email").setValue(self.userName.text!.lowercased())
                print("\(user.email!) created")
            print("\(user.uid)")
            self.performSegue(withIdentifier: "registerSegue", sender: self)
            }
    }
        
    




    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class FirebaseAuthManager {

}
