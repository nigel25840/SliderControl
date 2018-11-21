//
//  ViewController.swift
//  GaugeSlider
//
//  Created by Phil Townsend on 11/21/18.
//  Copyright © 2018 Phil Townsend. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let slider = GSlider(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(slider)
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
    }

    override func viewDidLayoutSubviews() {
        let margin:CGFloat = 20
        let width = view.bounds.width - 2 * margin
        let height:CGFloat = 30
        
        slider.frame = CGRect(x: 0, y: 0, width: width, height: height)
        slider.center = view.center
    }
    
    @objc func sliderValueChanged(_ slider:GSlider) {
        let values = "(\(slider.lowValue) \(slider.highValue))"
        print("Range slider value changed: \(values)")
    }

}

