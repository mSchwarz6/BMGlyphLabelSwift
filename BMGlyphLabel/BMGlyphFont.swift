import Foundation
import SpriteKit

//  MIT License
//
//  Copyright (c) 2016 Kim Pedersen
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

class BMGlyphFont: NSObject, XMLParserDelegate {
    
    /// Line height
    private(set) var lineHeight: Int = 0
    
    
    /// Kernings
    fileprivate var kernings = [String : Int]()
    
    
    /// Characters
    fileprivate var chars = [String : Int]()
    
    
    /// The individual character textures
    private(set) var charsTextures = [Int : SKTexture]()
    
    
    /// The texture atlas containing the textures used for the font
    private(set) var atlas: SKTextureAtlas
    
    
    /// Initialize the font
    init(fontName: String) {
        
        // Load texture atlas
        atlas = SKTextureAtlas(named: fontName)
        
        super.init()
        
        // Convert fontname to a NSString
        let name = NSString(string: fontName)
        
        // sort out the filename for the map and get it's path
        let filename = name.deletingPathExtension
        var fileExtension = name.pathExtension
        
        // if the file contained no extension, then add the default "tmx" extension
        if fileExtension.isEmpty {
            fileExtension = "xml"
        }
        
        guard let path = Bundle.main.path(forResource: filename, ofType: fileExtension) else {
            fatalError("Unable to load font file: \(name)")
        }
        
        do {
            
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe)
            
            // Parse the XML data
            let parser = XMLParser(data: data)
            parser.delegate = self
            
            if !parser.parse() {
                fatalError("Error parsing data, error: \(parser.parserError)")
            }
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
    
    /// Returns the xAdvance for a given character
    func xAdvance(for charID: unichar) -> Int {
        if let c = chars["xadvance_\(charID)"] {
            return c
        } else {
            return 0
        }
    }
    
    
    /// Returns the xOffset for a given character
    func xOffset(for charID: unichar) -> Int {
        if let c = chars["xoffset_\(charID)"] {
            return c
        } else {
            return 0
        }
    }
    
    
    /// Returns the yOffset for a given character
    func yOffset(for charID: unichar) -> Int {
        if let c = chars["yoffset_\(charID)"] {
            return c
        } else {
            return 0
        }
    }
    
    
    /// Returns the kerning between two characters
    func kerning(for first: unichar, second: unichar) -> Int {
        if let c = self.kernings["\(first)/\(second)"] {
            return c
        } else {
            return 0
        }
    }
    
    
    /// Parses XML data
    internal func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        switch elementName {
        case "kerning":
            let first  = Int(attributeDict["first"]!)!
            let second = Int(attributeDict["second"]!)!
            let amount = Int(attributeDict["amount"]!)!
            
            kernings["\(first)/\(second)"] = amount
            
        case "char":
            let id       = Int(attributeDict["id"]!)!
            let xAdvance = Int(attributeDict["xadvance"]!)!
            let xOffset  = Int(attributeDict["xoffset"]!)!
            let yOffset  = Int(attributeDict["yoffset"]!)!
            
            chars["xoffset_\(id)"] = xOffset
            chars["yoffset_\(id)"] = yOffset
            chars["xadvance_\(id)"] = xAdvance
            charsTextures[id] = atlas.textureNamed("\(id)")
            
        case "common":
            lineHeight = Int(attributeDict["lineHeight"]!)!
            
        default:
            break
            
        }
        
    }
    
}
