//
//  CreateShopViewModelBaseTest.swift
//  TokopediaTests
//
//  Created by Bondan Eko Prasetyo on 19/07/19.
//  Copyright © 2019 Tokopedia. All rights reserved.
//

import Quick
import RxCocoa
import RxSwift
import XCTest

@testable import UnitTestWorkshop

public class CreateShopViewModelBaseTest: QuickSpec {
    
    public let inputCitySubject = PublishSubject<City?>()
    public let inputShopNameSubject = PublishSubject<String>()
    public let inputDomainNameSubject = PublishSubject<String>()
    public let inputPostalCodeSubject = PublishSubject<Void>()
    public let switchTNCSubject = PublishSubject<Bool>()
    
    public var shopNameValue: TestObserver<String>!
    public var shopNameError: TestObserver<String?>!
    public var domainNameValue: TestObserver<String>!
    public var domainNameError: TestObserver<String?>!
    public var cityValue: TestObserver<City>!
    public var cityError: TestObserver<String?>!
    public var postalCodeValue: TestObserver<String>!
    public var postalCodeError: TestObserver<String?>!
    public var submitButton: TestObserver<Bool>!
    
    public var disposeBag = DisposeBag()
    
    public func setupBinding(viewModel: CreateShopViewModel) {
        disposeBag = DisposeBag()
        
        self.shopNameValue = TestObserver<String>()
        self.shopNameError = TestObserver<String?>()
        self.domainNameValue = TestObserver<String>()
        self.domainNameError = TestObserver<String?>()
        self.cityValue = TestObserver<City>()
        self.cityError = TestObserver<String?>()
        self.postalCodeValue = TestObserver<String>()
        self.postalCodeError = TestObserver<String?>()
        self.submitButton = TestObserver<Bool>()
        
        let input = CreateShopViewModel.Input(
            inputCityTrigger: inputCitySubject.asDriverOnErrorJustComplete(),
            inputShopNameTrigger: inputShopNameSubject.asDriverOnErrorJustComplete(),
            inputDomainNameTrigger: inputDomainNameSubject.asDriverOnErrorJustComplete(),
            inputPostalCodeTrigger: inputPostalCodeSubject.asDriverOnErrorJustComplete(),
            switchTNCTrigger: switchTNCSubject.asDriverOnErrorJustComplete()
        )
        let output = viewModel.transform(input: input)
        output.shopNameValue.drive(self.shopNameValue.observer).disposed(by: disposeBag)
        output.shopNameError.drive(self.shopNameError.observer).disposed(by: disposeBag)
        output.domainNameValue.drive(self.domainNameValue.observer).disposed(by: disposeBag)
        output.domainNameError.drive(self.domainNameError.observer).disposed(by: disposeBag)
        output.cityValue.drive(self.cityValue.observer).disposed(by: disposeBag)
        output.cityError.drive(self.cityError.observer).disposed(by: disposeBag)
        output.postalCodeValue.drive(self.postalCodeValue.observer).disposed(by: disposeBag)
        output.postalCodeError.drive(self.postalCodeError.observer).disposed(by: disposeBag)
        output.submitButton.drive(self.submitButton.observer).disposed(by: disposeBag)
    }
}
