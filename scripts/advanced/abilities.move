/*
IMPORTANT

Abilities are a restricted version of Rust's traits, are built in, and come in 4
varieties:

1. Copy - value can be copied (or cloned by value).
2. Drop - value can be dropped by the end of scope.
3. Key - value can be used as a key for global storage operations.
4. Store - value can be stored inside global storage.

Primitive and built-in types' abilities are pre-defined and unchangeable:
integers, vector, addresses and boolean values have copy, drop and store
abilities

Reader's note:
Unlike in Rust, where `Drop` is defined by default for every type and it is up to
the programmer to override it, in Move it is unimplemented by default, and the onus
is upon the code's writer to add the marker `Drop` trait.

Q: How are types without `Drop` allowed?
A: "Drop ability only defines drop behavior. Destructuring does not require Drop."
*/


module Library {
    // each ability has matching keyword
    // multiple abilities are listed with comma
    struct Book has store, copy, drop {
        year: u64
    }

    // single ability is also possible
    struct Storage has key {
        books: vector<Book>
    }

    // this one has no abilities 
    struct Empty {}
}

module Country {
    struct Country {
        id: u8,
        population: u64
    }
    
    public fun new_country(id: u8, population: u64): Country {
        Country { id, population }
    }
}

script {
    use {{sender}}::Country;

    /// The below will fail because `Country` does not have the `Drop` ability.
    fun main() {
        Country::new_country(1, 1000000);
    }   
}