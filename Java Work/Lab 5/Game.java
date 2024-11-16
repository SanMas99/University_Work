import com.sun.jdi.ArrayReference;

import java.util.ArrayList;

public class Game {
    public static final int WINNING_SCORE = 21;
    private int noRounds;

    public static enum Command {HOLD, DRAW};
    private ArrayList<Player> players;

    public Game(int noPlayers, int noRounds) {
        players = new ArrayList<Player>();
        for (int i = 0; i < noPlayers; i++) {
            players.add(getPlayer());
        }
        this.noRounds = noRounds;
    }

    public void play() {

        int heldPlayers = 0;
        Command c;
        int highestScore = Player.LOSING_SCORE - 1;
        Player highestPlayer = null;
        boolean draw = false;

        for (int i = 0; i < noRounds; i++) {

            heldPlayers = 0;
            highestScore = Player.LOSING_SCORE - 1;
            highestPlayer = null;
            draw = false;

            for (Player player : players) {
                player.addCard(Util.getRandom(11));
                player.addCard(Util.getRandom(11));

                if (player.isHeld()) {
                    heldPlayers += 1;
                }
            }

            while (heldPlayers < players.size()) {
                heldPlayers = 0;

                for (Player player : players) {
                    if (!player.isHeld()) {
                        Util.out(player);
                        c = getCommand();

                        switch (c) {
                            case DRAW: player.addCard(Util.getRandom(11)); break;
                            case HOLD: player.setHold(true); break;
                            default: Util.out("Unknown Command: " + c);
                        }
                    }

                    if (player.isHeld()) {
                        heldPlayers += 1;
                    }
                }
            }

            for (Player player : players) {
                if (player.getScore() == highestScore) {
                    draw = true;
                } else if (player.getScore() > highestScore) {
                    highestScore = player.getScore();
                    highestPlayer = player;
                    draw = false;
                }
            }

            if (draw) {
                Util.out("It's a draw");
            } else {
                Util.out(highestPlayer.getName() + " wins with a score of " + highestPlayer.getScore());
                highestPlayer.addWin();
            }

            for (Player player : players) {
                player.reset();
            }
        }
    }

    private Command getCommand() {
        String s = Util.getInput("Would you like to DRAW another card, or HOLD your current score?");
        if (s.equalsIgnoreCase("draw")) {
            return Command.DRAW;
        } else if (s.equalsIgnoreCase("hold")) {
            return Command.HOLD;
        } else {
            throw new IllegalArgumentException("Invalid Command Entered: "  + s);
        }
    }

    private Player getPlayer() {
        return new Player(Util.getInput("Please enter your name: "));
    }

    public static void main(String[] args) {
        Game g = new Game(3, 2);
        g.play();
    }
}
