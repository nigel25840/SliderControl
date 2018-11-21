//
//  SliderPathLayer.swift
//  GaugeSlider
//
//  Created by Phil Townsend on 11/21/18.
//  Copyright © 2018 Phil Townsend. All rights reserved.
//

import UIKit

class SliderPathLayer: CALayer {
    weak var gSlider:GSlider?
    
    override func draw(in ctx: CGContext) {
        guard let slider = gSlider else { return }
        
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        ctx.addPath(path.cgPath)
        
        ctx.setFillColor(slider.pathTintColor.cgColor)
        ctx.fillPath()
        
        ctx.setFillColor(slider.pathHighlightColor.cgColor)
        let lowerValuePosition = slider.position(forValue: slider.lowValue)
        let upperValuePosition = slider.position(forValue: slider.highValue)
        let rect = CGRect(x: lowerValuePosition, y: 0,
                          width: upperValuePosition - lowerValuePosition,
                          height: bounds.height)
        ctx.fill(rect)
    }
}
