//
//  MyProfileController.swift
//  iJudge
//
//  Created by Ryan S on 2019-10-10.
//  Copyright © 2019 BCIT. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class MyProfileController: UIViewController {
    @IBOutlet weak var userScore: UILabel!
    @IBOutlet weak var userName: UILabel!
    var ref: DatabaseReference! = Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        let uid = Auth.auth().currentUser?.uid
        ref.child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            
        // Get user value
        let value = snapshot.value as? NSDictionary
        let username = value?["username"] as? String ?? ""
        self.userName.text = username
        print(username)
        let scoreCount = value?["scoreCount"] as? Int
        if (scoreCount == 0) {
            self.userScore.text = "0"
        } else {
            let scoreSum = value?["scoreSum"] as? Int
            let score = Double(Double(scoreSum!) / Double(scoreCount!))
            self.userScore.text = String(score)
        }

          }) { (error) in
            print(error.localizedDescription)
        }
    }
    //gCeZjnLI3dOZmYVIaCin4avaDo03
    //ryanboy

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
