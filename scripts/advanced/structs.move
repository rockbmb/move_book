/// Struct can have up to **4** abilities, they are specified with type definition.

/// example from 5.1
module M {
    // structs can be fieldless, like in Rust
    struct Empty {}

    struct MyStruct {
        field1: address,
        field2: bool,
        field3: Empty
    }

    struct Example {
        field1: u8,
        field2: address,
        field3: u64,
        field4: bool,
        field5: bool,

        // you can nest structs
        field6: MyStruct
    }
}

/*
IMPORTANT

1. Recursive structs are not allowed.
2. New instances can only be created inside the module where they're defined.
*/

/// Example of struct instantiation
module Country {
    struct Country {
        id: u8,
        population: u64
    }

    // Contry is the return type of this function!
    public fun new_country(c_id: u8, c_population: u64): Country {
        // structure creation is an expression
        let country = Country {
            id: c_id,
            population: c_population
        };

        country
    }

    /// Shorthand for struct instantiation, much like Rust's
    public fun new_country(id: u8, population: u64): Country {
        // id matches id: u8 field
        // population matches population field
        Country {
            id,
            population
        }

        // or even in one line: Country { id, population }
    }

    /// In order to access a struct's fields outside of its module,
    /// public getters must be provided
    public fun get_country_population(country: Country): u64 {
    country.population // <struct>.<property>
    }

    public fun destroy(country: Country) {

        // this way the struct is destroyed, without unused variables
        let Country { id: _, population: _ } = country;

        // taking only the id, and without allocating the `population` variable
        // let Country { id, population: _ } = country;
    }

    /// Instantiating empty structs:
    struct Empty {}
    public fun empty(): Empty {
        Empty {}
    }
}

/*
IMPORTANT

1. Only in the module where a struct is defined can its fields be accessed.
   Outside of the module, fields are private.
2. Destructuring works much the same way as it does in Rust
3. Max number of fields in one struct is 65535
4. Destructuring is important w.r.t. resources (chapter 6)
5. Because of 1., public getters and setters must be defined in the struct's
   module in order to have read/write access to the struct's fields

*/