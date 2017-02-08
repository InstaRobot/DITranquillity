//
//  DIStoryboard.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 03/10/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import Cocoa

public final class DIStoryboard: NSStoryboard {
  public required init(name: String, bundle storyboardBundleOrNil: Bundle?, container: DIContainer) {
    storyboard = _DIStoryboardBase.create(name, bundle: storyboardBundleOrNil)
    super.init()
    storyboard.resolver = DIStoryboardResolver(container: container)
  }

  public override func instantiateInitialController() -> Any? {
    return storyboard.instantiateInitialController()
  }

  public override func instantiateController(withIdentifier identifier: String) -> Any {
    return storyboard.instantiateController(withIdentifier: identifier)
  }
  
  private let storyboard: _DIStoryboardBase
}

public extension DIContainerBuilder {
	@discardableResult
	public func register<T: AnyObject>(vc type: T.Type, file: String = #file, line: Int = #line) -> DIRegistrationBuilder<T> {
		return DIRegistrationBuilder<T>(container: self.rTypeContainer, typeInfo: DITypeInfo(type: type, file: file, line: line))
			.as(.self)
			.initialNotNecessary()
	}
}

public extension DIRegistrationBuilder where ImplObj: NSViewController {
  @discardableResult
	public func initial<T: NSViewController>(nib type: T.Type) -> Self {
		rType.append(initial: { NSViewController(nibName: String(describing: type), bundle: Bundle(for: type)) as! T })
		return self
	}
	
	@discardableResult
	public func initial(storyboard: NSStoryboard, identifier: String) -> Self {
		rType.append(initial: { storyboard.instantiateController(withIdentifier: identifier) })
		return self
	}
	
	@discardableResult
	public func initial(storyboard closure: @escaping (_: DIContainer) -> NSStoryboard, identifier: String) -> Self {
		rType.append(initial: { container in closure(container).instantiateController(withIdentifier: identifier) })
		return self
	}
}
