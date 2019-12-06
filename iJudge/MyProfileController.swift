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

class MyProfileController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var otherUsers : [user] = []
    var comments : [String] = []
    @IBOutlet weak var userScore: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var commentTable: UITableView!
    var ref: DatabaseReference! = Database.database().reference()
    let uid = Auth.auth().currentUser?.uid
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTable.delegate = self
        commentTable.dataSource = self
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
            self.userScore.text = String(format: "%.1f",score)
        }

          }) { (error) in
            print(error.localizedDescription)
        }
    }
    
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
                        newUser.score = String((scoreS!) / (scoreC!))
                    }
                    self.otherUsers.append(newUser)
                }
            }
        })
    }
    
    @IBAction func signOut(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
          print (signOutError)
            
        }
        print("signed out")
        self.performSegue(withIdentifier: "signOutSegue", sender: self)
    }
    

    @IBAction func back(_ sender: UIButton) {
        print(self.otherUsers)
        self.performSegue(withIdentifier: "backSegue", sender: Any?.self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
              let name = cell.viewWithTag(4) as! UILabel
        name.text = self.comments[indexPath.row]
        return cell
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
