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
        
        let shopNameError = input.shopNameTrigger.flatMapLatest{ [useCase] name in
            return useCase.checkShopName(name)
        }
        
        return Output(
            domainName: getDomainName,
            shopNameError: shopNameError
        )
    }
}
