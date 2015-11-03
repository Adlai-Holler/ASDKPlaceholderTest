import Foundation

final class Box<Value>: NSObject {
	let value: Value
	init(value: Value) {
		self.value = value
		super.init()
	}
}

/**
* The =? operator is a conditional assignment.


* frame.size =? CGSize(width: 100, height: 100)

* is equivalent to

* let newSize = CGSize(width: 100, height: 100)
* if frame.size != newSize {
*    frame.size = newSize
* }

* In some cases, assigning the same value is redundant and expensive *cough*UIKit*cough*.
*/
infix operator =? {
	associativity right
	precedence 90
}

func =?<Value: Equatable>(inout lvalue: Value, rvalue: Value) {
	if rvalue != lvalue {
		lvalue = rvalue
	}
}

// NOTE: can't use if it left-hand side is optional-chained. You must use if let unfortunately
func =?<Value: Equatable>(inout lvalue: Value?, rvalue: Value?) {
	if lvalue != rvalue {
		lvalue = rvalue
	}
}

extension NSRange {
	var range: Range<Int> {
		return location..<location+length
	}
	
	init(range: Range<Int>) {
		location = range.startIndex
		length = range.endIndex - range.startIndex
	}
}

extension NSIndexSet {
	func intersectsIndexSet(indexSet: NSIndexSet) -> Bool {
		let copy = NSMutableIndexSet(indexSet: indexSet)
		copy.removeIndexes(self)
		return copy.count > 0
	}
	
	static func indexSetWithInts<S: SequenceType where S.Generator.Element == Int>(ints: S) -> NSMutableIndexSet {
		let result = NSMutableIndexSet()
		for i in ints {
			result.addIndex(i)
		}
		return result
	}
	
}

extension Array {
	/// Attempt to get element at index
	func get(index: Int) -> Element? {
		if index >= 0 && index < count {
			return self[index]
		} else {
			return nil
		}
	}
	
	func filterByType<Result>(type: Result.Type) -> [Result] {
		var result: [Result] = []
		for element in self {
			if let casted = element as? Result {
			result.append(casted)
			}
		}
		return result
	}
	
	/// If index == count, appends. Otherwise is normal set.
	mutating func setOrAppend(index: Int, value: Element)  {
		if index == count {
			append(value)
		} else {
			self[index] = value
		}
	}
	
	/// Attempt to map each element, return nil on failure
	func attemptMap<U>(f: Element -> U?) -> Array<U>? {
		var result = [U]()
		for element in self {
			if let mapped = f(element) {
				result.append(mapped)
			} else {
				return nil
			}
		}
		return result
	}
	
	/// Filter self by uniquing on the value returned by f
	func unique<V: Hashable>(f: (Element -> V)) -> [Element] {
		var seen = Set<V>()
		return filter { element in
			let val = f(element)
			if seen.contains(val) {
				return false
			} else {
				seen.insert(val)
				return true
			}
		}
	}
	
	var nonEmptyArray: [Element]? {
		return isEmpty ? nil : self
	}
	
}

func +=<T>(inout lhs: [T], newElement: T) {
	lhs.append(newElement)
}

func +=(inout lhs: NSMutableAttributedString, rhs: NSAttributedString) {
	lhs.appendAttributedString(rhs)
}

// MARK: String

typealias StringAttributes = [String: AnyObject]
typealias EmailAddress = String

extension String {
	
	func attributed(attributes: StringAttributes) -> NSAttributedString {
		return NSAttributedString(string: self, attributes: attributes)
	}
	
	/**
	NOTE: Prefer the immutable variant – immutable attributed strings
	are never copied
	*/
	func attributedMutable(attributes: StringAttributes) -> NSMutableAttributedString {
		return NSMutableAttributedString(string: self, attributes: attributes)
	}
	
	var nonEmptyString: String? {
		return self.isEmpty ? nil : self
	}
	
	var range: NSRange {
		return NSMakeRange(0, (self as NSString).length)
	}
	
	static let emailRegEx = try! NSRegularExpression(pattern: "[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+(?:[A-Z]{2}|.*)\\b", options: [])
	
	var emailAddress: EmailAddress? {
		if String.emailRegEx.rangeOfFirstMatchInString(self, options: [], range: self.range) == self.range {
			return self as EmailAddress
		} else {
			return nil
		}
	}
	
	var camelCase: String {
		// convert underscores to camelcase
		let components = componentsSeparatedByString("_")
		var result = ""
		for (i, component) in components.enumerate() {
			if i == 0 {
				result += component
			} else {
				result += component.capitalizedString
			}
		}
		return result
	}
}
// Compiler throws redundant conformance error if I do this:
//extension NSRange: Equatable { }

public func ==(range0: NSRange, range1: NSRange) -> Bool {
	return NSEqualRanges(range0, range1)
}

extension Optional {
	func assertNonNil(userInfo: CustomStringConvertible = "(none)") -> Optional {
		assert(self != nil, "Expected optional \(Wrapped.self) to be non-nil. User info: \(userInfo)")
		return self
	}
}

public func ==(attrStr0: NSAttributedString, attrStr1: NSAttributedString) -> Bool {
	return attrStr0.isEqualToAttributedString(attrStr1)
}

extension NSAttributedString {
	
	var range: NSRange {
		return NSMakeRange(0, length)
	}
}