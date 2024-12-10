import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

public class Calculator {
    private JFrame frame;
    private JTextField display;
    private JPanel panel;
    private double num1 = 0, num2 = 0, result = 0;
    private char operator;

    public Calculator() {
        // Initialize the frame
        frame = new JFrame("Simple Calculator");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setSize(400, 500);
        frame.setLayout(new BorderLayout());

        // Display field
        display = new JTextField();
        display.setFont(new Font("Arial", Font.BOLD, 24));
        display.setEditable(false);
        frame.add(display, BorderLayout.NORTH);

        // Panel for buttons
        panel = new JPanel();
        panel.setLayout(new GridLayout(4, 4, 10, 10));

        // Button labels
        String[] buttons = {
                "7", "8", "9", "/",
                "4", "5", "6", "*",
                "1", "2", "3", "-",
                "C", "0", "=", "+"
        };

        // Add buttons to the panel
        for (String label : buttons) {
            JButton button = new JButton(label);
            button.setFont(new Font("Arial", Font.BOLD, 20));
            panel.add(button);
            button.addActionListener(new ButtonClickListener());
        }

        frame.add(panel, BorderLayout.CENTER);
        frame.setVisible(true);
    }

    // Event handling for button clicks
    private class ButtonClickListener implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            String command = ((JButton) e.getSource()).getText();

            switch (command) {
                case "C": // Clear the display
                    display.setText("");
                    num1 = num2 = result = 0;
                    operator = '\0';
                    break;

                case "=": // Perform calculation
                    try {
                        num2 = Double.parseDouble(display.getText());
                        result = calculate(num1, num2, operator);
                        display.setText(String.valueOf(result));
                    } catch (NumberFormatException ex) {
                        display.setText("Error");
                    }
                    break;

                case "+": case "-": case "*": case "/":
                    try {
                        num1 = Double.parseDouble(display.getText());
                        operator = command.charAt(0);
                        display.setText(""); // Clear display for next input
                    } catch (NumberFormatException ex) {
                        display.setText("Error");
                    }
                    break;

                default: // Append number to the display
                    display.setText(display.getText() + command);
                    break;
            }
        }
    }

    // Calculation logic
    public double calculate(double num1, double num2, char operator) {
        switch (operator) {
            case '+': return num1 + num2;
            case '-': return num1 - num2;
            case '*': return num1 * num2;
            case '/':
                if (num2 == 0) {
                    JOptionPane.showMessageDialog(frame, "Cannot divide by zero!", "Error", JOptionPane.ERROR_MESSAGE);
                    return 0;
                }
                return num1 / num2;
            default: return 0;
        }
    }

    public static void main(String[] args) {
        new Calculator();
    }
}
