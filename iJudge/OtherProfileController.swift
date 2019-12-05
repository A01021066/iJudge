//
//  OtherProfileController.swift
//  iJudge
//
//  Created by Ryan S on 2019-10-10.
//  Copyright © 2019 BCIT. All rights reserved.
//

import UIKit

class OtherProfileController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var commentScore: UILabel!
    @IBOutlet weak var ratingSlider: UISlider!
    @IBOutlet weak var commentField: UITextField!
    
    let step: Float = 10
    var userId: String?
    @IBOutlet weak var name: UILabel!
    
    
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
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        ratingSlider.setValue(0, animated: false)
        name.text = userId
        // Do any additional setup after loading the view.
    }
    
    


}
