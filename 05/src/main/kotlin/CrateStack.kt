public class CrateStack {
    val stack: ArrayList<Crate> = ArrayList();
    fun addCrate(crate: Crate) {
        stack.add(crate);
    }
    fun popCrate(): Crate {
        return stack.removeLast();
    }
    fun print() {
        for (crate in stack) {
            print(crate.label);
        }
    }
    fun reverse() {
        stack.reverse();
    }
}
