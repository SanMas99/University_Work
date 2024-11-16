import java.util.ArrayList;

public class Metal {
    private int mass;
    private double purity;
    public static enum type {GOLD, LEAD, TIN};
    private type t;
    private ArrayList<String> history;

    public static final double GOLD_PRICE = 48.75;
    public static final double TIN_PRICE = 0.03;
    public static final double LEAD_PRICE = 0.01;
    


    public Metal(int m, type t){
        this.mass=m;
        purity = 1;
        this.t=t;
        history= new ArrayList<String>();

    }
    void setMass(int m){
        mass=m; 
    }

    void setPurity(double f){
        purity = f;
    }

    double getPurity(){
        return purity;
    }

    int getMass(){
        return mass;
    }

    public type getType(){
        return this.t;
    }

    public ArrayList<String> getHistory() {
        return history;
    }
    public double value(){
        switch(t) {
            case GOLD: return purity * mass * GOLD_PRICE;
            case TIN: return purity * mass * TIN_PRICE;
            case LEAD: return purity * mass * LEAD_PRICE;
            default: throw new RuntimeException("Have not considered type: " + t);
        }

    }

    public String toString(){
        String metal;
        switch(t) {
            case GOLD: metal = "Gold"; break;
            case TIN: metal = "Tin"; break;
            case LEAD: metal = "Lead"; break;
            default: metal = "Unknown"; break;
        }

        return "Metal: " + metal + ", Mass: " + mass + " grams, Value: " + value();
    }

    public void mixWith(Metal m){
        history.add("Mixed with: " + m);

        if (t.equals(m.getType())) {
            mass += m.getMass();
        } else if (t.equals(type.TIN) && m.getType().equals(type.LEAD) || t.equals(type.LEAD) && m.getType().equals(type.TIN)) {
            t = type.GOLD;
            mass += m.getMass();
            return;
        } else if (t.equals(type.GOLD) && (m.getType().equals(type.LEAD) || m.getType().equals(type.TIN))) {
            double d = mass;
            mass += m.getMass();
            purity = d / (double)mass;
            if (purity < 0.5) {
                t = m.getType();
            }
        } else if ((t.equals(type.LEAD) || t.equals(type.TIN)) && m.getType().equals(type.GOLD)) {
            mass += m.getMass();
            purity = (double)m.getMass() / (double)mass;
            if (purity >= 0.5 ) {
                t = type.GOLD;
            } else {
                purity = 1 - purity;
            }
        }
    }

    public static void main(String[] args) {
        Metal m = new Metal(1000, type.GOLD);
        System.out.println(m);
        m.mixWith(m);
        System.out.println(m);

        Metal n = new Metal(50, type.LEAD);
        Metal p = new Metal(25, type.TIN);

        System.out.println(n);
        n.mixWith(p);
        System.out.println(n);

        m.mixWith(p);
        System.out.println(m);

        for (String s: m.getHistory()) {
            System.out.println(s);
        }
    }


}
