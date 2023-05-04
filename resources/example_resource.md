# Notes from chapters 6.1, 6.2 and 6.3

## Creating and moving a resource

```rust
// modules/Collection.move
module Collection {
    use 0x1::Vector;

    struct Item has store {}

    struct Collection has key {
        items: vector<Item>
    }

    // note that &signer is passed here
    public fun start_collection(account: &signer) {
        move_to<Collection>(account, Collection {
            items: Vector::empty<Item>()
        })
    }

    // Writing a function to check if a certain resource exists at an address
    public fun exists_at(at: address): bool {
        exists<Collection>(at)
    }
}
```
---

To move a resource to an account, there exists the built-in function `move_to`,
which takes `signer` as its first argument, and our `Collection` as its second.

The signature of `move_to` is:

```
native fun move_to<T: key>(account: &signer, value: T);
```

From this signature, it follows that :

* A resource can only be moved to account of the operation's executor
  - Each account can only have access to the signer value of itself, and never of
    another account; hence, it cannot put resources elsewhere.
* Only one resource, of a single type, can be stored under one address.
  - Doing the same operation twice would lead to the discarding of the existing
    resource, and this must not happen:
      * imagine an account has coins stored in it, and by mistake, they are
        discarded by pushing an empty balance
      * The attempt to create an existing resource will fail with an error.
  - Note also that because resources do not have the `drop` ability,
    they are never silently dropped when overwritten, which is another safety
    measure; read more in https://diem.github.io/move/abilities.html#drop

### Querying a resource

To check if resource exists at given address Move has exists function, which
signature looks similar to this.

```rust
native fun exists<T: key>(addr: address): bool;
```

## Reading and modifying a resource

### Reading with `borrow_global`

```rust
// modules/Collection.move
module Collection {

    // new dependency here!
    use 0x1::Signer;
    use 0x1::Vector;

    struct Item has store, drop {}
    struct Collection has key, store {
        items: vector<Item>
    }

    // ... skipped ...

    /// get the collection's size
    /// note the `acquires` keyword!
    public fun size(account: &signer): u64 acquires Collection {
        let owner = Signer::address_of(account);
        let collection = borrow_global<Collection>(owner);

        Vector::length(&collection.items)
    }
}
```

`borrow_global` provides an immutable reference to a resource `T`, and has signature

```rust
native fun borrow_global<T: key>(addr: address): &T;
```

* This function provides **read** access to a resource stored at a specific
  address.
  - This means that a module has the ability to read any of its resources at
    any addresses (if this functionality is implemented).
* Due to borrow checking, references to resources or its contents cannot be returned
  - this is because the original reference to the resource will be dropped at the end of
    its scope
  - This, combined with resources not being permitted to have `copy`, means they
    cannot be dereferenced with `*&`

---
#### `acquire` keyword

* Must be put after a function's return value
* It explicitly defines all the resources acquired by this function
* Every used resource must be specified
  - even if it's a nested function call which actually acquires a resource,
    its parent scope must specified it in its in acquires list.
* syntax:
  ```rust
  fun <name>(<args...>): <ret_type> acquires T, T1 ... { ... }
  ```
---

### Writing with `borrow_global_mut`

```rust
module Collection {
    // ... skipped ...

    public fun add_item(account: &signer) acquires Collection {
        let collection = borrow_global_mut<Collection>(Signer::address_of(account));

        Vector::push_back(&mut collection.items, Item {});
    }
}
```

Signature of `borrow_global_mut`:
```rust
native fun borrow_global_mut<T: key>(addr: address): &mut T;
```

## Taking and destroying a resource

```rust
// modules/Collection.move
module Collection {

    // ... skipped ...

    public fun destroy(account: &signer) acquires Collection {

        // account no longer has the resource attached
        let collection = move_from<Collection>(Signer::address_of(account));

        // now we must use resource value - we'll destructure it
        // `struct Item has drop`, so `vector<Item> has drop`, and
        // `items` below is safely dropped
        let Collection { items: _ } = collection;

        // done. resource destroyed
    }
}
```

Reader's notes:
1. Since resources cannot have `drop`, that ensures they *must* be handled properly
  - either being destructured and having their inner parts dropped, or
  - moved to another owner via `move_to`, seen above

Either way, this ensures a resource is always used, either transacted between owners,
or disposed of, if its inner components implement `drop`.

This hints that resources relative to currencies and amounts must not have all their
inner fields implement `drop`, so that they can never be dropped, and thus only transferred.

Signature for `move_from`:

```rust
native fun move_from<T: key>(addr: address): T;
```