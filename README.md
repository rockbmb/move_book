# Sketchbook for the [Move book](https://move-book.com/index.html)

This repository contains some notes taken as I read through a resource on the [Move
language](https://diem-developers-components.netlify.app/papers/diem-move-a-language-with-programmable-resources/2020-05-26.pdf).

Since Diem has shut down and Move has since been adopted by other projects with their own variants
of the language, and tooling, the original tooling used to run the book's examples is no longer
working.

As such, none of the code follows the required "module/script" separation, and cannot be run.

The important parts are the notes and comments - e.g. those marked with `IMPORTANT` - left throughout.

## Important takeaways

From chapter 6.
1. The key feature of Move is the ability to define custom resource types. Resource types are used to
   encode safe digital assets with rich programmability.
2. Resources are ordinary values in the language. They can be stored as data structures, passed as
   arguments to procedures, returned from procedures, and so on.
   - Resources are a special type of structure, and it is thus possible to define and create new
     or existing resources in Move. Therefore, it is possible to manage digital assets the same way
     any other data is, like vectors or `struct`s.
3. The Move type system provides special safety guarantees for resources.
   - Move resources can never be duplicated, reused, or discarded.
   - A resource type can only be created or destroyed by the module that defines the type.
   - These guarantees are enforced statically by the Move virtual machine via bytecode
     verification.
   - The Move virtual machine will refuse to run code that has not passed through the bytecode
     verifier.
4. All Diem currencies are implemented using the generic Diem::T type.
   - For example: the LBR currency is represented as Diem::T<LBR::T> and a
     hypothetical USD currency would be represented as Diem::T<USD::T>.
   - Diem::T has no special status in the language; every Move resource enjoys the same
     protections.