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



class JudgeController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userScore: UILabel!
    
    var comments : [String] = []
    var otherUsers : [user] = []
    var uid = Auth.auth().currentUser?.uid
    var ratingID : Int = -1


    override func viewDidLoad() {

        super.viewDidLoad()
        loadCurrentUserNameScore()
        setTableViewDelegate()
        tableView.reloadData()
        loadComments()
    }
    
    func loadCurrentUserNameScore() {
        let uid = Auth.auth().currentUser?.uid

        ref.child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            
        // Get user value
        let value = snapshot.value as? NSDictionary
        let username = value?["username"] as? String ?? ""
        self.userName.text = username
        let scoreCount = value?["scoreCount"] as? Int
        if (scoreCount == 0) {
            self.userScore.text = "0"
        } else {
            let scoreSum = value?["scoreSum"] as? Int
            let score = Double(Double(scoreSum!) / Double(scoreCount!))
            self.userScore.text = String(format: "%.1f", score)
        }

          }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 345
    }

        // Do any additional setup after loading the view
    
    @IBAction func signOut(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
          print (signOutError)
            
        }

        self.performSegue(withIdentifier: "signOutSegue", sender: self)
    }
    
    @IBAction func goToMyProfile(_ sender: UIButton) {
        self.performSegue(withIdentifier: "myProfileSegue", sender: Any?.self
        )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.destination is OtherProfileController
        {
            let otherPage = segue.destination as? OtherProfileController
            otherPage?.userID = self.ratingID - 100
            otherPage?.otherUsers = self.otherUsers
        } else if segue.destination is MyProfileController
        {
            let otherPage = segue.destination as? MyProfileController
            otherPage?.otherUsers = self.otherUsers
            otherPage?.comments = self.comments
        } 
    }

    @IBAction func rate(_ sender: UIButton) {
        ratingID = sender.tag
        self.performSegue(withIdentifier: "rateSegue", sender: Any?.self)
    }
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.otherUsers.count
//        return 50
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
            let name = cell.viewWithTag(1) as! UILabel
            name.text = self.otherUsers[indexPath.row].name
            let score = cell.viewWithTag(2) as! UILabel
            score.text = self.otherUsers[indexPath.row].score
            let button = cell.viewWithTag(3) as! UIButton
            button.tag = indexPath.row + 100
            return cell
       }
    
    func loadComments(){
        ref.child("users").child(self.uid!).child("comments").observeSingleEvent(of: .value, with: { (snapshot) in
            for elem in snapshot.children {
                let snap = elem as! DataSnapshot
                let comment = snap.value as! String
                self.comments.append(comment)
            }
        })
    }
    
    func setTableViewDelegate(){
        tableView.delegate = self
        tableView.dataSource = self
    }
}
