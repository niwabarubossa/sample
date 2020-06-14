//
//  HenshuuViewController.swift
//  sample
//
//  Created by Ni Ryogo on 2020/06/14.
//  Copyright © 2020 Ni Ryogo. All rights reserved.
//

import UIKit

class HenshuuViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate {
    var isUP = false
    
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textView1: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textField1.delegate = self
        self.textView1.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpNotificationForTextField()
    }
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        // self.textField1.resignFirstResponder()でもOK
        print("てきすとが押された")
        if self.isUP == true {
          NotificationCenter.default.post(name: UIResponder.keyboardWillHideNotification, object: nil)
            self.isUP = false
        }
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // textField.　としても良いし
        // self.textField1.  でもOK
        if self.isUP == true {
          NotificationCenter.default.post(name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        return true
    }
    
    
    //textViewが選ばれたときに呼ばれる処理
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool
     {
        print("text view begin")
      //  textView.　としても良いし　self.textView1 としても良い
        if self.isUP == false {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fortextViewSpace"), object: nil)
            self.isUP = true
        }
        return true
     }
     //textviewからフォーカスが外れて、TextViewが空だったらLabelを再び表示
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            //あなたのテキストフィールド
            NotificationCenter.default.post(name: UIResponder.keyboardWillShowNotification, object: nil)
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if self.isUP == false {
            NotificationCenter.default.post(name: UIResponder.keyboardWillShowNotification, object: nil)
            self.isUP = true
        }
        return true
    }
    func setUpNotificationForTextField() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.handleKeyboardWillShowNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.handleKeyboardWillHideNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc private func handleKeyboardWillShowNotification(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any] else { return }
        let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardY = self.view.frame.size.height - keyboardSize.height //画面全体の高さ - キーボードの高さ = キーボードが被らない高さ
        let editingTextFieldY: CGFloat = (self.textField1!.frame.origin.y)
        if editingTextFieldY > keyboardY - 60 {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
                self.view.frame = CGRect(x: 0, y: self.view.frame.origin.y - (editingTextFieldY - (keyboardY - 60)), width: self.view.bounds.width, height: self.view.bounds.height)
            }, completion: nil)
            self.isUP = true
        }
    }
    
    @objc private func handleKeyboardWillHideNotification(_ notification: Notification) {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        }, completion: nil)
         self.isUP = false
    }
    
    


}
