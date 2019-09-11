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
    
    private let viewModel: OpenShopViewModel
    
    init() {
        let useCase = OpenShopUsecase()
        
        useCase.getDomainNameSuggestion = {
            return Observable.just("\($0)-4")
        }
        
        useCase.checkShopName = { _ in
            return Observable.just(nil)
        }
        
        self.viewModel = OpenShopViewModel(useCase: useCase)
        
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
        let input = OpenShopViewModel.Input(
            shopNameTrigger: shopNameTextField.rx
                .controlEvent(.editingChanged)
                .withLatestFrom(shopNameTextField.rx.text)
                .filterNil()
                .asDriverOnErrorJustComplete()
        )
        
        let output = viewModel.transform(input: input)
        
        output.shopNameError.drive(onNext:{ [weak self] value in
            if let value = value, value.isNotEmpty {
                self?.shopNameError.text = value
            }
            
            self?.shopNameError.isHidden = value?.isEmpty ?? true
        })
        .disposed(by: rx_disposeBag)
        
        output.domainName.drive(onNext:{ [weak self] text in
            self?.domainNameTextField.text = text
        })
        .disposed(by: rx_disposeBag)
    }
}
