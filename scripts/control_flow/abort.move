script {
    fun main(a: u8) {

        if (a != 10) {
            abort 0;
        }

        // code here won't be executed if a != 10
        // transaction aborted
    }
}

// Built-in assert!(<bool expression>, <code>) method wraps abort + condition
// and is accessible from anywhere:
script {

    fun main(a: u8) {
        assert!(a == 10, 0);

        // code here will be executed if (a == 10)
    }
}