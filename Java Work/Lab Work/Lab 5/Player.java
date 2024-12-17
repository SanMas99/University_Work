
public class Player {

    public static final int LOSING_SCORE = -1;
    private int score;
    private boolean hold = false;
    private String name;
    private int wins;

    public Player(String name) {
        this.name = name;
    }

    public int getScore() {
        return score;
    }

    public boolean isHeld() {
        return hold;
    }

    public String getName() {
        return name;
    }

    public int getWins() {
        return wins;
    }

   public void addWin() {
        wins++;
   }

    public void setHold(boolean hold) {
        this.hold = hold;
    }

    public void addCard(int card) {
        score += card;
        Util.out(getName() + " drew a " + card);
        if (score == Game.WINNING_SCORE) {
            hold = true;
            Util.out(getName() + " scored " + Game.WINNING_SCORE + "!!");
        } else if (score > Game.WINNING_SCORE) {
            hold = true;
            score = Player.LOSING_SCORE;
            Util.out(getName() + " went bust");
        }
    }

    public String toString() {
        return "Player: " + getName() + " (wins: " + getWins() + ") current score: " + getScore();
    }

    public void reset() {
        score = 0;
        hold = false;
    }
}
