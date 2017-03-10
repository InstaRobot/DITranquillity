//
//  DIStoryboardResolver.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 05/01/17.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import UIKit

final class DIStoryboardResolver: NSObject, _DIStoryboardBaseResolver {
  init(container: DIContainer) {
    self.container = container
    #if ENABLE_DI_MODULE
    self.stackSave = container.resolver.createStackSave()
    #else
    self.stackSave = { $0() } // simply
    #endif
  }

  @objc public func resolve(_ viewController: UIViewController, identifier: String) -> UIViewController {
    stackSave {
      _ = try? self.container.resolve(viewController)
      
      for childVC in viewController.childViewControllers {
        _ = try? self.container.resolve(childVC)
      }
    }

    return viewController
  }

  private let container: DIContainer
  private let stackSave: (() -> ()) -> ()
}