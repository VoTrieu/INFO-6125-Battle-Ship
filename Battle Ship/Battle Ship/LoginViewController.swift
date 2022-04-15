//
//  LoginViewController.swift
//  Battle Ship
//
//  Created by Tien Dao on 2022-04-15.
//

import UIKit
import FirebaseAuth


class LoginViewController: UIViewController {

    /**Variable and const**/
    var flagSuccess = 0;
    //Database of users' information
    let userAccount:[String:String] = ["test1@here.com":"password1", "test2@there.com":"password2","1":"2"]
    
    /**IBOutlet area**/
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var accountMsgError: UILabel!
    @IBOutlet weak var passwordMsgError: UILabel!
    
    @IBOutlet weak var submitBtn: UIButton!
    
    
    private var userIdentifer: String?
    private var mainSegue: String = "goToMain"
    
    
    /**Hepper functions**/
    /**TODO:  Hide or show the error message**/
    private func hideAllErrorMsg(state:Bool) {
        accountMsgError.isHidden = state;
        passwordMsgError.isHidden = state;
    }
    
    /**TODO: Check if textField empty or not to change state of error messages**/
    private func checkEmptyField() {
        accountMsgError.isHidden = accountTextField.text == "" ? false : true;
        passwordMsgError.isHidden = passwordTextField.text == "" ? false : true;
    }
    /**TODO:  Both email and password must have value for login button enable**/
    private func changeSubmitBtn() {
        if (accountTextField.text != "" && passwordTextField.text != "") {
            submitBtn.isEnabled = true
        } else {
            submitBtn.isEnabled = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /**Initial state**/
        submitBtn.isEnabled = false;
        hideAllErrorMsg(state:true);
    }
    
    /**When user typing account, the error will disappear**/
    @IBAction func accountEditingChanged(_ sender: UITextField) {
        accountMsgError.isHidden = accountTextField.text == "" ? false : true;
        changeSubmitBtn();
    }
    
    /**When user typing password, the error will disappear**/
    @IBAction func passwordEditingChanged(_ sender: UITextField) {
        passwordMsgError.isHidden = passwordTextField.text == "" ? false : true;
        changeSubmitBtn();
    }
    
    /**When submit button is tapped*/
    @IBAction func onSubmitBtnTapped(_ sender: UIButton) {
        
        checkEmptyField() //Show the error message if any field is empty
        authenticate()
    }
    
    private func authenticate() {
        let account = accountTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        if (account != "" && password != "") {
            Auth.auth().signIn(withEmail: account, password: password) { [weak self] authResult, error in
                guard let strongSelf = self else { return }
                if error != nil {
                    
                    // note we don't need to do optional binding because we don't care about using 'error'
                    strongSelf.showAlert(message: "Error authenticating user")
                    return
                }
                strongSelf.performSegue(withIdentifier: strongSelf.mainSegue, sender: strongSelf)
            }
        }

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
