# BMGlyphLabel
A Swift 3 implementation of BMGlyphLabel and BMGlyphFont that makes it easy to add [bmGlyph](https://www.bmglyph.com/) bitmap fonts to your SpriteKit games.

This code is based on [BMGlphyLabelSwift](https://github.com/tapouillo/BMGlyphLabelSwift) by Stéphane Queraud but has been updated to Swift 3 and some new functionality has been added.

##How to use

Include the two files in *BMGlyphLabel* folder in your project:

	BMGlyphFont.swift
	BMGlyphLabel.swift

You will then be able to create a font like so:

	// Create a BMGlyphFont - will load textures from Font texture atlas and font data from Font.xml
	let font = BMGlyphFont(fontName: "Font")
	
	// Create a label with the text "Hello World!" using the font created in previous step
	let label = BMGlyphLabel(text: "Hello World!", font: font)
   
	// BMGlyphLabel is a SKNode, so you need to add it to the scene
	addChild(label)

Loading a BMGlyphFont is relatively expensive so make sure you load the font and cache it.

Since BMGlyphLabel is a subclass of SKNode, you will be able to scale, rotate, translate etc the label as you would any other SKNode.

To change the text in a BMGlyphLabel is as simple as:

	// Change text to "Hello there, stranger!"
	label.text = "Hello there, stranger!"
	
To create a multi-line label, insert "\n" into the string:

	// A multi-line label:
	label.text = "First line\nSecond line"

BMGlyphLabel will allow you to change horizontal and vertical alignment and justification of text:
	
	// Set horizontal and vertical alignment and justification in label:
	label.horizontalAlignment = .Right
	label.verticalAlignment   = .Bottom
	label.justify             = .Center
	
You can also change how the label is rendered:

	// Change how the label is rendered:
	label.color            = SKColor.red
	label.colorBlendFactor = 0.5
	label.filteringMode    = .nearest // This will render pixel fonts crisply
	

##Credits
BMGlyphLabel was created with heavy inspiration from [BMGlphyLabelSwift](https://github.com/tapouillo/BMGlyphLabelSwift) by Stéphane Queraud. I did not fork it because I wanted to optimize it as much as possible to Swift 3 and add new functionality I needed for my own games.

BMGlyph can be downloaded from the [official BMGlyph website](https://www.bmglyph.com/).


##License

MIT License

Copyright (c) 2016 Kim Pedersen

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
