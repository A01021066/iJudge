//
//  JudgeController.swift
//  iJudge
//
//  Created by Ryan S on 2019-10-10.
//  Copyright © 2019 BCIT. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
var ref: DatabaseReference! = Database.database().reference()


class JudgeController: UIViewController {
    
    class user {
        var name: String?
        var id: String?
        var scoreCount: integer_t?
        var scoreSum: integer_t?
        var comment: [String]?
        init(nameString: String?, idString: String?, scoreCountInt: integer_t?, scoreSumInt: integer_t?, commentArray: [String]?) {
            name = nameString
            id = idString
            scoreCount = scoreCountInt
            scoreSum = scoreSumInt
            comment = commentArray
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
            let uid = Auth.auth().currentUser?.uid
        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let key = snap.key
                let value = snap.value
                print("key = \(key)  value = \(value!)")
            }
        })
    }

        // Do any additional setup after loading the view
    
    @IBAction func signOut(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
          print (signOutError)
            
        }
        print("signed out")
        self.performSegue(withIdentifier: "signOutSegue", sender: self)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is OtherProfileController
        {
            let otherPage = segue.destination as? OtherProfileController
            otherPage?.userId = "Test"
        }
    }

    @IBAction func rate(_ sender: UIButton) {
        self.performSegue(withIdentifier: "rateSegue", sender: Any?.self)
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
