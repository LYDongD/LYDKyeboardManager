//
//  LYKeyboardManager.swift
//  键盘遮挡处理
//
//  Created by 李民舟 on 16/2/1.
//  Copyright © 2016年 com.fengdikeji. All rights reserved.
//

import UIKit

struct BasicValue {
    static var offSet: CGFloat = 0.0
    static let screenHeight = UIScreen.mainScreen().bounds.size.height
}

class LYKeyboardManager: NSObject {

    var view: UIView
    var inputView: UIView
    var cover: UIView?
    
    init(translateView: UIView, inputView: UIView) {
        self.view = translateView
        self.inputView = inputView
        super.init() //向上代理
    }
    
    func addObserver() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func removeObserver() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    // 处理键盘
    func keyboardShow(notification: NSNotification) {
        print("\(notification)")
        
        //取出信息
        let userInfo = notification.userInfo! as NSDictionary
        
        //1 键盘高度
        let keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().size.height
        
        //2 时间
        let duration: NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        //3 设置动画方式
        let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue))
        
        //4 向上平移
        print("\(self.inputView)")
        let delta = keyboardHeight - (BasicValue.screenHeight - CGRectGetMaxY(self.inputView.frame))
        if delta > 0 { //遮挡时才平移
            UIView.animateWithDuration(duration, delay: 0, options:options, animations: { [weak self]() -> Void in
                
                if let strongSelf = self {
                    strongSelf.view.transform = CGAffineTransformMakeTranslation(0, -delta - BasicValue.offSet)
                }
                }) { (Bool) -> Void in
                    print("处理完毕啦")
            }

        }
        
        //5 添加蒙板
        addCover()

    }
    
    func addCover() {
        cover = UIView(frame: self.view.bounds)
        self.view.addSubview(cover!)

        
        let tap = UITapGestureRecognizer(target: self, action: Selector("coverTapped"))
        cover!.addGestureRecognizer(tap)
    }
    
    func removeCover() {
        cover?.removeFromSuperview()
        cover = nil
    }
    
    func coverTapped() {
        self.view.endEditing(true)
        removeCover()
    }
    
    
    func keyboardHide(notification: NSNotification) {
        //取出信息
        let userInfo = notification.userInfo! as NSDictionary
        
        //2 时间
        let duration: NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        //3 设置动画方式
        let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue))
        
        //4 向下平移
        UIView.animateWithDuration(duration, delay: 0, options: options, animations: { [weak self]() -> Void in
            if let strongSelf = self {
                strongSelf.view.transform = CGAffineTransformIdentity
            }
            
            }) { (Bool) -> Void in
                print("处理完毕啦")
        }
        
        //5 移除监听
        self.removeObserver()
        
    }
    
}
