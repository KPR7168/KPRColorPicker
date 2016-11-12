//
//  KPRColorPicker.swift
//  SwfitTest
//
//  Created by Ky Pichratanak on 11/6/16.
//  Copyright © 2016 Ky Pichratanak. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

protocol KPRColorPickerDelegate : class{
    func KPRColorPickerDidSelectWithUIColor(_ sender: UIColor)
}

enum GRADIENT {
    case horizontal
    case vertical
}

class KPRColorPicker: UIViewController{
    weak var delegate: KPRColorPickerDelegate?
    //private let COLOR_PICKER_VIEW_HEIGHT = CGFloat(290)
    
    fileprivate var dismissButton : UIButton!
    fileprivate var rgbButton : UIButton!
    fileprivate var mainColorPickerView : UIView!
    fileprivate var secondaryColorPickerView : UIView!
    fileprivate var mainColorSelectorImage : UIImageView!
    fileprivate var secondaryColorSelectorImage : UIImageView!
    fileprivate var selectedColor : UIColor!
    
    //MARK: contructor
    
    init(){
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = UIColor.gray
        
        self.createDismissButton()
        self.createRGBButton()
        self.createSecondaryPickerview()
        self.createMainColorPickerView()
        self.createMainColorSelector()
        self.createSecondaryColorSelector()
        selectedColor = self.colorOfPoint(point: self.mainColorSelectorImage.center,
                                          inView: self.mainColorPickerView)
        updateSecondaryPickerView(selectedColor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return .portrait
    }
    
    // MARK: build ui elements
    
    fileprivate func createDismissButton(){
        self.dismissButton = UIButton.init(frame: CGRect.init(x: 5, y: 10, width: 50, height: 50))
        self.dismissButton.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        self.dismissButton.setTitle("✕", for: .normal)
        self.dismissButton.setTitleColor(.black, for: .normal)
        self.dismissButton.addTarget(self,
                                     action: #selector(self.dismissButtonTouched(_:)),
                                     for: .touchUpInside)
        self.view.addSubview(self.dismissButton)
    }
    
    fileprivate func createRGBButton(){
        let origin = CGPoint.init(x: self.view.frame.origin.x / 2, y: 60)
        let size = CGSize.init(width: self.view.frame.size.width, height: 80)
        self.rgbButton = UIButton.init(frame: CGRect.init(origin: origin, size: size))
        self.rgbButton.titleLabel?.font = UIFont(name: "Helvetica-Light", size: 30)
        self.rgbButton.setTitle("rgb(247,39,39)", for: .normal)
        self.rgbButton.setTitleColor(.black, for: .normal)
        self.rgbButton.titleLabel?.numberOfLines = 0
        self.rgbButton.titleLabel?.textAlignment = .center
        self.rgbButton.showsTouchWhenHighlighted = true
        self.rgbButton.addTarget(self,
                                 action: #selector(self.rgbButtonTouched(_:)), for: .touchUpInside)
        
        self.view.addSubview(self.rgbButton)
    }
    
    fileprivate func createMainColorPickerView(){
        let WIDTH = CGFloat(44.00)
        let HEIGHT = self.secondaryColorPickerView.frame.size.width
        let size = CGSize.init(width: WIDTH, height: HEIGHT)
        let origin = CGPoint.init(x: (self.view.frame.size.width - WIDTH) - 15,
                                  y: (self.view.frame.size.height - HEIGHT) - 15)
        self.mainColorPickerView = UIView.init(frame: CGRect.init(origin: origin, size: size))
        
        let allGradientColor = [UIColor.red.cgColor,
                                UIColor.yellow.cgColor,
                                UIColor.green.cgColor,
                                UIColor.cyan.cgColor,
                                UIColor.blue.cgColor,
                                UIColor.magenta.cgColor,
                                UIColor.red.cgColor];
        let allColorGradient = gradientLayer(inView:self.mainColorPickerView,
                                             withColor: allGradientColor,
                                             orientation: .horizontal)
        
        self.mainColorPickerView.layer.addSublayer(allColorGradient)
        self.mainColorPickerView.layer.borderColor = UIColor.black.cgColor
        self.mainColorPickerView.layer.borderWidth = 1.0
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.mainPickerDidTap(_:)))
        tapGesture.numberOfTapsRequired = 1
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.mainPickerDidTap(_:)))
        
        self.mainColorPickerView.addGestureRecognizer(tapGesture)
        self.mainColorPickerView.addGestureRecognizer(panGesture)
        
        self.view.addSubview(self.mainColorPickerView)
    }
    
    fileprivate func createSecondaryPickerview(){
        let WIDTH = self.deviceFrame().width - 89
        let HEIGHT = WIDTH
        let size = CGSize.init(width: WIDTH, height: HEIGHT)
        let origin = CGPoint.init(x: 15,
                                  y: (self.view.frame.size.height - WIDTH) - 15)
        self.secondaryColorPickerView = UIView.init(frame: CGRect.init(origin: origin, size: size))
        
        let darkColor = [UIColor.black.cgColor,
                         UIColor.red.cgColor]
        let firstLayer = self.gradientLayer(inView: self.secondaryColorPickerView,
                                            withColor: darkColor, orientation: .vertical)
        let lightColor = [UIColor.clear.cgColor,
                          UIColor.white.cgColor]
        let secondLayer = self.gradientLayer(inView: self.secondaryColorPickerView,
                                             withColor: lightColor, orientation: .horizontal)
        self.secondaryColorPickerView.layer.addSublayer(firstLayer)
        self.secondaryColorPickerView.layer.addSublayer(secondLayer)
        self.secondaryColorPickerView.layer.borderColor = UIColor.black.cgColor
        self.secondaryColorPickerView.layer.borderWidth = 1.0
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.secondaryPickerDidTap(_:)))
        tapGesture.numberOfTapsRequired = 1
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.secondaryPickerDidTap(_:)))
        self.secondaryColorPickerView.addGestureRecognizer(tapGesture)
        self.secondaryColorPickerView.addGestureRecognizer(panGesture)
        
        self.view.addSubview(self.secondaryColorPickerView)
    }
    
    fileprivate func createMainColorSelector(){
        let selector = UIImage.init(named: "selector_rectangle")
        self.mainColorSelectorImage = UIImageView.init(image: selector)
        self.mainColorSelectorImage.frame = CGRect.init(x: -5,
                                                        y: 0,
                                                        width: 54.0,
                                                        height: 10)
        self.mainColorPickerView.insertSubview(self.mainColorSelectorImage, at: 1)
    }
    
    fileprivate func createSecondaryColorSelector(){
        let selector = UIImage.init(named: "selector_round")
        self.secondaryColorSelectorImage = UIImageView.init(image: selector)
        self.secondaryColorSelectorImage.frame = CGRect.init(x: 0,
                                                             y: 0,
                                                             width: 20,
                                                             height: 20)
        self.secondaryColorSelectorImage.center.x = self.secondaryColorPickerView.frame.size.height - 2
        self.secondaryColorPickerView.insertSubview(self.secondaryColorSelectorImage, at: 2)
    }
    
    // MARK: gesture recognizer
    
    @objc fileprivate func mainPickerDidTap(_ sender: UIGestureRecognizer){
        let panLocation = sender.location(in: self.mainColorPickerView)
        
        if (self.mainColorPickerView.bounds.origin.y + 3)...(self.mainColorPickerView.bounds.origin.y + self.mainColorPickerView.bounds.size.height - 3) ~= panLocation.y{
            self.mainColorSelectorImage.center.y = panLocation.y
            let selectedColor = self.colorOfPoint(point: self.mainColorSelectorImage.center,
                                                  inView: self.mainColorPickerView)
            self.updateSecondaryPickerView(selectedColor)
        }
    }
    
    @objc fileprivate func secondaryPickerDidTap(_ sender: UIGestureRecognizer){
        let MARGIN = CGFloat(3)
        let panLocation = sender.location(in: self.secondaryColorPickerView)
        
        if MARGIN ... (self.secondaryColorPickerView.frame.size.width - MARGIN) ~= panLocation.x{
            self.secondaryColorSelectorImage.center.x = panLocation.x
        }
        
        if MARGIN ... (self.secondaryColorPickerView.frame.size.height - MARGIN) ~= panLocation.y{
            self.secondaryColorSelectorImage.center.y = panLocation.y
        }
        
        self.updateBackgroundColor()
        
    }
    
    // MARK: ui element actions
    
    @objc fileprivate func dismissButtonTouched(_ button:UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func rgbButtonTouched(_ button:UIButton!){
        self.dismiss(animated: true, completion: nil)
        self.delegate?.KPRColorPickerDidSelectWithUIColor(self.selectedColor)
    }
    
    // MARK: backend logic
    
    fileprivate func updateSecondaryPickerView(_ color:UIColor){
        let darkColor = [UIColor.black.cgColor,
                         color.cgColor]
        let firstLayer = self.gradientLayer(inView: self.secondaryColorPickerView,
                                            withColor: darkColor, orientation: .vertical)
        self.secondaryColorPickerView.layer.sublayers?.removeFirst()
        self.secondaryColorPickerView.layer.insertSublayer(firstLayer, at: 0)
        self.updateBackgroundColor()
    }
    
    fileprivate func updateBackgroundColor(){
        self.selectedColor = self.colorOfPoint(point: self.secondaryColorSelectorImage.center,
                                               inView: self.secondaryColorPickerView);
        self.view.backgroundColor = self.selectedColor
        var rgbString = self.colorToRGB(self.selectedColor)
        rgbString += "\n" + self.colorToHex(self.selectedColor)
        
        self.rgbButton.setTitle(rgbString, for: .normal)
        updateColor()
    }
    
    //update color when background color too dark to see
    fileprivate func updateColor(){
        if self.secondaryColorSelectorImage.center.x < self.secondaryColorPickerView.frame.size.width / 2 && self.secondaryColorSelectorImage.center.y < self.secondaryColorPickerView.frame.size.height / 2{
            
            self.secondaryColorPickerView.layer.borderColor = UIColor.white.cgColor
            self.mainColorPickerView.layer.borderColor = UIColor.white.cgColor
            self.dismissButton.setTitleColor(.white, for: .normal)
            self.rgbButton.setTitleColor(.white, for: .normal)
            
            let pickerImage = UIImage(named: "selector_rectangle_white")
            self.mainColorSelectorImage.image = pickerImage
            
            UIApplication.shared.statusBarStyle = .lightContent
        }
        else{
            self.secondaryColorPickerView.layer.borderColor = UIColor.black.cgColor
            self.mainColorPickerView.layer.borderColor = UIColor.black.cgColor
            self.dismissButton.setTitleColor(.black, for: .normal)
            self.rgbButton.setTitleColor(.black, for: .normal)
            
            let pickerImage = UIImage(named: "selector_rectangle")
            self.mainColorSelectorImage.image = pickerImage
            
            UIApplication.shared.statusBarStyle = .default
        }
    }
    
    private func gradientLayer(inView:UIView, withColor:[CGColor],orientation:GRADIENT) -> CALayer{
        let gradient = CAGradientLayer.init()
        gradient.frame = CGRect.init(x: 0,
                                     y: 0,
                                     width: inView.frame.size.width,
                                     height: inView.frame.size.height)
        gradient.colors = withColor
        if orientation == .vertical{
            gradient.startPoint = CGPoint.init(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint.init(x: 1.0, y: 0.5)
        }
        else{
            gradient.startPoint = CGPoint.init(x: 0.0, y: 0.0)
            gradient.endPoint = CGPoint.init(x: 0.0, y: 1.0)
        }
        return gradient
    }
    
    private func colorOfPoint(point: CGPoint, inView:UIView) -> UIColor{
        let pixel = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        context!.translateBy(x: -point.x, y: -point.y)
        inView.layer.render(in: context!)
        
        let color:UIColor = UIColor(red: CGFloat(pixel[0])/255.0, green: CGFloat(pixel[1])/255.0, blue: CGFloat(pixel[2])/255.0, alpha: CGFloat(pixel[3])/255.0)
        
        pixel.deallocate(capacity: 4)
        return color
    }
    
    //return current device frame
    private func deviceFrame() -> CGSize{
        let deviceWidth = UIScreen.main.bounds.size.width
        let deviceHeight = UIScreen.main.bounds.size.height
        let deviceScreenSize = CGSize.init(width: deviceWidth, height: deviceHeight)
        return deviceScreenSize;
    }
    
    private func colorToRGB(_ color: UIColor) -> String{
        let redValue = (color.cgColor.components?[0])! * 255
        let greenValue = (color.cgColor.components?[1])! * 255
        let blueValue = (color.cgColor.components?[2])! * 255
        let rgbString = String.init(format: "rgb(%.0f,%.0f,%.0f)", redValue, greenValue, blueValue)
        return rgbString
    }
    
    private func colorToHex(_ color: UIColor) -> String{
        let red = color.cgColor.components?[0]
        let green = color.cgColor.components?[1]
        let blue = color.cgColor.components?[2]
        
        let hexString = String(format: "#%02lX%02lX%02lX",
                               lroundf(Float(red! * 255)),
                               lroundf(Float(green! * 255)),
                               lroundf(Float(blue! * 255)))
        return hexString
    }
}
