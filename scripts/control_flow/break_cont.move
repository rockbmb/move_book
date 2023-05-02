script {
    fun main() {
        let i = 0;

        loop {
            i = i + 1;

            if (i / 2 == 0) continue;
            if (i == 5) break;

            // assume we do something here
         };

        0x1::Debug::print<u8>(&i);
    }
}

script {
    fun main() {
        let i = 0;

        loop {
            i = i + 1;

            if (i == 5) {
                break; // will result in compiler error. correct is `break` without semi
                       // Error: Unreachable code
            };

            // same with continue here: no semi, never;
            if (true) {
                continue
            };

            // however you can put semi like this, because continue and break here
            // are single expressions, hence they "end their own scope"
            if (true) continue;
            if (i == 5) break;
        }
    }
}