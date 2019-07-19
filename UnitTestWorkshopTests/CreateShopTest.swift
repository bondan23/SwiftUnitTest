//
//  CreateShopTest.swift
//  TokopediAloneTests
//
//  Created by Bondan Eko Prasetyo on 15/07/19.
//  Copyright © 2019 Jefferson Setiawan. All rights reserved.
//

import Quick
import XCTest
import RxCocoa

@testable import UnitTestWorkshop

private class CreateShopTest: CreateShopViewModelBaseTest {
    override func spec() {
        let useCase = CreateShopUsecase()
        beforeEach {
            self.setupBinding(viewModel: CreateShopViewModel(useCase: useCase))
        }
        
        describe("Hello World") {
            it("Hello Universe") {
                XCTAssertTrue(true)
            }
        }
        
    }
}

