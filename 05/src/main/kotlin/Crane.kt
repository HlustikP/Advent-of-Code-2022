public object Crane {
    // Move the top Crate amount times
    fun moveCrate(amount: Int, from: CrateStack, to: CrateStack) {
        // loop amount times
        for(i in 1..amount) {
            to.addCrate(from.popCrate());
        }
    }
    // Move the top amount Crates, retining their order
    fun moveCrates(amount: Int, from: CrateStack, to: CrateStack) {
        val crateDepot = CrateStack();
        moveCrate(amount, from, crateDepot);
        moveCrate(amount, crateDepot, to);
    }
}
