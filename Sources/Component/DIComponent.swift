//
//  DIComponent.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 16/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public protocol DIComponent {
  #if ENABLE_DI_MODULE
  var scope: DIComponentScope { get }
  #endif
  
  func load(builder: DIContainerBuilder)
}

#if ENABLE_DI_MODULE
public extension DIComponent {
  var scope: DIComponentScope { return .internal }
}
#endif

public extension DIContainerBuilder {
  public func register(component: DIComponent) {
    #if ENABLE_DI_MODULE
    let stack = component.realStack(by: self.currentModules)
    component.load(builder: DIContainerBuilder(container: self, stack: stack))
    #else
    component.load(builder: self)
    #endif
  }
}

#if ENABLE_DI_MODULE
extension DIComponent {
  internal func realStack(by stack: [DIModuleType]) -> [DIModuleType] {
    switch scope {
    case .public:
      return stack
    case .internal:
      return Array(stack.suffix(1))
    }
  }
}
#endif