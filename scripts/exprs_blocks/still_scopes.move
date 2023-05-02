// Last expression in scope (without semicolon) is the return value of this scope.

script {
    fun block_ret_sample() {

        // since a block is an expression, we can
        // assign its value to a variable with let
        let a = {

            let c = 10;

            c * 1000  // no semicolon!
        }; // scope ended, variable a has value 10000

        let b = {
            a * 1000  // no semicolon!
        };

        // variable b has value 10000000

        {
            10; // semicolon!
        }; // this block does not return a value

        let _ = a + b; // both a and b get their values from blocks
    }
}