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
    @IBOutlet var textLabel: NSTextView!
    var charact = ""
    var lastString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textView.textColor = NSColor(calibratedRed: 0, green: 1, blue: 0, alpha: 1)
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
        charact = theEvent.charactersIgnoringModifiers!
        let keyCode = theEvent.keyCode
        if  keyCode != 36 && keyCode != 48 && keyCode != 51 && keyCode != 53 && keyCode != 123 && keyCode != 124 && keyCode != 125 && keyCode != 126 {
            _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.deleteLast), userInfo: nil, repeats: false)
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

    func deleteLast() {
        if charact != ">" && charact != "<" && charact != "." && charact != "," && charact != "+" && charact != "[" && charact != "]" {
            if charact == "-" {
                textView.string = textView.string!
            }
        }
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
                print("not available")
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
                print("Not a brainfuck character")
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
