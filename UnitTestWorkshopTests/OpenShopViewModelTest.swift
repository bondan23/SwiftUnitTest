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

@testable import UnitTestWorkshop

public class OpenShopViewModelTest: QuickSpec {
    // MARK: Input
    private let inputShopNameTrigger = PublishSubject<String>()
    
    // MARK: Output
    private var shopNameErrorValue: TestObserver<String?>!
    private var domainNameValue: TestObserver<String>!
    
    var disposebag = DisposeBag()
    
    private func setupBinding(viewModel: OpenShopViewModel) {
        disposebag = DisposeBag()
        
        domainNameValue = TestObserver<String>()
        shopNameErrorValue = TestObserver<String?>()
        
        let input = OpenShopViewModel.Input(
            shopNameTrigger: inputShopNameTrigger.asDriverOnErrorJustComplete()
        )
        
        let output = viewModel.transform(input: input)
        
        output.domainName.drive(domainNameValue.observer).disposed(by: disposebag)
        output.shopNameError.drive(shopNameErrorValue.observer).disposed(by: disposebag)
    }
    
    
    public override func spec() {
        var useCase = OpenShopUsecase()
        beforeEach {
            useCase = OpenShopUsecase()
            let viewModel = OpenShopViewModel(useCase: useCase)
            self.setupBinding(viewModel: viewModel)
        }
        
        describe("Give me open shop screen") {
            context("When typing shop name") {
                it("Then Valid Shopname, will generate domain name suggestion") {
                    
                }
                
                it("Then invalid shopname, still generate the domain name") {
                    
                }
                
                it("Then show Error when shop name has less than 3 characters") {
                    
                }
            }
        }
    }
}
