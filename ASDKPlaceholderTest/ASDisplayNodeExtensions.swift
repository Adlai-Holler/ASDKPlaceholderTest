
import AsyncDisplayKit

extension ASDisplayNode {
	
	/// If these text attributes contain a font, updates the ascender and the descender for this node's layout. NOTE: This is a best-effort function and probably doesn't cover special cases like custom paragraph styles or whatnot
	func configureLayoutForTextAttributes(attr: StringAttributes?) {
		guard let font = attr?[NSFontAttributeName] as? UIFont else {
			return
		}
		descender = font.descender
		ascender = font.ascender
	}
	
	/**
	Executes the block as soon as safely possible.
	
	If node is loaded and this calls is not on the main thread, the update is dispatched onto the main queue and this method returns immediately
	FIXME: Use generics when the sourcekit stops being such a fucking idiot.
	*/
	func performUpdate(update: (ASDisplayNode -> Void)) {
		if NSThread.isMainThread() || !nodeLoaded {
			update(self)
		} else {
			dispatch_async(dispatch_get_main_queue(), { [weak self] in
				if let strongSelf = self {
					update(strongSelf)
				}
			})
		}
	}
	
	/**
	Perform the provided selector as soon as safely possible for accessing UIKit properties
	
	If node is loaded and this calls is not on the main thread, the update is dispatched onto the main queue and this method returns immediately
	FIXME: Use generics when the sourcekit stops being such a fucking idiot.
	*/
	func performSelectorRespectingAffinity(selector: Selector, withObject object: AnyObject? = nil) {
		if NSThread.isMainThread() || !nodeLoaded {
			performSelector(selector, withObject: object)
		} else {
			// NOTE: we don't use `performSelectorOnMainThread` here because that adds the perform
			// into the run loop, which means that it may be executed out-of-order compared to other
			// blocks added by `dispatch_async`
			dispatch_async(dispatch_get_main_queue()) { [weak self] in
				self?.performSelector(selector, withObject: object)
			}
		}
	}
	
	/**
	Executes the block as soon as safely possible, waiting for it to finish
	
	If node is loaded and this calls is not on the main thread, the update is dispatched onto the main queue and this method blocks until the update is completed
	FIXME: Use generics when the sourcekit stops being such a fucking idiot.
	*/
	func performUpdateAndWait(update: (ASDisplayNode -> Void)) {
		if NSThread.isMainThread() || !nodeLoaded {
			return update(self)
		} else {
			dispatch_sync(dispatch_get_main_queue(), { [weak self] in
				if let strongSelf = self {
					update(strongSelf)
				}
			})
		}
	}
}

/// Often a collection of subnodes should have these settings applied
extension SequenceType where Generator.Element: ASDisplayNode {
	func optimize() {
		for node in self {
			node.layerBacked = true
			node.opaque = true
			node.backgroundColor = UIColor.whiteColor()
		}
	}
}
