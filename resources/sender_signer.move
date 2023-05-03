/*
IMPORTANT

* Signer is a native non-copyable (resource-like) type which holds address of
  transaction sender.
* Signer type has only one ability - Drop.
* Signer is a native non-copyable (resource-like) type which holds the address of a
  transaction's sender.
*/

/// Unlike `vector` - another native type - it cannot be directly created in code, but can
/// be received as a script argument

script {
    // signer is an owned value
    fun main(account: signer) {
        let _ = account;
    }
}

/*
More important notes:

* A `signer` argument is put into scripts automatically by the VM, which means that
  there's no way nor need to pass it into script manually.
* Futher - it's always a reference.
  - Even though the standard library (in case of Diem it's - DiemAccount) has access to
    actual value of signer, functions using this value are private and there's no way
    to use or pass signer value anywhere else.
* `account` is the canonical name of the variable holding the signer
*/

/// Native types require native functions, and for the `signer type`, it is 0x1::Signer.
module Signer {
    // Borrows the address of the signer
    // Conceptually, you can think of the `signer`
    // as being a resource struct wrapper arround an address
    // ```
    // resource struct Signer { addr: address }
    // ```
    // `borrow_address` borrows this inner field
    native public fun borrow_address(s: &signer): &address;

    // Copies the address of the signer
    public fun address_of(s: &signer): address {
        *borrow_address(s)
    }
}

/// Usage of this module in a script
script {
    fun main(account: signer) {
        let _ : address = 0x1::Signer::address_of(&account);
    }
}

/// In a module:
module M {
    use 0x1::Signer;

    // proxy of `Signer::address_of`
    public fun get_address(account: signer): address {
        Signer::address_of(&account)
    }
}

/*
Note:

* Methods using the `&signer` type as an argument explicitly show they are using
  the sender's address.
* This type helps show which methods require sender authority, and which don't.
* So a method must be transparent to the user about unauthorized access to its
  resources.
*/