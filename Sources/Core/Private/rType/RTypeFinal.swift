//
//  RTypeFinal.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 18/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

class RTypeFinal: RTypeBase {
  typealias MethodKey = String
  
  init(typeInfo: DITypeInfo, initials: [MethodKey: Any], injections: [(_: DIContainer, _: Any) -> ()], names: Set<String>, isDefault: Bool, lifeTime: DILifeTime) {
    self.initials = initials
    self.injections = injections
    self.names = names
    self.isDefault = isDefault
    self.lifeTime = lifeTime
    super.init(typeInfo: typeInfo)
  }
  
  func new<Method, T>(_ method: (Method) -> T) -> T {
    let initializer = initials[MethodKey(describing: Method.self)] as! Method
    return method(initializer)
  }
  
  func has(name: String) -> Bool {
    return names.contains(name)
  }
  
  let lifeTime: DILifeTime
  let isDefault: Bool
  let injections: [(_: DIContainer, _: Any) -> ()]
  
  private let initials: [MethodKey: Any]
  private let names: Set<String>
}
