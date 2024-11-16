import javax.script.ScriptContext;
import java.util.Random;
import java.util.Scanner;

public class Util {

    private static Random rand;
    private static Scanner in;

    public static int getRandom(int i) {
        if (rand == null) {
            rand = new Random();
        }

        return rand.nextInt(11) + 1;
    }

    public static void out(Object obj) {
        System.out.println(obj);
    }

    public static String getInput(String s) {
        if (in == null) {
            in = new Scanner(System.in);
        }

        out(s);
        return in.nextLine();
    }
}
