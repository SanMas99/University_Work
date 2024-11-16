public class Card {
    private final int suit;
    private final int value;

    public Card(int value, int suit) {
        this.value = value;
        this.suit = suit;
    }

    public int getValue() {
        if (value >= 1 && value <= 10) {
            return value;
        } else {
            return 10;
        }
    }

    private String getStringValue() {
        if (value >= 1 && value <= 10) {
            return Integer.toString(value);
        } else if (value == 11) {
            return "Jack";
        } else if (value == 12) {
            return "Queen";
        } else if (value == 13){
            return "King";
        } else {
            return "Invalid Card: " + value;
        }
    }

    private String getSuit() {
        switch(suit) {
            case 0: return "Clubs";
            case 1: return "Hearts";
            case 2: return "Spades";
            case 3: return "Diamonds";
            default: return "Unknown";
        }
    }

    public String toString() {
        return "Card: " + getStringValue() + " of " + getSuit();
    }
}
