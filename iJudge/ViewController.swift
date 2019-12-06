import UIKit
import FirebaseAuth
import FirebaseDatabase
var ref: DatabaseReference! = Database.database().reference()


public extension UIResponder {

    private struct Static {
        static weak var responder: UIResponder?
    }

    static func currentFirst() -> UIResponder? {
        Static.responder = nil
        UIApplication.shared.sendAction(#selector(UIResponder._trap), to: nil, from: nil, for: nil)
        return Static.responder
    }

    @objc private func _trap() {
        Static.responder = self
    }
}
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
    func addKeyboardObserver() {

            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(self.keyboardNotifications(notification:)),
                                                   name: UIResponder.keyboardWillChangeFrameNotification,
                                                   object: nil)
        }

    func removeKeyboardObserver(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    // This method will notify when keyboard appears/ dissapears
    @objc func keyboardNotifications(notification: NSNotification) {

        var accurateY = 0.0  //Using this we will calculate the selected textFields Y Position

        if let activeTextField = UIResponder.currentFirst() as? UITextField {
            // Here we will get accurate frame of which textField is selected if there are multiple textfields
            let frame = self.view.convert(activeTextField.frame, from:activeTextField.superview)
            accurateY = Double(frame.origin.y) + Double(frame.size.height)
        }

        if let userInfo = notification.userInfo {
            // here we will get frame of keyBoard (i.e. x, y, width, height)

            let keyBoardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let keyBoardFrameY = keyBoardFrame!.origin.y

            var newHeight: CGFloat = 0.0
            //Check keyboards Y position and according to that move view up and down
            if keyBoardFrameY >= UIScreen.main.bounds.size.height {
                newHeight = 0.0
            } else {
                if accurateY >= Double(keyBoardFrameY) { // if textfields y is greater than keyboards y then only move View to up
                    if #available(iOS 11.0, *) {
                        newHeight = -CGFloat(accurateY - Double(keyBoardFrameY)) - self.view.safeAreaInsets.bottom
                    } else {
                        newHeight = -CGFloat(accurateY - Double(keyBoardFrameY)) - 5
                    }
                }
            }
            //set the Y position of view
            self.view.frame.origin.y = newHeight
        }
    }
    struct user {
        var name: String?
        var id: String?
        var score : String?
        var comment: [String]?
    }
}

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    var otherUsers : [user] = []
    
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      if textField == userName {
         textField.resignFirstResponder()
         password.becomeFirstResponder()
      } else if textField == password{
         textField.resignFirstResponder()

      }
     return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addKeyboardObserver()
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.removeKeyboardObserver()
    }
    
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

