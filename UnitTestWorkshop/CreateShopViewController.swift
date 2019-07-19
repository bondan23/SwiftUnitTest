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


//func greek <Whole, Part> (keyPath: WritableKeyPath<Whole, Part>, part: Part) -> ((Whole) -> Whole) {
//    print(keyPath, "hmm")
//    return lens(keyPath) .~ part
//}

class CreateShopViewController: UIViewController {
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
    
    private let selectedCitySubject = PublishSubject<City?>()
    
    private let viewModel: CreateShopViewModel
    
    init(useCase: CreateShopUsecase) {
        self.viewModel = CreateShopViewModel(useCase: useCase)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func selectCity(_ sender: Any) {
        let vc = CityViewController()
        vc.selectedCityDriver.drive(selectedCitySubject).disposed(by: rx_disposeBag)
        self.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        self.bindViewModel()
    }
    
    func bindViewModel() {
        let input = CreateShopViewModel.Input(
            inputCityTrigger: selectedCitySubject.asDriverOnErrorJustComplete(),
            didLoadTrigger: .just(()),
            shopNameTrigger: self.shopNameTextField.rx.controlEvent(.editingChanged).withLatestFrom(self.shopNameTextField.rx.value).filterNil().asDriverOnErrorJustComplete(),
            domainNameTrigger: self.domainNameTextField.rx.controlEvent(.editingChanged).withLatestFrom(self.domainNameTextField.rx.value).filterNil().asDriverOnErrorJustComplete(),
            postalCodeTrigger: postalCodeButton.rx.tap.asDriver(),
            switchTNCTrigger: self.switchTNC.rx.controlEvent(.valueChanged).withLatestFrom(self.switchTNC.rx.value).asDriverOnErrorJustComplete()
        )
        
        let output = self.viewModel.transform(input: input)
        
        output.domainNameValue.drive(onNext:{ [weak self] value in
            self?.domainNameTextField.text = value
        }).disposed(by: rx_disposeBag)
        
        output.shopNameError.drive(onNext:{ [weak self] value in
            if let value = value, value.isNotEmpty {
                self?.shopNameError.text = value
            }
            
            self?.shopNameError.isHidden = value?.isEmpty ?? true
        }).disposed(by: rx_disposeBag)
        
        output.domainNameError.drive(onNext:{ [weak self] value in
            if let value = value {
                self?.domainNameError.text = value
            }
            
            self?.domainNameError.isHidden = value?.isEmpty ?? true
        }).disposed(by: rx_disposeBag)
        
        output.city.map { $0.name }.drive(selectCityButton.rx.title()).disposed(by: rx_disposeBag)
        output.cityError.drive(onNext:{ [weak self] value in
            self?.cityError.text = value
            self?.cityError.isHidden = value?.isEmpty ?? true
        }).disposed(by: rx_disposeBag)
        output.postalCode.drive(self.postalCodeButton.rx.title()).disposed(by: rx_disposeBag)
        output.postalCodeError.drive(onNext:{ [weak self] value in
            self?.postalCodeError.text = value
            self?.postalCodeError.isHidden = value?.isEmpty ?? true
        }).disposed(by: rx_disposeBag)
        output.submitButton.drive(self.submitButton.rx.isEnabled).disposed(by: rx_disposeBag)
    }

}
