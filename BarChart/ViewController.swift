//
//  ViewController.swift
//  BarChart
//
//  Created by Christoph Wottawa on 30.05.19.
//  Copyright © 2019 Christoph Wottawa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private var chartView: MacawChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        chartView.contentMode = .scaleAspectFit
    }

    @IBAction func displayChartButtonTapped(_ sender: UIButton) {
        MacawChartView.playAnimations()
    }
    
}

