//
//  CreateShopViewController.swift
//  TokopediAlone
//
//  Created by Bondan Eko Prasetyo on 12/07/19.
//  Copyright © 2019 Jefferson Setiawan. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class OpenShopViewController: UIViewController {
    @IBOutlet var shopNameTextField: UITextField!
    @IBOutlet var shopNameError: UILabel!
    @IBOutlet var domainNameTextField: UITextField!
    @IBOutlet var domainNameError: UILabel!
    @IBOutlet var selectCityButton: UIButton!
    @IBOutlet var cityError: UILabel!
    @IBOutlet var postalCodeError: UILabel!
    @IBOutlet var postalCodeButton: UIButton!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var switchTNC: UISwitch!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func selectCity(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        self.bindViewModel()
    }
    
    func bindViewModel() {
        
    }
}
