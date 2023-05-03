/*
IMPORTANT

1. Vector is a built-in type for storing collections of data.
2. It is a generic solution for a generic collection (only one type per instance).
3. Its functionality is provided by the VM, so the only way to work with it is by using
   the Move standard library and native functions.
4. Vectors can store up to `u64::MAX` values
*/

/// Example usage
script {
    use 0x1::Vector;

    fun main() {
        // use generics to create an emtpy vector
        let a = Vector::empty<u8>();
        let i = 0;

        // fill it with data
        while (i < 10) {
            Vector::push_back(&mut a, i);
            i = i + 1;
        };

        // print vector length
        let a_len = Vector::length(&a);
        0x1::Debug::print<u64>(&a_len);

        // then remove 2 elements from it
        Vector::pop_back(&mut a);
        Vector::pop_back(&mut a);

        // and print its length again
        let a_len = Vector::length(&a);
        0x1::Debug::print<u64>(&a_len);
    }
}

/// 
module Shelf {

    use 0x1::Vector;

    struct Box<T> {
        value: T
    }

    struct Shelf<T> {
        boxes: vector<Box<T>>
    }

    public fun create_box<T>(value: T): Box<T> {
        Box { value }
    }

    // this method will be inaccessible for non-copyable contents
    public fun value<T: copy>(box: &Box<T>): T {
        *&box.value
    }

    public fun create<T>(): Shelf<T> {
        Shelf {
            boxes: Vector::empty<Box<T>>()
        }
    }

    // box value is moved to the vector
    public fun put<T>(shelf: &mut Shelf<T>, box: Box<T>) {
        Vector::push_back<Box<T>>(&mut shelf.boxes, box);
    }

    public fun remove<T>(shelf: &mut Shelf<T>): Box<T> {
        Vector::pop_back<Box<T>>(&mut shelf.boxes)
    }

    public fun size<T>(shelf: &Shelf<T>): u64 {
        Vector::length<Box<T>>(&shelf.boxes)
    }
}

/// Usage of the above
script {
    use {{sender}}::Shelf;

    fun main() {
        // create shelf and 2 boxes of type u64
        let shelf = Shelf::create<u64>();
        let box_1 = Shelf::create_box<u64>(99);
        let box_2 = Shelf::create_box<u64>(999);

        // put both boxes in the shelf
        Shelf::put(&mut shelf, box_1);
        Shelf::put(&mut shelf, box_2);

        // prints size - 2
        0x1::Debug::print<u64>(&Shelf::size<u64>(&shelf));

        // then take one from shelf (last one pushed)
        // Notice how `shelf` is not declared as `mut`, but a mutable reference
        // to it can be taken.
        let take_back = Shelf::remove(&mut shelf);
        let value     = Shelf::value<u64>(&take_back);

        // verify that the box we took back is one with 999
        assert(value == 999, 1);

        // and print size again - 1
        0x1::Debug::print<u64>(&Shelf::size<u64>(&shelf));
    }
}