//
//  ViewController.swift
//  iBrainFuck
//
//  Created by baptiste Fehrenbach on 10/01/2016.
//  Copyright © 2016 medrupaloscil. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet var textView: NSTextView!
    @IBOutlet weak var textLabel: NSTextField!
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
        
        textLabel.hidden = true
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
    
    @IBAction func runButton(sender: AnyObject) {
        textLabel.hidden = false
        var currentMemory = 0
        var currentLoop = 0
        var loopPosition = [0]
        var result = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        let string = textView.string!
        
        for var i = 0; i < string.characters.count; i++ {
            let str = String(string[i] as Character)
            if str == "+" {
                result[currentMemory]++
            } else if str == "-" {
                result[currentMemory]--
            } else if str == "." {
                textLabel.stringValue = textLabel.stringValue + "\(Character(UnicodeScalar(result[currentMemory])))"
            } else if str == "," {
                
            } else if str == ">" {
                currentMemory++
            } else if str == "<" {
                currentMemory--
            } else if str == "[" {
                currentLoop++
                if loopPosition.count - 1 < currentLoop {
                    loopPosition += [i]
                } else {
                    loopPosition[currentLoop] = i
                }
            } else if str == "]" {
                if result[currentMemory] == 0 {
                    loopPosition[currentLoop] = 0
                    if currentLoop != 0 {currentLoop--}
                } else {
                    i = loopPosition[currentLoop] - 1
                }
            }
        }
    }
    
    @IBAction func stopButton(sender: AnyObject) {
        textLabel.stringValue = ""
        textLabel.hidden = true
    }
    
}

extension String {
    
    subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = startIndex.advancedBy(r.startIndex)
        let end = start.advancedBy(r.endIndex - r.startIndex)
        return self[Range(start: start, end: end)]
    }
}