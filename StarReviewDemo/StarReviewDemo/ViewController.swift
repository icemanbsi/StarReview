//
//  ViewController.swift
//  StarReviewDemo
//
//  Created by Tyrant on 12/4/15.
//  Copyright © 2015 Qfq. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {
    var star:StarReview?
    var slider:UISlider?
    var lblStarLevel:UILabel?
    var txtStarValue:UITextField?
    var btnBarLeft:UIBarButtonItem?
    var colors = UIColor.allStarColor()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        star = StarReview(frame: CGRect(x: 15, y: 100, width: 200, height: 50))
         star?.starMarginScale = 0.4;
        star!.value = 2
        star?.starCount = 6
        star?.allowAccruteStars = true
        star!.addTarget(self, action: "valueChange:", forControlEvents: UIControlEvents.ValueChanged)
        view.addSubview(star!)
        
        let btnBar = UIBarButtonItem(title: "换色", style: UIBarButtonItemStyle.Plain, target: self, action: "changeColor")
        navigationItem.rightBarButtonItem = btnBar
        btnBarLeft = UIBarButtonItem(title: "整数化", style: UIBarButtonItemStyle.Plain, target: self, action: "inter")
        navigationItem.leftBarButtonItem = btnBarLeft!
        lblStarLevel = UILabel(frame: CGRect(x: 0, y: 180, width: 200, height: 20))
        lblStarLevel?.textColor = UIColor.blackColor()
        view.addSubview(lblStarLevel!)
        slider = UISlider(frame: CGRect(x: 0, y: 200, width: UIScreen.mainScreen().bounds.width, height: 50))
        slider?.maximumValue = Float(star!.starCount)
        slider?.minimumValue = 0
        slider?.addTarget(self, action: "sliderChangeValue:", forControlEvents: UIControlEvents.ValueChanged)
        view.addSubview(slider!)
        txtStarValue = UITextField(frame: CGRect(x: 200, y: 175, width: 100, height: 30))
        txtStarValue?.keyboardType = UIKeyboardType.DecimalPad
        txtStarValue?.delegate = self;
        txtStarValue?.layer.borderWidth = 0.5
        txtStarValue?.layer.borderColor = UIColor.redColor().CGColor
        view.addSubview(txtStarValue!)
    }

    
    func valueChange(sender:StarReview){
        slider?.value = sender.value
        lblStarLevel?.text = "分数值\(sender.value)"
    }
    
    func changeColor(){
        let index = Int(arc4random()) % colors.count
        star!.starFillColor = colors[index]
    }
    
    func sliderChangeValue(sender:UISlider){
        print("SliderValue:\(sender.value)")
        star!.value = sender.value
    }
    
    func inter(){
        star?.allowAccruteStars = !star!.allowAccruteStars
        btnBarLeft?.title = star!.allowAccruteStars ? "非整数化" : "整数化"
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if let value:NSString = textField.text{
            star?.value = value.floatValue
        }
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        txtStarValue?.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


extension UIColor {
    static func allStarColor()->[UIColor]{
        return [UIColor.redColor(),UIColor.blackColor(),UIColor.blueColor(),UIColor.brownColor(),UIColor.whiteColor(),UIColor.orangeColor(),UIColor.purpleColor(),UIColor.grayColor(),UIColor.lightGrayColor(),UIColor.lightTextColor(),UIColor.darkGrayColor(),UIColor.darkTextColor(),UIColor.cyanColor(),UIColor.yellowColor(),UIColor.magentaColor(),UIColor.clearColor()]
    }
    static  func starColorFromString(color:String)->UIColor{
        var colorString = (color as NSString).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString as NSString
        if colorString.length < 3{
            return UIColor.clearColor()
        }
        if colorString.hasPrefix("0X"){
            colorString = colorString.substringFromIndex(2)
        }
        if colorString.hasPrefix("#")
        {
            colorString = colorString.substringFromIndex(1)
        }
        var alpha:CGFloat = 1.0
        var red:CGFloat = 0
        var green:CGFloat = 0
        var blue:CGFloat = 0
        switch colorString.length{
        case 3:
            red = starColorComponentFrom(colorString, start: 0, length: 1)
            green = starColorComponentFrom(colorString, start: 1, length: 1)
            blue = starColorComponentFrom(colorString, start: 2, length: 1)
        case 4:
            alpha = starColorComponentFrom(colorString, start: 0, length: 1)
            red = starColorComponentFrom(colorString, start: 1, length: 1)
            green = starColorComponentFrom(colorString, start: 2, length: 1)
            blue = starColorComponentFrom(colorString, start: 3, length: 1)
        case 6:
            red = starColorComponentFrom(colorString, start: 0, length: 2)
            green = starColorComponentFrom(colorString, start: 2, length: 2)
            blue = starColorComponentFrom(colorString, start: 4, length: 2)
        case 8:
            alpha = starColorComponentFrom(colorString, start: 0, length: 2)
            red = starColorComponentFrom(colorString, start: 2, length: 2)
            green = starColorComponentFrom(colorString, start: 4, length: 2)
            blue = starColorComponentFrom(colorString, start: 6, length: 2)
            
        default: return UIColor.clearColor()
        }
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
func starColorComponentFrom(str:NSString,start:UInt,length:UInt)->CGFloat{
    let subStr = str.substringWithRange(NSMakeRange(Int(start), Int(length)))
    let fullHex = length == 2 ? subStr: NSString(format: "%@%@", subStr,subStr)
    let hexComponent:UnsafeMutablePointer<UInt32> =  UnsafeMutablePointer<UInt32>()
    NSScanner(string: fullHex as String).scanHexInt(hexComponent)
    return CGFloat(hexComponent.memory as UInt32) / CGFloat(255.0)
}
