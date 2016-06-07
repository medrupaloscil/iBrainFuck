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
    
    override func keyDown(theEvent:NSEvent) {
        charact = theEvent.charactersIgnoringModifiers!
        if charact == "-" {
            textView.string = textView.string!
        }
    }
    
    @IBAction func runButton(sender: AnyObject) {
        textLabel.hidden = false
        var currentMemory = 0
        var currentLoop = 0
        var loopPosition = [0]
        var result = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        let string = textView.string!
        var i = 0
        
        while i < string.characters.count {
            let str = String(string[i] as Character)
            
            switch str {
            case "+":
                result[currentMemory] += 1
            case "-":
                result[currentMemory] -= 1
            case ".":
                textLabel.stringValue = textLabel.stringValue + "\(Character(UnicodeScalar(result[currentMemory])))"
            case ",":
                print("not available")
            case ">":
                currentMemory += 1
            case "<":
                currentMemory -= 1
            case "[":
                currentLoop += 1
                if loopPosition.count - 1 < currentLoop {
                    loopPosition += [i]
                } else {
                    loopPosition[currentLoop] = i
                }
                break
            case "]":
                if result[currentMemory] == 0 {
                    loopPosition[currentLoop] = 0
                    if currentLoop != 0 {currentLoop -= 1}
                } else {
                    i = loopPosition[currentLoop] - 1
                }
                break
            default:
                print("Not a brainfuck character")
            }
            
            i += 1
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
        return self[start..<end]
    }
}