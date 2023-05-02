/// A function starts with the fun keyword which is followed by function name,
/// parentheses for arguments and curly braces for body, similarly to Rust.
///
/// ```
/// fun function_name(arg1: u64, arg2: bool): u64 {
///     // function body
/// }
/// ```

/// Note: in Move functions should be named in snake_case - lowercase with underscores as
/// word separators, as in Rust.

/// An example of a simple script, which checks if an address exists:
script {
    use 0x1::Account;
    /// Note: as there's only one function in this script, you can call it any way you
    /// want. However, you may want to follow general programming concepts, and call it `main`.
    fun main(addr: address) {
        assert!(Account::exists(addr), 1);
    }
}

/// Usage of the above:
script {
    use 0x1::Math;  // used 0x1 here; could be your address
    use 0x1::Debug; // this one will be covered later!

    fun main(first_num: u64, second_num: u64) {

        // variables names don't have to match the function's
        let sum = Math::sum(first_num, second_num);

        Debug::print<u64>(&sum);
    }
}

/// Return keyword
module M {
    public fun conditional_return(a: u8): bool {
        if (a == 10) {
            return true // semicolon unnecessary
        };

        if (a < 10) {
            true
        } else {
            false
        }
    }
}

/*
IMPORTANT

By default, every function defined in a module is private - it cannot be accessed
in other modules or scripts.

If you've been attentive, you may have noticed that some of the functions that we've
defined in our Math module have keyword public before their definition.

Reader's note: Move's `public` vs. Rust's `pub`?
*/

/// If `sum()` hadn't been made public, this wouldn't be possible:

script {
    use 0x1::Math;

    fun main() {
        Math::sum(10, 100); // won't compile!
    }
}

/// Private functions can **only** be accessed in the module where they're defined.

/// Syntax rules for functions are similar, but not entirely, to Rust's:
/// 1. Arguments must have types and must be separated by comma (like Rust)
/// 2. Function return value is placed after parentheses and must follow a colon (unlike Rust)

module Math {
    fun zero(): u8 {
        0
    }

    /// So how do you access functions in the same module? By simply calling
    /// this function as if it had been imported!
    public fun is_zero(a: u8): bool {
        a == zero()
    }

    public fun sum(a: u64, b: u64): u64 {
        a + b
    }

    /// Returning tuples is allowed, which means they must be destructured upon
    /// calling this function.
    public fun max(a: u8, b: u8): (u8, bool) {
        if (a > b) {
            (a, false)
        } else if (a < b) {
            (b, false)
        } else {
            (a, true)
        }
    }
}

/*
IMPORTANT

Any function defined in a module is accessible by any other function in the same
module, no matter what visibility modifiers any of them has.

This way, private functions can still be used as calls inside public ones without
exposing private features or potentially risky operations.
*/

/// Native functions
/// 
/// There's a special kind of functions called native functions.
///
/// Native functions implement functionality which goes beyond Move's
/// possibilities, and give you extra power.
///
/// Native functions are defined by the VM itself and may vary in different
/// implementations.
///
/// ---
/// Reader's note: so Sui's VM may a different set of native functions than
/// Diem's, which would mean potential interoperability of contracts/libraries
/// between different chains is limited by their native compatibility?
/// ---
///
/// Which means they are not defined in Move, and their implementation is built
/// into the VM's runtime.
///
/// Instead of having function body they end with a semicolon.
/// The keyword `native` is used to mark native functions.
///
/// It does not conflict with function visibility modifiers and the same function can
/// be native and public at the same time.

/// Example from Diem
module Signer {

    native public fun borrow_address(s: &signer): &address;

    // ... some other functions ...
}