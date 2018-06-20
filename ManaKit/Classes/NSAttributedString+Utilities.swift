//
//  NSAttributedString+Utilities.swift
//  ManaKit
//
//  Created by Jovito Royeca on 20/06/2018.
//

import UIKit
import Kanna

public extension NSAttributedString {
    public func addSymbols(pointSize: CGFloat) -> NSMutableAttributedString {
        let newAttributedString = NSMutableAttributedString()
        let text = self.string.trimmingCharacters(in: CharacterSet.whitespaces)
        var fragmentText = NSMutableString()
        var sentinel = 0
        
        repeat {
            for i in sentinel...text.count - 1 {
                let c = text[text.index(text.startIndex, offsetBy: i)]
                
                if c == "{" {
                    let symbol = NSMutableString()
                    
                    for j in i...text.count - 1 {
                        let cc = text[text.index(text.startIndex, offsetBy: j)]
                        symbol.append(String(cc))
                        
                        if cc == "}" {
                            sentinel = j + 1
                            break
                        }
                    }
                    
                    let attributedString = NSMutableAttributedString(string: fragmentText as String)
                    attributedString.append(NSAttributedString(symbol: symbol as String, pointSize: pointSize))
                    newAttributedString.append(attributedString)
                    fragmentText = NSMutableString()
                    break
                   
                } else {
                    fragmentText.append(String(c))
                    sentinel += 1
                }
                
            }
        } while sentinel <= text.count - 1
        
        let attributedString = NSMutableAttributedString(string: fragmentText as String)
        newAttributedString.append(attributedString)
        
        return newAttributedString
    }
    
    public convenience init(symbol: String, pointSize: CGFloat) {
        var cleanSymbol = symbol.replacingOccurrences(of: "{", with: "")
            .replacingOccurrences(of: "}", with: "")
            .replacingOccurrences(of: "/", with: "")
        
        if cleanSymbol == "CHAOS" {
            cleanSymbol = "Chaos"
        }
        
        guard let image = ManaKit.sharedInstance.symbolImage(name: cleanSymbol as String) else {
            self.init()
            return
        }
        
        let imageAttachment =  NSTextAttachment()
        imageAttachment.image = image
        
        var width = CGFloat(16)
        let height = CGFloat(16)
        var imageOffsetY = CGFloat(0)
        
        if cleanSymbol == "100" {
            width = 35
        } else if cleanSymbol == "1000000" {
            width = 60
        }
        
        if height > pointSize {
            imageOffsetY = -(height - pointSize) / 2.0
        } else {
            imageOffsetY = -(pointSize - height) / 2.0
        }
        
        imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: width, height: height)
        self.init(attachment: imageAttachment)
    }
    
    public func convertToHtml() -> NSMutableAttributedString? {
        let style = "<style>" +
            "body { font-family: -apple-system; font-size:15; } " +
        "</style>"
        let html = "\(style)\(self.string)"
        var links = [[String: Any]]()
        
        guard let doc = try? HTML(html: html, encoding: .utf16) else {
            return nil
        }
        
        // Search for links
        for link in doc.css("a, link") {
            if let text = link.text,
                let href = link["href"] {
                links.append([text: href])
            }
        }
        
        guard let data = html.data(using: String.Encoding.utf16) else {
            return nil
        }
        guard let attributedString = try? NSMutableAttributedString(
            data: data,
            options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil) else {
                return nil
        }
        
        // add tappble links
        for link in links {
            for (k,v) in link {
                let foundRange = attributedString.mutableString.range(of: k)
                if foundRange.location != NSNotFound {
                    attributedString.addAttribute(NSLinkAttributeName, value: v, range: foundRange)
//                    attributedString.addAttribute(NSForegroundColorAttributeName, value: kGlobalTintColor, range: foundRange)
//                    attributedString.addAttribute(NSUnderlineColorAttributeName, value: kGlobalTintColor, range: foundRange)
                }
            }
        }
        return attributedString
    }
}


