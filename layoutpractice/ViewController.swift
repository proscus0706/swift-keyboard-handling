//
//  ViewController.swift
//  layoutpractice
//
//  Created by shin seunghyun on 2020/03/21.
//  Copyright © 2020 shin seunghyun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputViewBottomMargin: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    
    var chatData: [String] = ["Hi", "Hello"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        tableView.register(UINib(nibName: "MyTableViewCell", bundle: nil), forCellReuseIdentifier: "MyCell")
        tableView.register(UINib(nibName: "YouTableViewCell", bundle: nil), forCellReuseIdentifier: "YouCell")
//        tableView.rowHeight = UITableView.automaticDimension
       
        textView.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        //Keyboard Notification, 키보드가 올라왔는지 내려왔는지 확인
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keybooardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
      //observer 지워주기
      NotificationCenter.default.removeObserver(self)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        //키보드의 높이를 가져오는 작업
        let notificationInfo = notification.userInfo! as NSDictionary
        let keyboardFrame = notificationInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        let height = keyboardFrame!.size.height
        inputViewBottomMargin.constant = height //bottom constraint 에 keyboard 높이 값을 넣어준다.
        
        //애니메이션 추가.
        //키보드의 움직이는 시간을 가져와야 함.
        //그 시간만큼 텍스트 인풋뷰를 애니메이션 형태로 올라오게 만들면 자연스럽게 보인다.
        
        let animationDuration = notificationInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        UIView.animate(withDuration: animationDuration){
            self.view.layoutIfNeeded()
        }
        
    }
    
    @objc func keybooardWillHide(notification: NSNotification) {
        inputViewBottomMargin.constant = 0
        let notificationInfo = notification.userInfo! as NSDictionary
        let animationDuration = notificationInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
  
    @IBAction func sendButtonClicked(_ sender: UIButton) {
        
        if let text = textView.text {
            chatData.append(text)
            textView.text = ""
            tableView.reloadData()
        }
        
        if self.chatData.count > 0 {
            self.tableView.scrollToRow(at: IndexPath(item: chatData.count - 1, section: 0), at: UITableView.ScrollPosition.bottom, animated: true)
        }
        
        self.textViewDidChange(textView)
        
    }
    
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaultCell: UITableViewCell
        if indexPath.row % 2 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! MyTableViewCell
            cell.bubbleText.text = chatData[indexPath.row]
            defaultCell = cell
            print("My Cell Printed")
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "YouCell", for: indexPath) as! YouTableViewCell
            cell.bubbleText.text = chatData[indexPath.row]
            defaultCell = cell
            print("You Cell Printed")
        }
        defaultCell.selectionStyle = .none
        return defaultCell
        
    }
    
    
}

extension ViewController: UITextViewDelegate {
    
    //항상 contentSize와 offset size를 같이 생각하면서 한다.
    func textViewDidChange(_ textView: UITextView) {
        //늘어나는 line 제어
        if textView.contentSize.height <= 83 {
            //textview constraint 아래 잡고 값을 줌.
            textViewHeight.constant = textView.contentSize.height
            //content가 딱 맞게 됨. 하지만 지금은 이걸 호출 안해도 잘된다.
            textView.setContentOffset(CGPoint.zero, animated: false)
            self.view.layoutIfNeeded()
        }
    }
    
}
