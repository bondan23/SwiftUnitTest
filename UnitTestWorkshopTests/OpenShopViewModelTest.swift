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
    public let inputShopNameTrigger = PublishSubject<String>()
    
    public var domainNameValue: TestObserver<String>!
    public var shopNameErrorValue: TestObserver<String?>!
    
    private var disposeBag = DisposeBag()
    
    public func setupBinding(viewModel: OpenShopViewModel){
        disposeBag = DisposeBag()
        
        // Setup Output
        self.domainNameValue = TestObserver<String>()
        self.shopNameErrorValue = TestObserver<String?>()
        
        let input = OpenShopViewModel.Input(
            shopNameTrigger: inputShopNameTrigger.asDriverOnErrorJustComplete()
        )
        
        let output = viewModel.transform(input: input)
        
        output.domainName.drive(domainNameValue.observer).disposed(by: disposeBag)
        output.shopNameError.drive(shopNameErrorValue.observer).disposed(by: disposeBag)
    }
    
    public override func spec() {
        var useCase = OpenShopUsecase()
        beforeEach {
            useCase = OpenShopUsecase()
            let viewModel = OpenShopViewModel(useCase: useCase)
            self.setupBinding(viewModel: viewModel)
        }
        
        describe("Open Shop Screen") {
            context("When typing shop name") {
                it("Then Valid Shopname, will generate domain name suggestion") {
                    useCase.getDomainName = {
                        .just("\($0)-4")
                    }
                    
                    useCase.checkShopName = { _ in
                        .just(nil)
                    }
                    
                    self.inputShopNameTrigger.onNext("TopedShop")
                    self.domainNameValue.assertValue("TopedShop-4")
                }
                
                it("Then Invalid Shopname, still generate the domain name") {
                    useCase.getDomainName = {
                        .just("\($0)-4")
                    }
                    
                    useCase.checkShopName = { _ in
                        .just("Shop name not available")
                    }
                    
                    self.inputShopNameTrigger.onNext("Tokopedia")
                    self.domainNameValue.assertValue("Tokopedia-4")
                    self.shopNameErrorValue.assertValue("Shop name not available")
                }
            }
        }
    }
}
