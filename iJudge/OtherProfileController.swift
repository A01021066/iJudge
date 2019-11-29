//
//  OtherProfileController.swift
//  iJudge
//
//  Created by Ryan S on 2019-10-10.
//  Copyright © 2019 BCIT. All rights reserved.
//

import UIKit

class OtherProfileController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var commentScore: UILabel!
    @IBOutlet weak var ratingSlider: UISlider!
    @IBOutlet weak var commentField: UITextField!
    
    let step: Float = 10
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ratingSlider.setValue(0, animated: false)
        // Do any additional setup after loading the view.
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
