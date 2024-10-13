import java.util.ArrayList;

public class CashRegister {
    
    private double money;
    private ArrayList<String> transaction;

    public CashRegister(double d){
        if (d<0) {
			throw new IllegalArgumentException("Must be positive");
		}
        money=d;
        transaction = new ArrayList<String>();
    }


    public double totalMoney(){
        return money;
    }

    public void mutator(double d){
        money=d;
    }

    public void add(double d){
        money+=d;
        transaction.add(money + " add, new balance: " + money);
    }

    public void remove(double d){
        money-=d;
        transaction.add(money + " removed, new balance: " + money);
    }

    public String toString(){
        return ("Total Cash in Register is: "+ money);
    }

    public boolean equals( CashRegister a, CashRegister b){
        if (a.totalMoney()==b.totalMoney()){
            return true;
        } else{
            return false;
        }
    }

    public void printTransactions(int n){
        int len=transaction.size();
        if (len<n){
            for (int i = 0; i < len; i++) {
                System.out.println("List of transactions: "+ transaction); 
            }
            
        }else{
            System.out.println("Latest transactions: ");
            for (int i = n-1; i >= 0; i--) {
                System.out.println(transaction.get(i));
            }
        }
    }


    public static void main(String[] args) {
        CashRegister cr = new CashRegister(100);
        System.out.println(cr);

        cr.add(5);
        System.out.println(cr);
        cr.remove(15);
        System.out.println(cr);

        cr.mutator(50);
        System.out.println(cr);

        CashRegister cr1 = new CashRegister(50);
        System.out.println(cr.equals(cr));
        System.out.println(cr1.equals(cr));

        cr.mutator(75);
        System.out.println(cr.equals(cr1));

        cr.printTransactions(2);
        System.out.println("\n\n\n");
        System.out.println("End! nice");
        cr.add(5);
        cr.add(125);
        cr.remove(25);
        cr.add(55);
        cr.add(4);

        cr.printTransactions(5);

        System.out.println("\n\n\n");
        cr.printTransactions(3);
    }
}

