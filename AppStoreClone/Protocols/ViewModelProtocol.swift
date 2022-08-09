//
//  ViewModelProtocol.swift
//  AppStoreClone
//
//  Created by Hyoju Son on 2022/08/08.
//

import Foundation

protocol ViewModelProtocol: AnyObject {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}
