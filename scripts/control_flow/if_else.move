script {
    use 0x1::Debug;

    fun main() {

        // try switching to false
        let a = true;
        let b = if (a) { // 1st branch
            10
        } else { // 2nd branch
            20
        };

        Debug::print<u8>(&b);
    }
}