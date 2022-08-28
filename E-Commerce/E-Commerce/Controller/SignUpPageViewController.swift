//
//  SignUpPageViewController.swift
//  E-Commerce
//
//  Created by Srijan Kumar  on 26/07/22.
//

import UIKit

class SignUpPageViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var RegisterButton: UIButton!
    @IBOutlet weak var FBButton: UIButton!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var LoginGoogle: UIButton!
    @IBOutlet weak var AddressField: UITextField!
    @IBOutlet weak var PhoneNumberField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func nameLabel(_ sender: Any) {
    }
    
    @IBAction func loginButton(_ sender: Any) {
        if let giveDetails = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "LoginPageController") as? LoginPageController{
            self.navigationController?.pushViewController(giveDetails, animated: true)
        }
    }
    
    @IBAction func passwordLabel(_ sender: Any) {
    }
    
    @IBAction func emailLabel(_ sender: Any) {
    }
    
    @IBAction func PhoneNumberField(_ sender: Any) {
    }
    
    @IBAction func AddressField(_ sender: Any) {
    }
    
    @IBAction func LoginGoogle(_ sender: Any) {
    }
    
    @IBAction func FBButton(_ sender: Any) {
    }
    
    @IBAction func RegisterButton(_ sender: Any) {
        let checkEmail: Bool = validEmail()
        let fieldsCheck: Bool = allFieldsAreFilled()
        let numberCheck: Bool = validPhoneNumber()
        if fieldsCheck == true {
            if checkEmail == true && numberCheck == true{
        registerCustomer()
        authenticateCustomer()
            }
            else {
                if numberCheck == false {
                    displayAlert(title: "SignUp Alert", message: "Phone Number Must Be In Range [0-9]")
                }
                else
                {
                    displayAlert(title: "SignUp Alert", message: "Invalid Email")
                }
            }
        }
        else {
            displayAlert(title: "SignUp Alert", message: "Please Fill All Fields")
        }
        
    }
    
    func displayAlert(title: String, message: String)
    {
        DispatchQueue.main.async {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        }
    }
    func allFieldsAreFilled() -> Bool{
        if (emailLabel.text != "") && (passwordLabel.text != "") && (AddressField.text != "") && (PhoneNumberField.text != "") && (nameLabel.text != ""){
            return true
        }
        return false
    }
    func validEmail() -> Bool{
        var countAtRate: Int = 0
        var charsAfter: Int = 0
        if let text = emailLabel.text{
            if text.count <= 6{
                return false
            }
            for item in text{
                if countAtRate >= 1{
                    charsAfter = charsAfter + 1
                }
                if item == "@"
                {
                    countAtRate = countAtRate + 1
                }
            }
            
            let domain = text.suffix(4)
            if domain != ".com" {
                print("mail: returned")
            return false
            }
        }
        print("last returned")
        return countAtRate == 1 && charsAfter > 4
    }
    
    func validPhoneNumber() ->Bool {
        if let phone = PhoneNumberField.text{
            for item in phone{
                if item < "0" || item > "9"
                {
                    return false
                }
            }
        }
        return true
    }
    
    func authenticateCustomer(){
        guard let url = URL(string: "http://10.20.4.158:8080/auth/registration") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "mailId": emailLabel?.text,
            "password": passwordLabel?.text,
            "isMerchant": false,
            "isCustomer": true
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data,error == nil else{
                return
            }
            do{
                let response = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                
                print("Success: \(response)")
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func registerCustomer(){
        guard let url = URL(string: "http://10.20.4.154:8081/customer") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "address" : AddressField.text,
            "name" : nameLabel.text,
            "contactNumber": PhoneNumberField.text,
            "emailId": emailLabel.text
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data,error == nil else{
                return
            }
            do{
                let response = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                if let dataString = String(data: data, encoding: .utf8) {
                    print("Response data string:\n \(dataString)")
                }
                print("Success: \(response)")
                DispatchQueue.main.async {
                    
                    let alert = UIAlertController(title: "SignUp Alert", message: "Successfully Registered, Kindly Login!!!!", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            catch {
                print(error)
            }
            
        }
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.delegate = self
        passwordLabel.delegate = self
        emailLabel.delegate = self
        AddressField.delegate = self
        PhoneNumberField.delegate = self
        setButton()
        self.passwordLabel.isSecureTextEntry = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func setButton(){
        RegisterButton.layer.cornerRadius = 5
        RegisterButton.layer.borderColor = UIColor.black.cgColor
        RegisterButton.layer.borderWidth = 1.0
        
        FBButton.layer.cornerRadius = 5
        FBButton.layer.borderColor = UIColor.black.cgColor
        FBButton.layer.borderWidth = 1.0
        
        LoginGoogle.layer.cornerRadius = 5
        LoginGoogle.layer.borderColor = UIColor.black.cgColor
        LoginGoogle.layer.borderWidth = 1.0
    }
    
}
