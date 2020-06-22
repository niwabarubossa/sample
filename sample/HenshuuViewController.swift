//
//  HenshuuViewController.swift
//  sample
//
//  Created by Ni Ryogo on 2020/06/14.
//  Copyright © 2020 Ni Ryogo. All rights reserved.
//

import UIKit
import UserNotifications

enum ActionIdentifier: String {
    case actionOne
    case actionTwo
}

class HenshuuViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate {
    var isUP = false
    
        
    
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textView1: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textField1.delegate = self
        self.textView1.delegate = self
        
        self.createAndRegisterNotify()
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

extension HenshuuViewController:UNUserNotificationCenterDelegate{
    private func createAndRegisterNotify(){
        // アクション設定
        let actionOne = UNNotificationAction(identifier: ActionIdentifier.actionOne.rawValue,
                                            title: "アクション1",
                                            options: [.foreground])
        let actionTwo = UNNotificationAction(identifier: ActionIdentifier.actionTwo.rawValue,
                                            title: "アクション2",
                                            options: [.foreground])

        let category = UNNotificationCategory(identifier: "category_select",
                                              actions: [actionOne, actionTwo],
                                              intentIdentifiers: [],
                                              options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        UNUserNotificationCenter.current().delegate = self



        let content = UNMutableNotificationContent()
        content.title = "こんにちわ！"
        content.body = "アクションを選択してください！"
        content.sound = UNNotificationSound.default

        // categoryIdentifierを設定
        content.categoryIdentifier = "category_select"

        // 60秒ごとに繰り返し通知
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        let request = UNNotificationRequest(identifier: "notification",
                                            content: content,
                                            trigger: trigger)

        // 通知登録
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)

    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: () -> Swift.Void) {

        // 選択されたアクションごとに処理を分岐
        switch response.actionIdentifier {

        case ActionIdentifier.actionOne.rawValue:
            // 具体的な処理をここに記入
            self.view.backgroundColor = UIColor.green
            // 変数oneをカウントアップしてラベルに表示
            print("action one tapped!")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController2 = storyboard.instantiateViewController(withIdentifier: "SecondVC")
            self.present(viewController2, animated: true, completion: nil)
        case ActionIdentifier.actionTwo.rawValue:
            // 具体的な処理をここに記入
            self.view.backgroundColor = UIColor.blue
            
            print("action two tapped!")

        default:
            ()
        }

        completionHandler()
    }
    
}

extension HenshuuViewController:UISearchControllerDelegate{
    private func searchBarSetup(){
        
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.becomeFirstResponder()
    }
}
