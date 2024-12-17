public class PackOfCards {

    private Card[] cards;
    private int drawn;

    public PackOfCards() {
        cards = new Card[52];
        int counter = 0;

        for (int i = 0; i < 4; i++) {
            for (int j = 0; j < 13; j++) {
                cards[counter++] = new Card(j+1, i);
            }
        }
    }

    public Card drawCard() {
        if (drawn == 52) {
            shuffle();
        }

        return cards[drawn++];
    }

    public void shuffle() {
        Card temp;
        drawn = 0;
        int j, k;
        for (int i = 0; i < 1000; i++) {
            j = Util.getRandom(52) - 1;
            k = Util.getRandom(52) - 1;

            //System.out.println("j:" + j + " k: " + k);

            if (j != k) {
                temp = cards[j];
                cards[j] = cards[k];
                cards[k] = temp;
            }
        }
    }

    public static void main(String[] args) {
        PackOfCards p = new PackOfCards();
        for (Card c : p.cards) {
            System.out.println(c);
        }

        p.shuffle();
        for (Card c : p.cards) {
            System.out.println(c);
        }
    }

}
