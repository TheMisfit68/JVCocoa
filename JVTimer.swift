//
//  JVTimer.swift
//  MacSunnySender
//
//  Created by Jan Verrept on 26/12/17.
//  Copyright © 2017 OneClick. All rights reserved.
//

import Foundation

extension Timer{
    
    class func startOnMainThread(timeInterval ti: TimeInterval,
                                 target aTarget: Any,
                                 selector aSelector: Selector,
                                 userInfo: Any?,
                                 fireDirect: Bool = false,
                                 repeats yesOrNo: Bool) -> Timer{
        
        let mainThreadTimer = Timer(timeInterval: ti, target: aTarget, selector: aSelector, userInfo: userInfo, repeats: yesOrNo)
        if fireDirect{
            mainThreadTimer.fire()
        }
        RunLoop.main.add(mainThreadTimer, forMode: RunLoopMode.commonModes)

        return mainThreadTimer
    }
    
    
}
