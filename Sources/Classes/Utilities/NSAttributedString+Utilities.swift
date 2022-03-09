//
//  NSAttributedString+Utilities.swift
//  ManaKit
//
//  Created by Jovito Royeca on 20/06/2018.
//

#if canImport(UIKit)
import UIKit

public extension NSAttributedString {
    convenience init(symbol: String, pointSize: CGFloat) {
        let newAttributedString = NSMutableAttributedString()
        let text = symbol.trimmingCharacters(in: CharacterSet.whitespaces)
        var fragmentText = NSMutableString()
        var sentinel = 0
        
        if text.count == 0 {
            self.init(string: symbol)
            return
        }

        repeat {
            for i in sentinel...text.count - 1 {
                let c = text[text.index(text.startIndex, offsetBy: i)]
                
                if c == "{" {
                    let code = NSMutableString()
                    
                    for j in i...text.count - 1 {
                        let cc = text[text.index(text.startIndex, offsetBy: j)]
                        code.append(String(cc))
                        
                        if cc == "}" {
                            sentinel = j + 1
                            break
                        }
                    }
                    
                    var cleanCode = code.replacingOccurrences(of: "{", with: "")
                        .replacingOccurrences(of: "}", with: "")
                        .replacingOccurrences(of: "/", with: "")
                    
                    if cleanCode.lowercased() == "chaos" {
                        cleanCode = "Chaos"
                    }
                    
                    guard let image = ManaKit.shared.symbolImage(name: cleanCode as String) else {
                        self.init(string: symbol)
                        return
                    }
                    
                    let imageAttachment =  NSTextAttachment()
                    imageAttachment.image = image
                    
                    var width = CGFloat(16)
                    let height = CGFloat(16)
                    var imageOffsetY = CGFloat(0)
                    
                    if cleanCode == "100" {
                        width = 35
                    } else if cleanCode == "1000000" {
                        width = 60
                    }
                    
                    if height > pointSize {
                        imageOffsetY = -(height - pointSize) / 2.0
                    } else {
                        imageOffsetY = -(pointSize - height) / 2.0
                    }
                    imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: width, height: height)

                    let attachmentString = NSAttributedString(attachment: imageAttachment)
                    let attributedString = NSMutableAttributedString(string: fragmentText as String)
                    attributedString.append(attachmentString)
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
        self.init(attributedString: newAttributedString)
    }
    
    convenience init(html: String) {
        let style = "<style>" +
            "body { font-family: -apple-system; font-size:15; } " +
        "</style>"
        let html = "\(style)\(html)"
        var links = [[String: Any]]()
        
//        guard let doc = try? HTML(html: html, encoding: .utf16) else {
//            self.init(string: html)
//            return
//        }
//        
//        // Search for links
//        for link in doc.css("a, link") {
//            if let text = link.text,
//                let href = link["href"] {
//                links.append([text: href])
//            }
//        }
        
        guard let data = html.data(using: String.Encoding.utf16) else {
            self.init(string: html)
            return
        }
        
        let options =  [convertFromNSAttributedStringDocumentAttributeKey(NSAttributedString.DocumentAttributeKey.documentType): convertFromNSAttributedStringDocumentType(NSAttributedString.DocumentType.html)]
        guard let attributedString = try? NSMutableAttributedString(data: data,
                                                                    options: convertToNSAttributedStringDocumentReadingOptionKeyDictionary(options),
                                                                    documentAttributes: nil) else {
                self.init(string: html)
                return
        }
        
        // add tappble links
        for link in links {
            for (k,v) in link {
                let foundRange = attributedString.mutableString.range(of: k)
                if foundRange.location != NSNotFound {
                    
                    attributedString.addAttribute(NSAttributedString.Key.link, value: v, range: foundRange)
//                    attributedString.addAttribute(NSForegroundColorAttributeName, value: kGlobalTintColor, range: foundRange)
//                    attributedString.addAttribute(NSUnderlineColorAttributeName, value: kGlobalTintColor, range: foundRange)
                }
            }
        }
        
        self.init(attributedString: attributedString)
    }
    
    func widthOf(symbol: String) -> CGFloat {
        let text = symbol.trimmingCharacters(in: CharacterSet.whitespaces)
        var width = CGFloat(0)
        var sentinel = 0
        
        if text.count == 0 {
            return width
        }
        
        repeat {
            for i in sentinel...text.count - 1 {
                let c = text[text.index(text.startIndex, offsetBy: i)]
                
                if c == "{" {
                    let code = NSMutableString()
                    
                    for j in i...text.count - 1 {
                        let cc = text[text.index(text.startIndex, offsetBy: j)]
                        code.append(String(cc))
                        
                        if cc == "}" {
                            sentinel = j + 1
                            break
                        }
                    }
                    
                    var cleanCode = code.replacingOccurrences(of: "{", with: "")
                        .replacingOccurrences(of: "}", with: "")
                        .replacingOccurrences(of: "/", with: "")
                    
                    if cleanCode.lowercased() == "chaos" {
                        cleanCode = "Chaos"
                    }
                    
                    if cleanCode == "100" {
                        width += 35
                    } else if cleanCode == "1000000" {
                        width += 60
                    } else {
                        width += CGFloat(16)
                    }
                    break
                    
                } else {
                    sentinel += 1
                }
                
            }
        } while sentinel <= text.count - 1
        
        return width
    }
}



// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringDocumentAttributeKey(_ input: NSAttributedString.DocumentAttributeKey) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringDocumentType(_ input: NSAttributedString.DocumentType) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSAttributedStringDocumentReadingOptionKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.DocumentReadingOptionKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.DocumentReadingOptionKey(rawValue: key), value)})
}
#endif // #if canImport(UIKit)
