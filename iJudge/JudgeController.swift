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
    var otherUsers : [user] = []



    override func viewDidLoad() {
        _ = Auth.auth().currentUser?.uid
        super.viewDidLoad()
        loadCurrentUserNameScore()
        setTableViewDelegate()
        tableView.reloadData()
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
            self.userScore.text = String(score)
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
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberofrow called")
        return self.otherUsers.count
//        return 50
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cell called")
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        var name = cell.viewWithTag(1) as! UILabel
//        name.text = "WTF"
        name.text = self.otherUsers[indexPath.row].name
        var score = cell.viewWithTag(2) as! UILabel
//        score.text = "Hello"
        score.text = self.otherUsers[indexPath.row].score
        return cell
       }
    
    func setTableViewDelegate(){
        tableView.delegate = self
        tableView.dataSource = self
    }
}
