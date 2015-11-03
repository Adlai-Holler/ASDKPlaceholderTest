
import UIKit

public struct GlobalStyle {
	
	struct Placeholder {
		static let titleAttr: StringAttributes = [
			NSFontAttributeName: UIFont.systemFontOfSize(18, weight: UIFontWeightMedium),
			NSForegroundColorAttributeName: UIColor.blackColor()
		]
		static let messageAttr: StringAttributes = [
			NSFontAttributeName: UIFont.systemFontOfSize(13, weight: UIFontWeightRegular),
			NSForegroundColorAttributeName: UIColor.grayColor()
		]
		static let buttonAttr: StringAttributes = [
			NSFontAttributeName: UIFont.systemFontOfSize(13, weight: UIFontWeightRegular),
			NSForegroundColorAttributeName: UIColor.grayColor()
		]
	}

}