/*
IMPORTANT

You can define module or script-level constants. Once defined, constants cannot
be changed, and they should be used to define some constant value for A specific
module (say, a role identifier or price for action) or script.

1. Constants can be defined as primitive types (integers, bool and address) and as a vector.
2. They are accessed by their names and are local to script/module where they are defined.
3. Accessing constant value from outside of its module is **impossible**
*/

script {
    use 0x1::Debug;

    const RECEIVER : address = 0x999;

    fun main(account: &signer) {
        Debug::print<address>(&RECEIVER);

        // they can also be assigned to a variable
        let _ = RECEIVER;

        // but this code would lead to a compilation error; can't reassign
        // RECEIVER = 0x800;
    }
}

module M {
    const MAX : u64 = 100;
    // constants can, however, be passed outside the script/module where they're defined,
    // using a function
    public fun get_max(): u64 {
        MAX
    }

    // or using the result on an operator on that constant
    public fun is_max(num: u64): bool {
        num == MAX
    }
}

/*
IMPORTANT

1. They are immutable;
2. They are local to their module or script, and cannot be used directly outside it;
3. They are often used to define a module-level constant value which serves some business purpose;
4. It is also possible to define a constant as an expression (with curly braces) but syntax of this
   expression is very limited (reader's note: unsure to what this may be referring to)
*/