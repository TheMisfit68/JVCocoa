//
//  OCToolbarItem.swift
//  OCCocoa
//
//  Created by Jan Verrept on 26/12/14.
//  Copyright (c) 2014 OneClick. All rights reserved.
//

import Foundation

extension NSToolbarItem{
    
    //MARK: Factory methods/convenience inits

    convenience init(itemIdentifier:String, icon imageOrView:AnyObject?, label:String){
        
        self.init(itemIdentifier:itemIdentifier)
        
        if  let image = imageOrView as? NSImage{
            self.image = image
        }else if let view = imageOrView as? NSView{
            self.view = view
            // Do not scale the view in any way when the toolbar gets resized
            //TODO: Might be a candidate for AutoLayout solution
            self.minSize = view.bounds.size
            self.maxSize = view.bounds.size
        }
        self.label = label
        self.paletteLabel = label
        self.toolTip = label
    }
    
}