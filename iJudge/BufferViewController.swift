//
//  BufferViewController.swift
//  iJudge
//
//  Created by Louis on 2019-12-06.
//  Copyright © 2019 BCIT. All rights reserved.
//


import UIKit
import FirebaseAuth
import FirebaseDatabase



class BufferViewController: UIViewController {
    
    var otherUsers: [user] = []
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is JudgeController
        {

                let otherPage = segue.destination as? JudgeController
                otherPage?.otherUsers = self.otherUsers
            
        }
    }
    
    func loadOtherUsers() {
                self.otherUsers = []
        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let userData = snap.value as? NSDictionary
                let scoreC = userData!["scoreCount"] as? Double
                let scoreS = userData!["scoreSum"] as? Double
                if (userData!["user_id"] as? String != Auth.auth().currentUser?.uid){
                    var newUser = user()
                    newUser.id = userData!["user_id"] as? String
                    newUser.name = userData!["username"] as? String
                    if (scoreC == 0){
                        newUser.score = "0"
                    } else {
                        newUser.score = String(format:"%.1f", (scoreS!) / (scoreC!))
                    }
                    self.otherUsers.append(newUser)
                }
            }
        })
    }
    
    override func viewDidLoad(){
        loadOtherUsers()
        perform(#selector(buffer), with: nil, afterDelay: 2)
    }
    
    @objc
    func buffer(){
        print(self.otherUsers)
        performSegue(withIdentifier: "homePageSegue", sender: Any?.self)
    }
}
