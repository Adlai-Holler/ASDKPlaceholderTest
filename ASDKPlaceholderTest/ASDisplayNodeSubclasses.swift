
import Foundation
import AsyncDisplayKit
import UIKit


private let UIActivityIndicatorViewDefaultSize = CGSize(width: 20, height: 20)
private let UIActivityIndicatorViewLargeSize = CGSize(width: 37, height: 37)

/**
A node that shows a `UIActivityIndicatorView`. Does not support layer backing.

Note: You must not change the style to or from `.WhiteLarge` after init, or the node's size will not update.
*/
class ActivityIndicatorNode: ASDisplayNode {
	init(activityIndicatorStyle: UIActivityIndicatorViewStyle) {
		super.init(viewBlock: { UIActivityIndicatorView(activityIndicatorStyle: activityIndicatorStyle) }, didLoadBlock: nil)
		preferredFrameSize = activityIndicatorStyle == .WhiteLarge ? UIActivityIndicatorViewLargeSize : UIActivityIndicatorViewDefaultSize
	}
	
	var activityIndicatorView: UIActivityIndicatorView {
		return view as! UIActivityIndicatorView
	}
	
	override func didLoad() {
		super.didLoad()
		if animating {
			activityIndicatorView.startAnimating()
		}
		activityIndicatorView.color = color
		activityIndicatorView.hidesWhenStopped = hidesWhenStopped
	}
	
	/// Wrapper for `UIActivityIndicatorView.hidesWhenStopped`. NOTE: You must respect thread affinity.
	var hidesWhenStopped = true {
		didSet {
			if nodeLoaded {
				assert(NSThread.isMainThread())
				activityIndicatorView.hidesWhenStopped = hidesWhenStopped
			}
		}
	}
	
	/// Wrapper for `UIActivityIndicatorView.color`. NOTE: You must respect thread affinity.
	var color: UIColor? {
		didSet {
			if nodeLoaded {
				assert(NSThread.isMainThread())
				activityIndicatorView.color = color
			}
		}
	}
	
	/// Wrapper for `UIActivityIndicatorView.animating`. NOTE: You must respect thread affinity.
	var animating = false {
		didSet {
			if nodeLoaded {
				assert(NSThread.isMainThread())
				if animating {
					activityIndicatorView.startAnimating()
				} else {
					activityIndicatorView.stopAnimating()
				}
			}
		}
	}
}
