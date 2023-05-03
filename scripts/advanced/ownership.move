/*
IMPORTANT

Ownership in Move is not too dissimilar from Rust's:
> Each variable only has one owner in any give scope.
> When the owner's scope ends, the owned values are dropped.

Variables can either be
1. defined in this scope (e.g. with keyword let), or
2. be passed into the scope as arguments.

Since in Move scopes are only permitted in functions, there are no other ways
to bring variables into scope.

Each variable only has one owner, which means that when a variable is passed into a function
as an argument:
3. this function becomes the new owner, and
4. the variable is no **longer owned** by the first function.

Reader's note: which means only functions can be responsible for dropping values.
*/

/// Example of ownership in a script's function
script {
    use {{sender}}::M;

    fun main() {
        // Module::T is a struct
        let a : Module::T = Module::create(10);

        // here, the variable `a` leaves scope of `main` function
        // and is put into the scope of function `M::value`
        M::value(a);

        // variable a no longer exists in main's scope, so
        // this code won't compile
// ---> M::value(a); <---
    }
}

/// Inside `M::Value`
module M {
    struct T { value: u8 }

    public fun create(value: u8): T {
        T { value }
    }

    // the variable `t` of type M::T is passed into the
    // `value()` function, which takes ownership of it
    public fun value(t: T): u8 {
        // --->
        // t can be used as a variable
        t.value
        // <---
        // function scope ends, t dropped, only u8 result returned
        // t no longer exists
    }
    
}

/// Move and Copy abilities

/*
IMPORTANT

Quick note about Move VM:
There exist two bytecode instructions in Move's VM relevant to this discussion:
1. `MoveLoc`, and
2. `CopyLoc`

Both of them can be manually used with the keywords `move` and `copy`, respectively.
*/

/// Knowing that a value will be moved, the keyword `move` doesn't need to be
/// explicitly used, but it can be:
script {
    use {{sender}}::M;

    fun main() {
        let a : Module::T = Module::create(10);
        M::value(move a); // variable a is moved
        // local a is dropped
    }
}

/// If you need to pass a value to a function (to which it will be moved), and
/// save a copy of your variable, use the copy keyword.
script {
    use {{sender}}::M;

    fun main() {
        let a : Module::T = Module::create(10);
        // `copy` used to clone the structure
        // could also be `let a_copy = copy a`
        M::value(copy a);
        M::value(a); // won't fail, a is still here
    }
}

/// References

/*
Reader's note:

1. References behave much like in Rust: marked with an ampersand `&`, they allow you to
   refer to a value without taking ownership of it.
2. Move supports two types of references: immutable - defined with & (e.g. &T)
   and mutable - &mut (e.g. &mut T).
*/

/// Module of previous example, but with a reference
module M {
    struct T { value: u8 }
    // ...
    // ...
    // instead of passing a value, we'll pass a reference
    public fun value(t: &T): u8 {
        t.value
    }
}

/// Same module M, but with examples of reference usage
module M {
    struct T { value: u8 }

    // variable returned by value here, and neither by reference not
    // mutable reference.
    public fun create(value: u8): T {
        T { value }
    }

    // immutable references have read permission on the variable
    public fun value(t: &T): u8 {
        t.value
    }

    // mutable references allow both reading and changing the variable
    public fun change(t: &mut T, value: u8) {
        t.value = value;
    }
}

/// Using the above module:
script {
    use {{sender}}::M;
    fun main() {
        let t = M::create(10);

        // create a reference directly
        M::change(&mut t, 20);
        // or write reference to a variable
        let mut_ref_t = &mut t;

        M::change(mut_ref_t, 100);

        // same with immutable ref
        let value = M::value(&t);
        // this method also takes only references
        // printed value will be 100
        0x1::Debug::print<u8>(&value);
    }
}

/*
IMPORTANT
Same as in Rust:
* Use immutable (&) references to read data from structs;
* use mutable refs (&mut) to modify them

By using proper type of references you help maintain security,
and simplify your modules, so their reader will know whether a method
needs write permissions on a variable, or only reading permission.

*/

/// Borrow checking example!

module Borrow {
    struct B { value: u64 }
    struct A { b: B }

    // create A with inner B
    public fun create(value: u64): A {
        A { b: B { value } }
    }

    // given a mutable reference to an `A`, return a mutable reference to
    // its inner `B`
    public fun ref_from_mut_a(a: &mut A): &mut B {
        &mut a.b
    }

    // change B
    public fun change_b(b: &mut B, value: u64) {
        b.value = value;
    }
}

/// Usage of the module above
script {
    use {{sender}}::Borrow;

    fun main() {
        // create a struct A { b: B { value: u64 } }
        let a = Borrow::create(0);

        // get mutable reference to B from mut A
        let mut_a = &mut a;
        // Reader's note - I have a suspicion that the below will not work,
        // as there will coexist a mutable reference to an `A`, and another
        // to that `A`'s inner `B`, in the same scope.
        // Sadly, there is no way to try this in this version of Move.
        /// In Sui's, I'll rerun this.
        // --->
        let mut_b = Borrow::ref_from_mut_a(mut_a);
        // <---
        // change B
        Borrow::change_b(mut_b, 100000);
        // get another mutable reference from A
        let _ = Borrow::ref_from_mut_a(mut_a);

        // In any case, if the last two expressions are swapped,
        // it'll fail to compile in Move
        let mut_a = &mut a;
        let mut_b = Borrow::ref_from_mut_a(mut_a);
        // --->
        let _ = Borrow::ref_from_mut_a(mut_a);
        // At this point, there would exist two mutable references to the `B`
        // of a single `A`, which cannot be.
        Borrow::change_b(mut_b, 100000);
        // <---
    }
}

/*
IMPORTANT

Takeaways:
1. Move has a borrow checker, much like Rust's; its compiler builds a variable/reference
   borrowing graph, and disallows moving of borrowed values.
2. References can be created from references, in such a manner that the original reference
   will be borrowed by the new one.
   Mutable and immutable refs can only be created from a mutable ref, and from an immutable ref,
   only another immutable ref can be created.
   * This is similar to the exclusion principles of concurrency e.g. multiple readers in a critical
     section, or a single writer, etc.
3. When a reference is borrowed, it cannot be moved because other values depend on it.
*/

/// About dereferencing in Move

/*
IMPORTANT

* When dereferencing, you're making a copy. Make sure that the value has the Copy ability.
* **UNLIKE** in Rust, the `*` dereference operator does not move the original value
  into the current scope. It creates a copy of the value instead.
* The `*&` operation can be used to copy a struct's inner field, see example below
*/

module M {
    struct H has copy {}
    struct T { inner: H }

    // ...

    // it can be done from an immutable reference!
    public fun copy_inner(t: &T): H {
        *&t.inner
    }
}

/// About primitive types

/*
IMPORTANT
* Due to their simplicity, primitive types do not need to be passed as references,
  and the copy operation is done by default instead.
* If passed into a function by value, they will remain in the current scope.
  the `move` keyword can be intentionally used, but since primitives are very small in size,
  copying them may even be cheaper than passing them by reference or even moving.
*/

script {
    use {{sender}}::M;

    fun main() {
        let a = 10;
        // Adding copy is unnecessary - the VM does so in later
        // stages of compilation
        M::do_smth(a);
        let _ = a;
    }
}