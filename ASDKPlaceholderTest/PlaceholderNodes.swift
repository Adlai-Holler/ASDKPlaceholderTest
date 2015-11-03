
import UIKit
import AsyncDisplayKit

private typealias Style = GlobalStyle.Placeholder

/**
An abstract cell node for creating placeholders.

Right now it doesn't do anything.
*/
class PlaceholderCellNode: ASCellNode {
	override init() {
		super.init()
		selectionStyle = .None
	}
}

/**
A placeholder node intended for loading states.
Shows a loading spinner and (optionally) a message.
*/
final class PlaceholderLoadingNode: PlaceholderCellNode {
	/// Don't modify this directly. Instead set the `text` property.
	let textNode = ASTextNode()
	
	let spinner = ActivityIndicatorNode(activityIndicatorStyle: .Gray)
	
	override init() {
		super.init()
		for node in [textNode, spinner] {
			addSubnode(node)
		}
		textNode.hidden = true
		spinner.animating = true
	}
	
	var text: String? {
		didSet {
			performUpdate {
				guard let blockSelf = $0 as? PlaceholderLoadingNode else { return }
				
				blockSelf.textNode.hidden = nil == blockSelf.text?.nonEmptyString
			}
			textNode.attributedString = text?.attributed(Style.messageAttr)
		}
	}

	override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
		return ASCenterLayoutSpec(
			centeringOptions: .XY,
			sizingOptions: .MinimumXY,
			child: ASStackLayoutSpec(
				direction: .Horizontal,
				spacing: 8,
				justifyContent: .Center,
				alignItems: .Center,
				children: [
					textNode,
					spinner
				]))
	}
}
