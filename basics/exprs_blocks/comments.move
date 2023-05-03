script {
    fun main() {
        // this is a comment line
    }
}

script {
    // let's add a note to everything!
    fun main() {
        let a = 10;
        // let b = 10 this line is commented and won't be executed
        let b = 5; // here comment is placed after code
        a + b // result is 15, not 10!
    }
}

script {
    fun /* you can comment everywhere */ main() {
        /* here
           there
           everywhere */ let a = 10;
        let b = /* even here */ 10; /* and again */
        a + b
    }
    /* you can use it to remove certain expressions or definitions
    fun empty_commented_out() {

    }
    */
}