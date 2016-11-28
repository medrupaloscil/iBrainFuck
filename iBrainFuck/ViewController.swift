//
//  ViewController.swift
//  iBrainFuck
//
//  Created by baptiste Fehrenbach on 10/01/2016.
//  Copyright © 2016 medrupaloscil. All rights reserved.
//

/*
 Hello world
 ++++++++++
 [
	>+++++++
	>++++++++++
	>+++
	>+
	<<<<-
 ]
 >++.
 >+.
 +++++++.
 .
 +++.
 >++.
 <<+++++++++++++++.
 >.
 +++.
 ------.
 --------.
 >+.
*/

import Cocoa
import Darwin

class ViewController: NSViewController {
    
    @IBOutlet var textView: NSTextView!
    @IBOutlet var textLabel: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textView.textColor = NSColor(calibratedRed: 0, green: 1, blue: 0, alpha: 1)
        textLabel.textColor = NSColor.white
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { (aEvent) -> NSEvent! in
            self.keyDown(with: aEvent)
            return aEvent
        }
        
        NSEvent.addLocalMonitorForEvents(matching: .flagsChanged) { (theEvent) -> NSEvent! in
            self.flagsChanged(with: theEvent)
            return theEvent
        }
    }
    
    override func keyDown(with theEvent:NSEvent) {
        let keyCode = theEvent.keyCode
        if  keyCode != 36 && keyCode != 48 && keyCode != 51 && keyCode != 53 && keyCode != 123 && keyCode != 124 && keyCode != 125 && keyCode != 126 {
            _ = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(ViewController.syntaxColor), userInfo: nil, repeats: false)
        }
    }
    
    override func flagsChanged(with theEvent: NSEvent) {
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

    func syntaxColor() {
        
        let selectedRange = textView.selectedRange
        
        var textString = textView.attributedString().string
        let mutableString = NSMutableAttributedString(attributedString: textView.attributedString())
        
        for i in 0..<textString.characters.count {
            
            var color = NSColor(red: 73/255, green: 73/255, blue: 73/255, alpha: 1)
            let character: String = textString[i]
            
            switch character {
            case "+":
                color = NSColor(red: 205/255, green: 245/255, blue: 96/255, alpha: 1)
            case "-":
                color = NSColor(red: 255/255, green: 101/255, blue: 31/255, alpha: 1)
            case ">":
                color = NSColor(red: 44/255, green: 111/255, blue: 144/255, alpha: 1)
            case "<":
                color = NSColor(red: 44/255, green: 111/255, blue: 144/255, alpha: 1)
            case ".":
                color = NSColor(red: 255/255, green: 100/255, blue: 40/255, alpha: 1)
            case ",":
                color = NSColor(red: 131/255, green: 110/255, blue: 115/255, alpha: 1)
            case "[":
                color = NSColor(red: 249/255, green: 247/255, blue: 227/255, alpha: 1)
            case "]":
                color = NSColor(red: 249/255, green: 247/255, blue: 227/255, alpha: 1)
            default:
                break
            }
            
            mutableString.addAttribute(NSForegroundColorAttributeName, value: color, range: NSRange(location: i, length: 1))
        }
        
        textView.textStorage?.setAttributedString(mutableString)
        textView.setSelectedRange(selectedRange)
    }
    
    @IBAction func runButton(_ sender: AnyObject) {
        textLabel.string = ""
        var currentMemory = 0
        var currentLoop = 0
        var loopPosition = [0]
        var result = [0]
        let string = textView.string!
        var i = 0
        
        while i != string.characters.count {
            let str = String(string[i] as Character)
            switch str {
            case "+":
                result[currentMemory] += 1
            case "-":
                result[currentMemory] -= 1
            case ".":
                textLabel.string = textLabel.string! + "\(Character(UnicodeScalar(result[currentMemory])!))"
            case ",":
                print(",")
            case ">":
                currentMemory += 1
                if result.count == currentMemory {
                    result.append(0)
                }
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
                break
            }
            
            i += 1
        }
    }
    
    func saveFile() {
        let file = "file.bfk" //this is the file. we will write to and read from it
        
        let text = textView.string! //just a text
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let path = dir.appendingPathComponent(file)
            print(path)
            
            //writing
            do {
                try text.write(to: path, atomically: false, encoding: String.Encoding.utf8)
            }
            catch {
                print(error)
            }
        }
    }
}

extension String {
    
    subscript (i: Int) -> Character {
        return self[self.characters.index(self.startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = self.characters.index(startIndex, offsetBy: r.lowerBound)
        let end = self.index(start, offsetBy: r.upperBound - r.lowerBound)
        return self[(start ..< end)]
    }
}
