//
//  Maintainer.swift
//  ManaKit_Example
//
//  Created by Jovito Royeca on 23/10/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import CoreData
import ManaKit

class Maintainer: NSObject {
    // MARK: Constants
    let printMilestone = 1000
    
    // MARK: Variables
    var dateStart = Date()
    
    func startActivity(name: String) {
        dateStart = Date()
        print("Starting \(name)...")
    }
    
    func endActivity() {
        let dateEnd = Date()
        let timeDifference = dateEnd.timeIntervalSince(dateStart)
        print("Total Time Elapsed: \(self.dateStart) - \(dateEnd) = \(self.format(timeDifference))")
        print("docsPath = \(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])")
    }
    
    func updateSystem() {
        // delete existing data first
        let request: NSFetchRequest<CMSystem> = CMSystem.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request as! NSFetchRequest<NSFetchRequestResult>)
        try! ManaKit.sharedInstance.dataStack?.persistentStoreCoordinator.execute(deleteRequest, with: (ManaKit.sharedInstance.dataStack?.mainContext)!)
        
        let objectFinder = ["version": ManaKit.Constants.ScryfallDate] as [String: AnyObject]
        guard let system = ManaKit.sharedInstance.findObject("CMSystem", objectFinder: objectFinder, createIfNotFound: true) as? CMSystem else {
            return
        }
        
        system.version = ManaKit.Constants.ScryfallDate
        system.date = NSDate()
        try! ManaKit.sharedInstance.dataStack?.mainContext.save()
    }
    
    func sectionFor(name: String) -> String? {
        if name.count == 0 {
            return nil
        } else {
            let letters = CharacterSet.letters
            var prefix = String(name.prefix(1))
            if prefix.rangeOfCharacter(from: letters) == nil {
                prefix = "#"
            }
            return prefix.uppercased().folding(options: .diacriticInsensitive, locale: .current)
        }
    }
    
    func displayFor(name: String) -> String {
        var display = ""
        let components = name.components(separatedBy: "_")
        
        if components.count > 1 {
            for e in components {
                var cap = e
                
                if e != "the" || e != "a" || e != "an" || e != "and" {
                    cap = e.prefix(1).uppercased() + e.dropFirst()
                }
                if display.count > 0 {
                    display.append(" ")
                }
                display.append(cap)
            }
        } else {
            display = name
        }
        
        return display
    }
    
    func capitalize(string: String) -> String {
        if string.count == 0 {
            return string
        } else {
            return (string.prefix(1).uppercased() + string.dropFirst()).replacingOccurrences(of: "_", with: " ")
        }
    }
    
    func format(_ interval: TimeInterval) -> String {
        if interval == 0 {
            return "HH:mm:ss"
        }
        
        let seconds = interval.truncatingRemainder(dividingBy: 60)
        let minutes = (interval / 60).truncatingRemainder(dividingBy: 60)
        let hours = (interval / 3600)
        return String(format: "%.2d:%.2d:%.2d", Int(hours), Int(minutes), Int(seconds))
    }
}
