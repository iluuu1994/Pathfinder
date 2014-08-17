//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// A set of unique elements.
public struct Set<Element : Hashable> {
	var _dictionary: Dictionary<Element, Unit> = [:]
	
	public init<S : SequenceType where S.Generator.Element == Element>(_ sequence: S) {
		extend(sequence)
	}
	
	public init() {}
	
	
	public var count: Int { return _dictionary.count }
	
	public func contains(element: Element) -> Bool {
		return _dictionary[element].hasValue
	}
	
	public mutating func insert(element: Element) {
		_dictionary[element] = Unit()
	}
	
	public mutating func remove(element: Element) {
		_dictionary.removeValueForKey(element)
	}
}


/// Sequence conformance.
extension Set : SequenceType {
	public func generate() -> GeneratorOf<Element> {
		var generator = _dictionary.keys.generate()
		return GeneratorOf {
			return generator.next()
		}
	}
}


/// Collection conformance.
///
/// Does not actually conform to Collection because that crashes the compiler.
extension Set {
	public typealias IndexType = DictionaryIndex<Element, Unit>
	public var startIndex: IndexType { return _dictionary.startIndex }
	public var endIndex: IndexType { return _dictionary.endIndex }
	
	public subscript(v: ()) -> Element {
	get { return _dictionary[_dictionary.startIndex].0 }
	set { insert(newValue) }
	}
	
	public subscript(index: IndexType) -> Element {
		return _dictionary[index].0
	}
}

/// ExtensibleCollection conformance.
///
/// Does not actually conform to ExtensibleCollection because that crashes the compiler.
extension Set {
	/// In theory, reserve capacity for \c n elements. However, Dictionary does not implement reserveCapacity(), so we just silently ignore it.
	public func reserveCapacity(n: IndexType.Distance) {}
	
	/// Inserts each element of \c sequence into the receiver.
	public mutating func extend<S : SequenceType where S.Generator.Element == Element>(sequence: S) {
		// Note that this should just be for each in sequence; this is working around a compiler crasher.
		for each in [Element](sequence) {
			insert(each)
		}
	}
}


/// Creates and returns the union of \c set and \c sequence.
public func + <S : SequenceType> (set: Set<S.Generator.Element>, sequence: S) -> Set<S.Generator.Element> {
	var union = Set(set)
	union += sequence
	return union
}


/// Extends /c set with the elements of /c sequence.
public func += <S : SequenceType> (inout set: Set<S.Generator.Element>, sequence: S) {
	set.extend(sequence)
}


/// ArrayLiteralConvertible conformance.
extension Set : ArrayLiteralConvertible {
	public static func convertFromArrayLiteral(elements: Element...) -> Set<Element> {
		return Set(elements)
	}
}


/// Equatable conformance.
public func == <Element : Hashable> (a: Set<Element>, b: Set<Element>) -> Bool {
	return a._dictionary == b._dictionary
}


/// Set is reducible.
extension Set {
	public func reduce<Into>(initial: Into, combine: (Into, Element) -> Into) -> Into {
		return Swift.reduce(self, initial, combine)
	}
}


/// Printable conformance.
extension Set : Printable {
	public var description: String {
		if self.count == 0 { return "{}" }
		
		let joined = join(", ", map(self) { toString($0) })
		return "{ \(joined) }"
	}
}


/// Hashable conformance.
///
/// This hash function has not been proven in this usage, but is based on Bob Jenkins’ one-at-a-time hash.
extension Set : Hashable {
	public var hashValue: Int {
		var h = reduce(0) { into, each in
			var h = into + each.hashValue
			h += (h << 10)
			h ^= (h >> 6)
			return h
		}
		h += (h << 3)
		h ^= (h >> 11)
		h += (h << 15)
		return h
	}
}
