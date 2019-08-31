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
    
    public override func spec() {
        describe("Open Shop Screen") {
            context("When typing shop name") {
                it("Then Valid Shopname, will generate domain name suggestion") {
                    self.inputShopNameTrigger.onNext("TopedShop")
                    self.domainNameValue.assertValue("TopedShop-4")
                }
            }
        }
    }
}
