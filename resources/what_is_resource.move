/*
IMPORTANT

About resources in Move:
* Originally, resources were their own type;
* later, with the addition of abilities, that type was replaced with two
  abilities: Key and Store.
  - A resource is meant to be allow the storage of digital assets;
  - to achieve that it must to be non-copyable and non-droppable.
  - At the same time it must be storable and transferable between accounts.
* Resources are stored under an account
  - therefore they exist only when assigned to an account, and
  - can only be accessed through this account
* An account can hold only **one** resource of **one** type, and
  - this resource must have the key ability
* A resource can't be copied nor dropped, but it can be stored.
* A resource value must be used.
  - When a resource is created or taken from account, it cannot be dropped and must
    be stored or destructured.
*/

/// A resource is a struct that only has the key and store abilities
module M {
    struct T has key, store {
        field: u8
    }
}

/*
Key and store abilities

* key
  - Allows the type to serve as a key for global storage operations.
* store
  - Allows values of types with this ability to exist inside a struct in global storage.
*/


