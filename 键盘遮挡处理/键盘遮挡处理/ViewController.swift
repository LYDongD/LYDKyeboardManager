//
//  ViewController.swift
//  键盘遮挡处理
//
//  Created by 李民舟 on 16/2/1.
//  Copyright © 2016年 com.fengdikeji. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var keyboardManager: LYKeyboardManager?
    @IBOutlet weak var inputBackView: UIView!
    @IBOutlet weak var centerView: UITextField!
    @IBOutlet weak var inputFiled: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centerView.delegate = self
        inputFiled.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        //监听键盘通知
        var input: UIView
        if textField == self.inputFiled {
            input = self.inputBackView
        }else{
            input = textField
        }
        keyboardManager = LYKeyboardManager(translateView: self.view,inputView: input)
        keyboardManager?.addObserver()
        return true
    }
}