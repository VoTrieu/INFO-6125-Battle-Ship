//
//  SignUpViewController.swift
//  Battle Ship
//
//  Created by Tien Dao on 2022-04-15.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {

    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var accountMsgError: UILabel!
    @IBOutlet weak var passwordMsgError: UILabel!
    @IBOutlet weak var userNameMsgError: UILabel!
    
    @IBOutlet weak var signUpBtn: UIButton!
    
    private var logInSegue: String = "goToLogIn"
    
    
    /**Hepper functions**/
    /**TODO:  Hide or show the error message**/
    private func hideAllErrorMsg(state:Bool) {
        accountMsgError.alpha = state ? 0.0 : 1.0;
        passwordMsgError.alpha = state ? 0.0 : 1.0;
        userNameMsgError.alpha = state ? 0.0 : 1.0;
    }
    
    /**TODO: Check if textField empty or not to change state of error messages**/
    private func checkEmptyField() {
        accountMsgError.alpha = accountTextField.text == "" ? 1.0 : 0.0;
        passwordMsgError.alpha = passwordTextField.text == "" ? 1.0 : 0.0;
        userNameMsgError.alpha = userNameTextField.text == "" ? 1.0 : 0.0;
    }
    /**TODO:  Both email and password must have value for login button enable**/
    private func changeSubmitBtn() {
        if (accountTextField.text != "" && passwordTextField.text != "" && userNameTextField.text != "") {
            signUpBtn.isEnabled = true
        } else {
            signUpBtn.isEnabled = false
        }
    }
    
    @IBAction func accountEditingChanged(_ sender: UITextField) {
            accountMsgError.alpha = accountTextField.text == "" ? 1.0 : 0.0;
            changeSubmitBtn();
    }
        
    @IBAction func passwordEditingChanged(_ sender: UITextField) {
        passwordMsgError.alpha = passwordTextField.text == "" ? 1.0 : 0.0;
        changeSubmitBtn();
    }
    
    @IBAction func userNameEditingChanged(_ sender: UITextField) {
        userNameMsgError.alpha = userNameTextField.text == "" ? 1.0 : 0.0;
        changeSubmitBtn();
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /**Initial state**/
        signUpBtn.isEnabled = false;
        hideAllErrorMsg(state:true);
    }
    
    @IBAction func signUpBtnTapped(_ sender: UIButton) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        if let account = accountTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: account, password: password)
                {(result, error) in
                if let _eror = error {
                    //something bad happning
                    print(_eror.localizedDescription )
                    self.showAlert(message: "Error: \(_eror.localizedDescription)")
                
                }else{
                    //user registered successfully
                    print(result!)
                    ref.child("users").child((result?.user.uid)!).setValue(
                        ["username": self.userNameTextField.text!,
                         "score": 0
                        ])
                    self.dismiss(animated: true, completion: nil)
                    self.performSegue(withIdentifier: self.logInSegue, sender: self)
                }
                
            }
        }
        
    }
    


    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: self.logInSegue, sender: self)
    }
    
    
    private func showAlert (message: String) {
        let alert = UIAlertController(title: "Battle Ship game", message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { _ in }
        alert.addAction(okButton)
        self.show(alert, sender: nil)
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

