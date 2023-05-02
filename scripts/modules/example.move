/*
IMPORTANT

1. A module is published under its sender's address. The standard library is published
   under the 0x1 address.
2. When publishing a module, none of its functions are executed. To use a module, 
   use scripts.
3. Modules are the only way to publish code accessible for others; new types and
   resources, too, can only be defined within module context.
*/

module Math {

    // module contents

    public fun sum(a: u64, b: u64): u64 {
        a + b
    }
}

/// By default your module will be compiled and published from your address.
///
/// However, if you need to use some modules locally (e.g. for testing or developing),
/// or want to specify your address inside the module's file, use the syntax
///
/// `address <ADDR> {}`
///
address 0x1 {
module Math {
    // module contents

    public fun sum(a: u64, b: u64): u64 {
        a + b
    }
}
}