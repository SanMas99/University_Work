import javax.swing.JOptionPane;

public class Hello {
    public static void main(String[] args) {
        int n = 3;
        String name = JOptionPane.showInputDialog(null, "Enter your name:");
        for (int i = 0; i < n; i++) {
            JOptionPane.showMessageDialog(null, "Test " + i + " " + name);
        }
    }
}
