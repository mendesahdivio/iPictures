//
//  iPicturesTests.swift
//  iPicturesTests
//
//  Created by Ahdivio Matian Mendes on 21/04/21.
//

import XCTest
@testable import iPictures

class iPicturesTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results
        
        func genericfunc<T:Numeric>(a:T,b:T)->T{
        let sum = a + b
        return sum
    }
        
        
        let data:(Int) -> (Int) = { num in
            genericfunc(a: num, b: num)
           }
        
     let a = data(2)
       
     
        
       
    }
    
    
    func testStoreData(){
        let data = GData()
        data.FetchImageDataFromLibrary()
       print(data.ImageAndDiscritption)
        if data.ImageAndDiscritption.ImageData != nil {
            XCTAssert(true,data.ImageAndDiscritption.Catigories!)
        } else{
            XCTAssert(false)
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test cas
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
 

}
