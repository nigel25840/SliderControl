//
//  Slider.swift
//  GaugeSlider
//
//  Created by Phil Townsend on 11/21/18.
//  Copyright © 2018 Phil Townsend. All rights reserved.
//

import UIKit

class GSlider: UIControl {
    
    var handleImage = #imageLiteral(resourceName: "Oval") {
        didSet {
            highHandle.image = handleImage
            lowHandle.image = handleImage
            updateLayers()
        }
    }
    
    var highlightedHandleImage = #imageLiteral(resourceName: "HighlightedOval") {
        didSet {
            highHandle.highlightedImage = highlightedHandleImage
            lowHandle.highlightedImage = highlightedHandleImage
            updateLayers()
        }
    }
    
    
    private var previousPosition = CGPoint()

    var pathTintColor = UIColor(white: 0.9, alpha: 1.0) { didSet { tLayer.setNeedsDisplay() } }
    var pathHighlightColor = UIColor(red: 0.0, green: 0.45, blue: 0.94, alpha: 1.0) { didSet { tLayer.setNeedsDisplay() } }
    
    // the allowable range of the slider
    var minValue: CGFloat = 0 { didSet{ updateLayers() } }
    var maxValue: CGFloat = 1 { didSet{ updateLayers() } }
    
    // user defined values
    var lowValue: CGFloat = 0.2 { didSet{ updateLayers() } }
    var highValue: CGFloat = 0.8 { didSet{ updateLayers() } }
    
    private let tLayer = SliderPathLayer()
    private let lowHandle = UIImageView()
    private let highHandle = UIImageView()
    
    override var frame: CGRect {
        didSet{ updateLayers() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tLayer.gSlider = self
        tLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(tLayer)
        
        lowHandle.image = handleImage
        highHandle.image = handleImage
        addSubview(lowHandle)
        addSubview(highHandle)
        updateLayers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateLayers() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        tLayer.frame = bounds.insetBy(dx: 0.0, dy: bounds.height / 3)
        tLayer.setNeedsDisplay()
        lowHandle.frame = CGRect(origin: handleOrigin(forValue: lowValue), size: handleImage.size)
        highHandle.frame = CGRect(origin: handleOrigin(forValue: highValue), size: handleImage.size)
        CATransaction.commit()
    }
    
    private func handleOrigin(forValue value:CGFloat) -> CGPoint {
        let pos = position(forValue: value) - (handleImage.size.width)
        return CGPoint(x: pos, y: (bounds.height - handleImage.size.height))
    }
    
    func position(forValue value:CGFloat) -> CGFloat {
        return bounds.width * value
    }
    
    private func boundValue(_ value: CGFloat, toLowerValue lowerValue: CGFloat, upperValue: CGFloat) -> CGFloat {
        return min(max(value, lowerValue), upperValue)
    }
    
    // UIControl Overrides
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        previousPosition = touch.location(in: self)
        if lowHandle.frame.contains(previousPosition) {
            lowHandle.isHighlighted = true
        } else if highHandle.frame.contains(previousPosition) {
            highHandle.isHighlighted = true
        }
        return lowHandle.isHighlighted || highHandle.isHighlighted
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        let location = touch.location(in: self)
        let deltaLocation = location.x - previousPosition.x
        let deltaValue = (maxValue - minValue) * deltaLocation / bounds.width
        
        previousPosition = location

        if lowHandle.isHighlighted {
            lowValue += deltaValue
            lowValue = boundValue(lowValue, toLowerValue: minValue, upperValue: highValue)
        } else if highHandle.isHighlighted {
            highValue += deltaValue
            highValue = boundValue(highValue, toLowerValue: lowValue, upperValue: maxValue)
        }
        
        sendActions(for: .valueChanged)
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        lowHandle.isHighlighted = false
        highHandle.isHighlighted = false
    }
    
}
