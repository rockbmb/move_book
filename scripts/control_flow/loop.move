script {
    fun main() {
        let i = 0;

        loop {
            i = i + 1;
        };

        // UNREACHABLE CODE
        let _ = i;
    }
}

script {
    fun main() {
        let i = 0;

        loop {
            if (i == 1) { // i never changes
                break // this statement would break the loop, but it never can/will
            }
        };

        // unreachable
        0x1::Debug::print<u8>(&i);
    }
}