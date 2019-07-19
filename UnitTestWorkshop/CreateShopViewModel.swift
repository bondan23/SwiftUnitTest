//
//  CreateShopViewModel.swift
//  TokopediAlone
//
//  Created by Bondan Eko Prasetyo on 15/07/19.
//  Copyright © 2019 Jefferson Setiawan. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxOptional

class CreateShopViewModel: ViewModelType {
    struct Input {
        let inputCityTrigger: Driver<City?>
        let inputShopNameTrigger: Driver<String>
        let inputDomainNameTrigger: Driver<String>
        let inputPostalCodeTrigger: Driver<Void>
        let switchTNCTrigger: Driver<Bool>
    }
    
    struct Output {
        let shopNameValue: Driver<String>
        let shopNameError: Driver<String?>
        let domainNameValue: Driver<String>
        let domainNameError: Driver<String?>
        let cityValue: Driver<City>
        let cityError: Driver<String?>
        let postalCodeValue: Driver<String>
        let postalCodeError: Driver<String?>
        let submitButton: Driver<Bool>
    }
    
    private let useCase: CreateShopUsecase
    
    init(useCase: CreateShopUsecase) {
        self.useCase = useCase
    }
    
    func transform(input: CreateShopViewModel.Input) -> CreateShopViewModel.Output {
        
        
        return Output(
            shopNameValue: .empty(),
            shopNameError: .empty(),
            domainNameValue: .empty(),
            domainNameError: .empty(),
            cityValue: .empty(),
            cityError: .empty(),
            postalCodeValue: .empty(),
            postalCodeError: .empty(),
            submitButton: .empty()
        )
    }
}
