//
//  ViewController.swift
//  TextValidation
//
//  Created by Nodirbek on 14/06/22.
//

import UIKit

class ViewController: UIViewController {
    
    let firstTextField: UITextField = {
        let txt = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        txt.backgroundColor = .gray
        txt.layer.cornerRadius = 10
        txt.textColor = .white
        txt.textAlignment = .center
        return txt
    }()
    
    let emailTextField: UITextField = {
        let txt = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        txt.backgroundColor = .gray
        txt.layer.cornerRadius = 10
        txt.textColor = .white
        txt.textAlignment = .center
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameValidtype: String.ValidTypes = .name
    let emailValidtype: String.ValidTypes = .email
    let passwordValidType: String.ValidTypes = .password
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(firstTextField)
        view.addSubview(emailTextField)
        view.addSubview(label)
        view.addSubview(emailLabel)
        setupUI()
    }
    
    func setupUI(){
        firstTextField.delegate = self
        emailTextField.delegate = self
        firstTextField.center = view.center
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: firstTextField.bottomAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            label.heightAnchor.constraint(equalToConstant: 30),
            
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            emailTextField.widthAnchor.constraint(equalToConstant: 200),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            
            emailLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            emailLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            emailLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    // for checking textfield for regular expressions
    func setTextField(textfield: UITextField, label: UILabel, validType: String.ValidTypes, validMessage: String, wrongMessage: String, range: NSRange, string: String){
    
        let text = (textfield.text ?? "") + string
        let result: String
        
        if range.length == 1 {
            let end = text.index(text.startIndex, offsetBy: text.count - 1)
            result = String(text[text.startIndex..<end])
        }
        else {
            result = text
        }
        textfield.text = result
        
        if string.isValid(valueType: validType){
            label.isHidden = false
            label.text = validMessage
            label.textColor = .green
        }
        else {
            label.isHidden = false
            label.text = wrongMessage
            label.textColor = .red
        }
    }
    // Maska dlya telefona
    func setPhoneNumberMask(textField: UITextField, mask: String, string: String, range: NSRange) -> String {
        let text = textField.text ?? ""
        let phone = (text as NSString).replacingCharacters(in: range, with: string)
        let number = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        //[^+0-9]
        var result = ""
        var index = number.startIndex
        
        for character in mask where index < number.endIndex {
            if character == "X" {
                result.append(number[index])
                index = number.index(after: index)
            } else {
                result.append(character)
            }
        }
        
        print(result.count)
        if result.count == 19 {
            print("Valid")
            //label.text = "dsasdadsa"
            label.text = "Valid"
        }
        else {
            
            label.text = "Not valid"
        }
        return result
    }
    
    
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case firstTextField: firstTextField.text = setPhoneNumberMask(textField: firstTextField,
                                                                      mask: "+XXX (XX) XXX-XX-XX",
                                                                      string: string,
                                                                      range: range)
            
//        case firstTextField: setTextField(textfield: firstTextField,
//                                          label: label,
//                                          validType: passwordValidType,
//                                          validMessage: "Valid name",
//                                          wrongMessage: "Not valid name",
//                                          range: range,
//                                          string: string)
            
        case emailTextField: setTextField(textfield: emailTextField,
                                          label: emailLabel,
                                          validType: emailValidtype,
                                          validMessage: "Valid email",
                                          wrongMessage: "Not valid email",
                                          range: range,
                                          string: string)
            
        default: break
            
        }
        return false
    }
    
     
}

extension String {
    
    enum ValidTypes {
        case name
        case email
        case password
    }
    
    enum Regex: String { // Regular expression
        //Regex for name
        case name = "[a-zA-Z]{1,}"
        //Regex for email
        case email = "[a-zA-Z0-9._]+@[a-zA-Z0-9]+\\.[A-Za-z]{2,64}"
        //Regex for password
        case password = "(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{6,}"
    }
    
    func isValid(valueType: ValidTypes) -> Bool {
        let format = "SELF MATCHES %@"
        var regex = ""
        
        switch valueType {
        case .name:
            regex = Regex.name.rawValue
        case .email:
            regex = Regex.email.rawValue
        case .password:
            regex = Regex.password.rawValue
        }
        return NSPredicate(format: format, regex).evaluate(with: self)
    }
}

