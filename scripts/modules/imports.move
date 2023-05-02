/*
IMPORTANT

 |
 | The default context in Move is empty: the only types you can use are primitives
 | (integers, bool and address), and the only thing you can do within this empty
 | context is to operate on these types and variables, while being unable to do anything
 | meaningful or useful.
 |

*/

/// In this example, we've imported the `Offer` module from address 0x1 (standard
/// library), and used its method assert!(expr: bool, code: u8).
script {
    fun main(a: u8) {
        0x1::Offer::assert!(a == 10, 1);
    }
}

/// To make code shorter (remember that only 0x1 address is short, actual
/// addresses are pretty long!) and to organize imports you can use keyword use:
///
/// `use <Address>::<ModuleName>;`
///
/// Here <Address> is a publisher's address and <ModuleName> is a name of a
/// module. Pretty simple. Same here, we'll import Vector module from 0x1.
///
/// `use 0x1::Vector;`
///

/// To access imported module's methods (or types) use :: notation. Simple as that -
/// modules can only have one level of definitions so everything you define in the
/// module (publicly) can be accessed via double colon.
script {
    use 0x1::Vector;

    fun main() {
        // here we use method empty() of module Vector
        // the same way we'd access any other method of any other module
        let _ = Vector::empty<u64>();
    }
}

/*
IMPORTANT

1. In scripts imports must be placed inside a script {} block:
2. Module imports must be specified inside a module {} block:

*/

script {
    use 0x1::Vector;
    fun main() {
        let _ = Vector::empty<u64>();
    }
}

module Math {
    use 0x1::Vector;
    public fun empty_vec(): vector<u64> {
        Vector::empty<u64>();
    }
}

/// An import to `Self` functions the same as an import to `self` in Rust.
script {
    use 0x1::Vector::{
        Self, // Self == Imported module
        empty
    };

    fun main() {
        // `empty` imported as `empty`
        let vec = empty<u8>();

        // Self means Vector
        Vector::push_back(&mut vec, 10);
    }
}

/// To resolve naming conflicts (when 2 or more modules have same names) and to
/// shorten you code, you can change name of the imported module using keyword as.
script {
    use 0x1::Vector as V; // V now means Vector

    fun main() {
        V::empty<u64>();
    }
}

/// The same in module:
module Math {
    use 0x1::Vector as Vec;

    fun length(&v: vector<u8>): u64 {
        Vec::length(&v)
    }
}

/// For Self and member import (works in modules and scripts):
script {
    use 0x1::Vector::{
        Self as V, /// the new alias should obviously not clash, either
        empty as empty_vec
    };

    fun main() {
        // `empty` imported as `empty_vec`
        let vec = empty_vec<u8>();

        // Self as V = Vector
        V::push_back(&mut vec, 10);
    }
}