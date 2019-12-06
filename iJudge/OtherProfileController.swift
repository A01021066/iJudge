import UIKit
import FirebaseDatabase
import FirebaseAuth

class OtherProfileController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var commentScore: UILabel!
    @IBOutlet weak var ratingSlider: UISlider!
    @IBOutlet weak var commentField: UITextField!
    
    @IBOutlet weak var userScore: UILabel!
    let step: Float = 10
    var userID: Int?
    @IBOutlet weak var name: UILabel!
    var otherUsers : [user] = []
    var ref: DatabaseReference! = Database.database().reference()
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      if textField == commentField{
         textField.resignFirstResponder()
      }
     return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
        self.removeKeyboardObserver()
    }
    
    @IBAction func changeRating(_ sender: UISlider) {
        let roundedValue = round(sender.value * step)

        commentScore.text = String(format:"%.0f", roundedValue)
    }
    
    @IBAction func submitRating(_ sender: UIButton) {
        let score = Int(round(ratingSlider.value * step))
        let uid = otherUsers[userID!].id! as? String
        ref.child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let scoreCount = value?["scoreCount"] as? Int
            let scoreSum = value?["scoreSum"] as? Int
            let scoreC = value?["scoreCount"] as? Double
            let scoreS = value?["scoreSum"] as? Double
            var comments: [String] = []
            if (value?["comments"] == nil){
                comments.append(self.commentField.text!)
                self.ref.child("users/\(uid!)/comments").setValue(comments)
            } else {
                comments = value?["comments"] as! [String]
                if (!self.commentField.text!.isEmpty){
                    comments.append(self.commentField.text!)
                }
                self.ref.child("users/\(uid!)/comments").setValue(comments)
            }
            self.ref.child("users/\(uid!)/scoreCount").setValue(scoreCount!+1)
            self.ref.child("users/\(uid!)/scoreSum").setValue(scoreSum! + score)
            self.userScore.text = String(format:"%.1f", (scoreS! + Double(score)) / (scoreC! + Double(1)))
            })
        loadOtherUsers()
        let alert = UIAlertController(title: "", message: "Judged", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is JudgeController
        {
            let otherPage = segue.destination as? JudgeController
            otherPage?.otherUsers = self.otherUsers
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ratingSlider.setValue(0, animated: false)
        name.text = otherUsers[userID!].name
        userScore.text = otherUsers[userID!].score
        
        commentField.attributedPlaceholder =
        NSAttributedString(string: "Add your anonymous comment here", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    @IBAction func signOut(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
          print (signOutError)
            
        }
        self.performSegue(withIdentifier: "signOutSegue", sender: self)
    }
    

    @IBAction func back(_ sender: UIButton) {
        self.performSegue(withIdentifier: "backSegue", sender: Any?.self)
    }
    
}
