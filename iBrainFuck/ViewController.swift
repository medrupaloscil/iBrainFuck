//
//  ViewController.swift
//  iBrainFuck
//
//  Created by baptiste Fehrenbach on 10/01/2016.
//  Copyright © 2016 medrupaloscil. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    let ASCII = [
        32 : " ",
        33 : "!",
        34 : "\"",
        35 : "#",
    ]
    @IBOutlet var textView: NSTextView!
    var charact = ""
    var lastString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textView.textColor = NSColor(calibratedRed: 0, green: 1, blue: 0, alpha: 1)
        NSEvent.addLocalMonitorForEventsMatchingMask(.KeyDownMask) { (aEvent) -> NSEvent! in
            self.keyDown(aEvent)
            return aEvent
        }
        
        NSEvent.addLocalMonitorForEventsMatchingMask(.FlagsChangedMask) { (theEvent) -> NSEvent! in
            self.flagsChanged(theEvent)
            return theEvent
        }
        
        
    }
    
    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    override func keyDown(theEvent:NSEvent) {
        charact = theEvent.charactersIgnoringModifiers!
        let keyCode = theEvent.keyCode
        if  keyCode != 36 && keyCode != 48 && keyCode != 51 && keyCode != 53 && keyCode != 123 && keyCode != 124 && keyCode != 125 && keyCode != 126 {
            _ = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("deleteLast"), userInfo: nil, repeats: false)
        }
    }
    
    
    override func flagsChanged(theEvent: NSEvent) {
        /*switch theEvent.modifierFlags.intersect(.DeviceIndependentModifierFlagsMask) {
        case NSEventModifierFlags.ShiftKeyMask :
            print("shift key is pressed")
        case NSEventModifierFlags.ControlKeyMask:
            print("control key is pressed")
        case NSEventModifierFlags.AlternateKeyMask :
            print("option key is pressed")
        case NSEventModifierFlags.CommandKeyMask:
            print(theEvent)
        default:
            print("")
        }*/
    }

    func deleteLast() {
        if charact != ">" && charact != "<" && charact != "." && charact != "," && charact != "+" && charact != "[" && charact != "]" {
            if charact == "-" {
                textView.string = textView.string!
            } else {
                textView.string = lastString
            }
        }
        lastString = textView.string!
    }
    
}