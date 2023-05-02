script {
    fun scope_sample() {
        // this is a function scope
        {
            // this is a block scope inside function scope
            {
                // and this is a scope inside scope
                // inside functions scope... etc
            };
        };

        {
            // this is another block inside function scope
        };
    }
}