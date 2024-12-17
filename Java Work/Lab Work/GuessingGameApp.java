import java.util.Random;
import java.util.Scanner;

// Event class
class Guess {
    private final int guess;
    private int noOfGuesses;

    public Guess(int guess) {
        this.guess = guess;
        this.noOfGuesses = 0;
    }

    public int getGuess() {
        return guess;
    }

    public int getNoOfGuesses() {
        return noOfGuesses;
    }
    public void incrementGuessCount() {
        this.noOfGuesses += 1 ;
    }
}

// Listener interface
interface GuessListener {
    void onGuess(Guess event);
}

// Game class
class NumberGuessingGame {
    private final int numberToGuess;
    private GuessListener listener;

    public NumberGuessingGame() {
        Random rand = new Random();
        this.numberToGuess = rand.nextInt(100) + 1; // Random number between 1 and 100
    }

    public void setListener(GuessListener listener) {
        this.listener = listener;
    }

    public void makeGuess(int guess) {
        if (listener != null) {
            listener.onGuess(new Guess(guess));
        }
    }

    public int getNumberToGuess() {
        return numberToGuess;
    }
}

// Main class
public class GuessingGameApp {
    public static void main(String[] args) {
        NumberGuessingGame game = new NumberGuessingGame();
        Scanner scanner = new Scanner(System.in);

        game.setListener(event -> {
            int guess = event.getGuess();
            int target = game.getNumberToGuess();

            if (guess < target) {
                System.out.println("Too low! Try again.");
                event.incrementGuessCount();
                System.out.println("Guesses: " + event.getNoOfGuesses());
            } else if (guess > target) {
                System.out.println("Too high! Try again.");
                event.incrementGuessCount();
            }
            else {
                System.out.println("Congratulations! You guessed the number.");
                System.exit(0); // End game
            }
            if (event.getNoOfGuesses()>=5){
                System.out.println("Too many tries! The answer was " + game.getNumberToGuess() );
                System.exit(0);
            }
        });

        System.out.println("Guess the number between 1 and 100:");
        while (true) {
            int guess = scanner.nextInt();
            game.makeGuess(guess);
        }
    }
}
