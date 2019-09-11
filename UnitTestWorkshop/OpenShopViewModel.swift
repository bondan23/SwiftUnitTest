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

class OpenShopViewModel: ViewModelType {
    struct Input {
        let shopNameTrigger: Driver<String>
    }
    
    struct Output {
        let shopNameError: Driver<String?>
        let domainName: Driver<String>
    }
    
    private let useCase: OpenShopUsecase
    
    init(useCase: OpenShopUsecase) {
        self.useCase = useCase
    }
    
    func transform(input: OpenShopViewModel.Input) -> OpenShopViewModel.Output {
        
        let domainName = input.shopNameTrigger.flatMapLatest{ [useCase] name in
            useCase.getDomainNameSuggestion(name)
                .asDriverOnErrorJustComplete()
        }
        
        
        let lessThan3 = input.shopNameTrigger.filter {
            $0.count < 3
        }.map { _ -> String? in .some("Should not less than 3 characters") }

        
        let checkShopName = input.shopNameTrigger
            .filter{ $0.count >= 3}
            .flatMapLatest{ [useCase] name in
            useCase.checkShopName(name)
                .asDriverOnErrorJustComplete()
        }
        
        let shopNameError = Driver.merge(
            checkShopName,
            lessThan3
        )
        
        return Output(
            shopNameError: shopNameError,
            domainName: domainName
        )
    }
}
