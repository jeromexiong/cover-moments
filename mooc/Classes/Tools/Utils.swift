//
//  Utils.swift
//  mooc
//
//  Created by Jerome Xiong on 2020/4/17.
//  Copyright © 2020 kilomind. All rights reserved.
//


public extension UIColor {
    /// 扩展UIColor 构造函数，直接传入RGB数据值即可，无需转换
    convenience init(r:CGFloat, g:CGFloat, b:CGFloat) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
    
    /// 把颜色转成图片
    func jx_toImage(size: CGSize) -> UIImage{
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(self.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    var jx_hex: Int {
        let red = Int(self.jx_rgba.0 * 255) << 16
        let green = Int(self.jx_rgba.1 * 255) << 8
        let blue = Int(self.jx_rgba.2 * 255)
        return red+green+blue
    }
    var jx_rgba: (CGFloat, CGFloat, CGFloat, CGFloat) {
        let numberOfComponents = self.cgColor.numberOfComponents
        guard let components = self.cgColor.components else {
            return (0,0,0,1)
        }
        if numberOfComponents == 2 {
            return (components[0], components[0], components[0], components[1])
        }
        if numberOfComponents == 4 {
            return (components[0], components[1], components[2], components[3])
        }
        return (0,0,0,1)
    }
    ///类的计算型属性. 生成随机颜色
    static var jx_random: UIColor {
        return UIColor(r: CGFloat(arc4random_uniform(255)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)))
    }
    ///16进制 转 RGBA
    static func jx_color(withHex: Int, alpha: CGFloat = 1.0) -> UIColor {
        let red = CGFloat((withHex & 0xFF0000) >> 16)
        let green = CGFloat((withHex & 0xFF00) >> 8)
        let blue = CGFloat((withHex & 0xFF))
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
    }
    /// 16进制转UIColor
    static func jx_color(hex: String, alpha: CGFloat = 1.0) -> UIColor {
        return proceesHex(hex: hex, alpha: alpha)
    }
}

fileprivate extension UIColor {
    static func proceesHex(hex: String, alpha: CGFloat) -> UIColor {
        /** 如果传入的字符串为空 */
        if hex.isEmpty {
            return UIColor.clear
        }
        
        /** 传进来的值。 去掉了可能包含的空格、特殊字符， 并且全部转换为大写 */
        let whitespace = NSCharacterSet.whitespacesAndNewlines
        var hHex = (hex.trimmingCharacters(in: whitespace)).uppercased()
        
        /** 如果处理过后的字符串少于6位 */
        if hHex.count < 6 {
            return UIColor.clear
        }
        
        /** 开头是用0x开始的  或者  开头是以＃＃开始的 */
        if hHex.hasPrefix("0X") || hHex.hasPrefix("##") {
            hHex = String(hHex.dropFirst(2))
        }
        
        /** 开头是以＃开头的 */
        if hHex.hasPrefix("#") {
            hHex = (hHex as NSString).substring(from: 1)
        }
        
        /** 截取出来的有效长度是6位， 所以不是6位的直接返回 */
        if hHex.count != 6 {
            return UIColor.clear
        }
        
        /** R G B */
        var range = NSMakeRange(0, 2)
        
        /** R */
        let rHex = (hHex as NSString).substring(with: range)
        
        /** G */
        range.location = 2
        let gHex = (hHex as NSString).substring(with: range)
        
        /** B */
        range.location = 4
        let bHex = (hHex as NSString).substring(with: range)
        
        /** 类型转换 */
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        
        Scanner(string: rHex).scanHexInt32(&r)
        Scanner(string: gHex).scanHexInt32(&g)
        Scanner(string: bHex).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
}

extension NSObject {
    /// 返回类名
    static var jx_className: String {
        get {
            let a = NSStringFromClass(self)
            let className = a.split(separator: ".").last
            return String(className!)
        }
    }
}

extension String {
    func textSize(_ maxWidth: CGFloat, font: UIFont) -> CGSize {
        let constraint = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        let size: CGRect = self.boundingRect(with: constraint, options: ([.usesLineFragmentOrigin]), attributes: [NSAttributedString.Key.font: font], context: nil)
        return CGSize(width: ceil(size.width), height: ceil(size.height)+font.pointSize)
    }
}
