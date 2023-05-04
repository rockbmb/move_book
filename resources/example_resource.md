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