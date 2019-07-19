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
        let didLoadTrigger: Driver<Void>
        let shopNameTrigger: Driver<String>
        let domainNameTrigger: Driver<String>
        let postalCodeTrigger: Driver<Void>
        let switchTNCTrigger: Driver<Bool>
    }
    
    struct Output {
        let shopNameValue: Driver<String>
        let shopNameError: Driver<String?>
        let domainNameValue: Driver<String>
        let domainNameError: Driver<String?>
        let city: Driver<City>
        let cityError: Driver<String?>
        let postalCodeError: Driver<String?>
        let postalCode: Driver<String>
        let submitButton: Driver<Bool>
    }
    
    private let useCase: CreateShopUsecase
    
    init(useCase: CreateShopUsecase) {
        self.useCase = useCase
    }
    
    func transform(input: CreateShopViewModel.Input) -> CreateShopViewModel.Output {
        /* VALIDATION */
        var cityIsSelected: Bool = false
        var postalCodeSelected: Bool = false
        var selectedValidDomain: Bool = false
        var isDIYType: Bool = false
        
        let isShopEmpty = input.shopNameTrigger.map { $0.isEmpty }
        let isValidCount = input.shopNameTrigger
            .withLatestFrom(isShopEmpty) { ($0, $1) }
            .filter { !$0.1 }
            .map { $0.0.count >= 3 }
        
        let isContainEmptySpaces = input.shopNameTrigger.map { text in text.hasPrefix(" ") || text.hasSuffix(" ") }
        let isContainEmoji = input.shopNameTrigger.map { $0.containsEmoji }
        
        let shopNameValidCheck = Driver.combineLatest(isShopEmpty, isValidCount, isContainEmptySpaces, isContainEmoji)
            .map { !$0 && $1 && !$2 && !$3 }
        
        // Hard enough to be understand
        let shopNameAPIError = input.shopNameTrigger
            .withLatestFrom(shopNameValidCheck) { ($0, $1) }
            .filter { $0.1 }
            .flatMap { [useCase] param in
                useCase.checkShopNameAvailability(param.0)
            }
        
        let shopNameError = Driver.merge(
            isShopEmpty
                .filter { $0 }
                .map { _ -> String in
                    String.requiredField
                },
            isValidCount
                .filter { !$0 }
                .map { _ -> String in
                    String.below3Characters
                },
            isContainEmptySpaces
                .filter { $0 }
                .map { _ in String.shouldNotStartOrEndWithWhiteSpace },
            isContainEmoji
                .filter { $0 }
                .map { _ in String.shouldNotContainEmoji },
            shopNameAPIError
        )
        
        let getDomainName =
            input.shopNameTrigger.flatMap { [useCase] value in
            useCase.getDomainName(value)
        }.map {
            ($0, false)
        }
        
        let domainNameTrigger = Driver.merge(
            getDomainName.filter{ _ in !selectedValidDomain },
            input.domainNameTrigger.map { ($0, true) }
        )
            .do(onNext:{ arg in
                let (_, isDiyType) = arg
                isDIYType = isDiyType
            })
        
        let domainNamecountValidation = domainNameTrigger.filter { $0.0.count < 3 }
        let domainNameAPIError = domainNameTrigger.filter { $0.0.count >= 3 }
            .flatMap { [useCase] (value) -> Driver<String?> in
                useCase.checkDomainNameAvailability(value.0)
            }
        
        let domainNameError = Driver.merge(
            domainNamecountValidation.map { _ in String.below3Characters },
            domainNameAPIError
        )
        .do(onNext:{ value in
            if isDIYType {
                selectedValidDomain = value == nil
            }
        })
        
        
        let selectedCity = input.inputCityTrigger
            .filterNil()
            .map{ $0 }
        
        let cityError = Driver.merge(
            input.inputCityTrigger
                .filter { _ in !cityIsSelected }
                .do(onNext: { city in
                    cityIsSelected = city != nil
                })
                .map { value in
                    value == nil ? String.requiredField : nil
                },
            input.postalCodeTrigger.map { _ in
                return !cityIsSelected ? String.requiredField : nil
            }
        )
        
        useCase.getPostalCode = { city -> Driver<String?> in
            let vc = PostalCodeViewController(city: city)
            let nav = UINavigationController(rootViewController: vc)
            UIApplication.topViewController()?.present(nav, animated: true, completion: nil)
            return vc.postalCodeSelected
        }
        
        let postalCode = input.postalCodeTrigger
            .withLatestFrom(selectedCity)
            .flatMap{ [useCase] (city) -> Driver<String?> in
                return useCase.getPostalCode(city)
        }
        
        let newPostalCode = Driver.merge(
            postalCode.filterNil(),
            selectedCity
                .filter { _ in postalCodeSelected }
                .map{ _ in return .postalCodePlaceholder }
        )
        .do(onNext:{
            // if value == postal code, mean reset
            postalCodeSelected = $0 != .postalCodePlaceholder
        })
        
        let postalCodeError = postalCode.map{ _ in
            return !postalCodeSelected ? String.requiredField : nil
        }
        
        // ERROR DRIVER SHOULD BE NIL TO MAKE IT EASY WHEN CREATE VALIDATOR
        let validButton = Driver.combineLatest(
            shopNameError.map{ $0 == nil },
            domainNameError.map{ $0 == nil},
            cityError.map { $0 == nil },
            postalCodeError.map{ $0 == nil },
            input.switchTNCTrigger
        )
        .map{ $0 && $1 && $2 && $3 && $4 }
        
        return Output(
            shopNameValue: .empty(),
            shopNameError: shopNameError,
            domainNameValue: domainNameTrigger.map{ $0.0 },
            domainNameError: domainNameError.map { $0 },
            city: selectedCity,
            cityError: cityError,
            postalCodeError: postalCodeError,
            postalCode: newPostalCode,
            submitButton: validButton
        )
    }
}
