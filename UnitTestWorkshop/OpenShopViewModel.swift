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
        let domainName: Driver<String>
        let shopNameError: Driver<String?>
    }
    
    private let useCase: OpenShopUsecase
    
    init(useCase: OpenShopUsecase) {
        self.useCase = useCase
    }
    
    func transform(input: OpenShopViewModel.Input) -> OpenShopViewModel.Output {
        let getDomainName = input.shopNameTrigger.flatMapLatest{ [useCase] name in
            return useCase.getDomainName(name)
        }
        
        let lessThan3 = input.shopNameTrigger.filter{ $0.count < 3 }.map{ name -> String? in
            return .some("Less than 3 characters")
        }
        
        let checkShopName = input.shopNameTrigger.filter{ $0.count > 3 }.flatMapLatest{ [useCase] name in
            return useCase.checkShopName(name)
        }
        
        let shopNameError = Driver.merge(
            lessThan3,
            checkShopName
        )
        
        return Output(
            domainName: getDomainName,
            shopNameError: shopNameError
        )
    }
}
