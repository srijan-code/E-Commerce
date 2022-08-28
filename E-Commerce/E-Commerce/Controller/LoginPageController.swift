//
//  ViewController.swift
//  E-Commerce
//
//  Created by Srijan Kumar  on 26/07/22.
//

import UIKit

class LoginPageController: UIViewController {
    
    @IBOutlet weak var EnterButton: UIButton!
    @IBOutlet weak var GoogleButton: UIButton!
    @IBOutlet weak var FBLoginButton: UIButton!
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var blibliLogo: UIImageView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var SignUpButton: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func EnterButton(_ sender: Any) {
        if self.emailField.text != "" && self.passwordField.text !=  ""{
        checkValidity()
        }
        else{
            DispatchQueue.main.async {
            let alert = UIAlertController(title: "Login Alert", message: "Please Enter both Email and Password", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func FBLoginButton(_ sender: Any) {
    }
    
    @IBAction func GoogleButton(_ sender: Any) {
    }
    
    @IBAction func emailField(_ sender: Any) {
    }
    
    @IBAction func passwordField(_ sender: Any) {
    }
    
    @IBAction func SignUpButton(_ sender: Any) {
        if let giveDetails = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SignUpPageViewController") as? SignUpPageViewController{
            navigationController?.pushViewController(giveDetails, animated: true)
        }
    }
    
    @IBAction func FaceBookLogin(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButton()
        self.passwordField.isSecureTextEntry = true
    }
    
    func checkValidity(){
        guard let url = URL(string: "http://10.20.4.158:8080/auth/login") else {
            
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: String?] = [
            "mailId": emailField?.text,
            "password": passwordField?.text,
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data,error == nil else{
                return
            }
            if let emailId = self.parseJSON(data){
                DispatchQueue.main.async {
                    
                    if let giveDetails = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "LandingPageViewController") as? LandingPageViewController{
                        giveDetails.userEmail = emailId
                        self.navigationController?.pushViewController(giveDetails, animated: true)
                    }
                }
                
                
            }
            else
            {
                DispatchQueue.main.async {
                    
                let alert = UIAlertController(title: "Login Alert", message: "Credentials Are Wrong", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                }
            }
            
            
            
        }
        task.resume()
        
        
        
    }
    
    func parseJSON(_ fetchedData : Data) -> String?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(LoginCredential?.self, from: fetchedData)
            let name = decodedData?.mailId
            return name
        } catch {
            print("error in parseJSON")
            return nil
        }
    }
    func setBehaviour(button: UIButton)
    {
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.0
    }
    func setButton(){
        
        setBehaviour(button: EnterButton)
        setBehaviour(button: FBLoginButton)
        setBehaviour(button: GoogleButton)
    }
    
    func setDisplayLabel()
    {
        displayLabel.layer.cornerRadius = 20.0
        displayLabel.layer.masksToBounds = true
    }
}

