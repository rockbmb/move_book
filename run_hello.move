// modules/hello_world.move
/*
You can have as many modules as you want in your modules directory; all of them
will be accessible in your scripts under address which you've specified in
.mvconfig.json
*/

address 0x1 {
module HelloWorld {
    public fun gimme_five(): u8 {
        5
    }
}
}

// scripts/run_hello.move
script {
    use 0x1::HelloWorld;
    use 0x1::Debug;

    fun main() {
        let five = HelloWorld::gimme_five();

        Debug::print<u8>(&five);
    }
}