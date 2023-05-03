module Storage {
    struct Box<T> {
        value: T
    }

    // type u64 is put into angle brackets meaning
    // that we're using Box with type u64
    public fun create_box(value: u64): Box<u64> {
        Box<u64>{ value }
    }

    public fun create_box<T>(value: T): Box<T> {
        Box<T> { value }
    }

    // we'll get to this a bit later, trust me
    public fun value<T: copy>(box: &Box<T>): T {
        *&box.value
    }
}

/// Using the above module
script {
    use {{sender}}::Storage;
    use 0x1::Debug;

    fun main() {
        // this value will be of type Storage::Box<bool>
        let bool_box = Storage::create_box<bool>(true);
        let bool_val = Storage::value(&bool_box);

        assert(bool_val, 0);

        // same can be done with integers
        let u64_box = Storage::create_box<u64>(1000000);
        let _ = Storage::value(&u64_box);

        // let's do the same with another box!
        let u64_box_in_box = Storage::create_box<Storage::Box<u64>>(u64_box);

        // accessing value of this box in box will be tricky :)
        // Box<u64> is a type and Box<Box<u64>> is also a type
        let value: u64 = Storage::value<u64>(
            // type of `Storage::value<u64>`'s argument: &Box<u64>
            &Storage::value<Storage::Box<u64>>(
                // type: &Box<Box<u64>>
                &u64_box_in_box
            )
        );

        // you've already seen Debug::print<T> method
        // which also uses generics to print any type
        Debug::print<u64>(&value);
    }
}

/// Abilities as constraints

/*
functions:
fun name<T: copy>() {} // allow only values that can be copied
fun name<T: copy + drop>() {} // values can be copied and dropped
fun name<T: key + store + drop + copy>() {} // all 4 abilities must be present

structs:
struct name<T: copy + drop> { value: T } // T can be copied and dropped
struct name<T: store> { value: T } // T can be stored in global storage
*/

/// Everything put together
module Storage {
    // the contents of the box can be stored
    struct Box<T: store> has key, store {
        content: T
    }
}
/*
IMPORTANT

About generics in Move
1. generics can be applied to signatures of structs and functions.
2. angle brackets `::<T>` is similar to Rust's
3. inner types (or generic types) MUST have the abilities of their container (for all abilities except key).
    * It is arguably logical and intuitive: a struct with the copy ability must have
    contents that also have copy ability, otherwise the container object cannot be considered
    copyable.
4. Container abilities are automatically limited by their contents'
   * for example, in a container struct with `copy + drop + store`, with
     an inner struct possessing only `drop`, it will be impossible to copy or store
     this container.
*/

/// The below, when used, will cause an error
module Storage {
    // non-copyable or droppable struct
    struct Error {}
    
    // constraints are not specified
    struct Box<T> has copy, drop {
        contents: T
    }

    // this method creates box with non-copyable or droppable contents
    public fun create_box(): Box<Error> {
        Box { contents: Error {} }
    }
}

/// See point 3. above
script {
    fun main() {
        {{sender}}::Storage::create_box() // value is created and dropped
                 // ^^^^^^^^^^^^^^^^^^^^^ Cannot ignore values without the 'drop' ability. The value must be used
    }
}