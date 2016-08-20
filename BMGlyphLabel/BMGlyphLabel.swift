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

class BMGlyphLabel: SKNode {
    
    public enum BMGlyphHorizontalAlignment: Int {
        case Centered = 1
        case Right    = 2
        case Left     = 3
    }
    
    
    public enum BMGlyphVerticalAlignment: Int {
        case Middle = 1
        case Top    = 2
        case Bottom = 3
    }
    
    
    public enum BMGlyphJustify: Int {
        case Left   = 1
        case Right  = 2
        case Center = 3
    }
    
    
    /// Gets or sets the text in the label
    var text: String {
        get { return _text }
        set {
            if newValue != _text {
                _text = newValue
                updateLabel()
                justifyLabel()
            }
        }
    }
    fileprivate var _text: String = ""
    
    
    /// Gets or sets the horizontal alignment in the label. Defaults to Centered
    var horizontalAlignment: BMGlyphHorizontalAlignment {
        get { return _horizontalAlignment }
        set {
            if newValue != _horizontalAlignment {
                _horizontalAlignment = newValue
                justifyLabel()
            }
        }
    }
    fileprivate var _horizontalAlignment: BMGlyphHorizontalAlignment = .Centered
    
    
    /// Gets or sets the vertical alignment in the label. Defaults to Middle
    var verticalAlignment: BMGlyphVerticalAlignment {
        get { return _verticalAlignment }
        set {
            if newValue != _verticalAlignment {
                _verticalAlignment = newValue
                justifyLabel()
            }
        }
    }
    fileprivate var _verticalAlignment: BMGlyphVerticalAlignment = .Middle
    
    
    /// Gets or sets how the text is justified within the label. Defaults to Left
    var justify: BMGlyphJustify {
        get { return _justify }
        set {
            if newValue != _justify {
                _justify = newValue
                justifyLabel()
            }
        }
    }
    fileprivate var _justify: BMGlyphJustify = .Left
    
    
    /// Coloring of the label. Defaults to .white
    var color: SKColor {
        get { return _color }
        set {
            if _color != newValue {
                _color = newValue
                for node in children {
                    if let node = node as? SKSpriteNode {
                        node.color = _color
                    }
                }
            }
        }
    }
    fileprivate var _color: SKColor = SKColor.white
    
    
    /// Color blend factor in the label. Must be a value between 0 and 1. Defaults to 1.0
    var colorBlendFactor: CGFloat {
        get { return _colorBlendFactor }
        set {
            var factor = min(newValue, 1.0)
            factor = max(newValue, 0.0)
            if factor != _colorBlendFactor {
                _colorBlendFactor = factor
                for node in children {
                    if let node = node as? SKSpriteNode {
                        node.colorBlendFactor = factor
                    }
                }
            }
        }
    }
    fileprivate var _colorBlendFactor: CGFloat = 1.0
    
    
    /// Filtering mode for the label. Defaults to Nearest
    var filteringMode: SKTextureFilteringMode {
        get { return _filteringMode }
        set {
            if newValue != _filteringMode {
                _filteringMode = newValue
                for node in children {
                    if let node = node as? SKSpriteNode {
                        node.texture?.filteringMode = newValue
                    }
                }
            }
        }
    }
    fileprivate var _filteringMode: SKTextureFilteringMode = .nearest
    
    
    /// The size of the label in points
    private(set) var size: CGSize = CGSize.zero
    
    
    /// The BMGlyphFont used for rendering
    private(set) var font: BMGlyphFont
    
    
    /// Initializes the label
    init(text: String, font: BMGlyphFont) {
        self.font = font
        super.init()
        self.text = text
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// Justifies the text
    fileprivate func justifyLabel() {
        
        /// Calculate the shift in the label
        var shift = CGPoint.zero
        
        switch _horizontalAlignment {
        case .Left:
            shift.x = 0
        case .Right, .Centered:
            shift.x = -size.width * 0.5
        }
        
        switch _verticalAlignment {
        case .Bottom:
            shift.y = -size.height
        case .Top:
            shift.y = 0
        case .Middle:
            shift.y = -size.height * 0.5
        }
        
        // Adjust alignment of nodes
        for node in children {
            if let originalPosition = node.userData?["originalPosition"] as? CGPoint {
                node.position = CGPoint(x: originalPosition.x + shift.x, y: originalPosition.y - shift.y)
            }
        }
        
        // Justify text
        if justify != .Left {
            
            var nodeCount   : Int = 0
            var nodePosition: Int = 0
            var lineWidth   : Int = 0
           
            var c: unichar
            var node: SKSpriteNode
            
            let charCount      = _text.characters.count
            let label          = NSString(string: _text)
            let lineChangeChar = NSString(string: "\n").character(at: 0)
            
            for i in 0...charCount {
                
                // Get character at index (i)
                if i < charCount {
                    c = label.character(at: i)
                } else {
                    c = lineChangeChar
                }
                
                if c == lineChangeChar {
                    
                    // Line change
                    if nodeCount > 0 {
                        while nodePosition < nodeCount {
                            node = children[i] as! SKSpriteNode
                            if justify == .Right {
                                node.position.x = node.position.x + size.width - CGFloat(lineWidth) + shift.x
                            } else {
                                node.position.x = node.position.x + (size.width - CGFloat(lineWidth) * 0.5 ) + (shift.x * 0.5)
                            }
                            nodePosition += 1
                        }
                    }
                    
                    lineWidth = 0
                    
                } else {
                    
                    // Not a line change
                    node = children[i] as! SKSpriteNode
                    nodeCount += 1
                    lineWidth = Int(node.position.x + node.size.width)
                    
                }
                
            }
            
        }
        
    }
    
    
    /// Updates the label
    fileprivate func updateLabel() {
        
        var lastCharID: unichar = 0
        var newSize = CGSize.zero
        var pos = CGPoint.zero
        var letterSprite: SKSpriteNode
        
        let scaleFactor = UIScreen.main.scale
        let nodeCount = children.count
        let lineCount = _text.components(separatedBy: "\n").count - 1
        let charCount = _text.characters.count
        
        let label = NSString(string: _text)
        let lineChangeChar = NSString(string: "\n").character(at: 0)
        
        // If there are more existing nodes than needed - remove them
        if nodeCount > 0 && (charCount - lineCount) < nodeCount {
            for i in (charCount - lineCount)..<nodeCount {
                children[i].removeFromParent()
            }
        }
        
        if charCount > 0 {
            newSize.height += CGFloat(font.lineHeight) / scaleFactor
        }
        
        var realCharCount: Int = 0
        
        for i in 0..<charCount {
            
            // Get the character at the i'th position
            let c = label.character(at: i)
            
            if c == lineChangeChar {
                
                // New line
                pos.y -= CGFloat(font.lineHeight) / scaleFactor
                newSize.height += CGFloat(font.lineHeight) / scaleFactor
                pos.x = 0
                
            } else {
                
                // Same line
                
                if realCharCount < nodeCount {
                    
                    // Re-use existing SKSpriteNode and re-assign the correct texture
                    letterSprite = children[realCharCount] as! SKSpriteNode
                    letterSprite.texture = font.charsTextures[Int(c)]
                    letterSprite.size = letterSprite.texture!.size()
                    
                } else {
                    
                    // Create a new SKSpriteNode and assign correct texture
                    letterSprite = SKSpriteNode(texture: font.charsTextures[Int(c)])
                    addChild(letterSprite)
                    
                }
                
                // Set letter node properties
                letterSprite.colorBlendFactor = _colorBlendFactor
                letterSprite.color = _color
                letterSprite.anchorPoint = CGPoint.zero
                letterSprite.texture!.filteringMode = _filteringMode
                
                // Set letter node position
                letterSprite.position = CGPoint(
                    x: pos.x + CGFloat(font.xOffset(for: c) + font.kerning(for: lastCharID, second: c)) / scaleFactor,
                    y: pos.y - (letterSprite.size.height + CGFloat(font.yOffset(for: c)) / scaleFactor)
                )
                
                // Store the position in the letter sprites userData for later use
                letterSprite.userData = ["originalPosition" : letterSprite.position]
                
                // Make room for next letter
                pos.x += CGFloat(font.xAdvance(for: c) + font.kerning(for: lastCharID, second: c)) / scaleFactor
                
                if newSize.width < pos.x {
                    newSize.width = pos.x
                }
                
                realCharCount += 1
                
            }
            
            lastCharID = c
            
        }
        
        // Adjust the size of the label
        size = newSize
        
    }
    
    
}
