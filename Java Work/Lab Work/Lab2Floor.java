
public class Lab2Floor {

    private int[] count;

    public Lab2Floor(){
        count = new int[5];
    } 

    enum tile {x,o,Divider,Plus,Minus};

    private void printTile(tile t){
        switch (t){
        case x:
            System.out.print("x");
        
        case o:
            System.out.print("o");
        
        case Divider:
            System.out.print("|");
        
        case Minus:
        System.out.print("-");

        case Plus:
        System.out.print("+");
        }
    }

    public void draw(int x, int y, int d){
        for (int i = 0; i < y; i++) {

            for (int j = 0; j < x; j++) {
                if(i%d==0 && j%d==0){
                    System.out.print("+");
                    count[4]++;
                } 
                
                else if (j%d==0) {
                    System.out.print("|");
                    count[2]++;
                }


                else if (i%d==0){
                    System.out.print("-"); 
                    count[3]++;
                }


                else if((i+j)%2==1){
                    System.out.print("o");
                    count[1]++;
                } else{
                    System.out.print("x"); 
                    count[0]++;
                }
            } 
            System.out.println();          
            }
            
        }

        public void cost(){
            int total_count=0;
            double total_cost=0.00;
            String [] tiles= {"x","o","|","-","+"};
            for (int i = 0; i < 5; i++) {
                System.out.println("No " + tiles[i] + ": \t" + count[i] +"\tCost\t"+count[i]*(i+1));
                total_count+=count[i];
                total_cost+=count[i]*(i+1);

            }

            total_cost+=total_count;
            total_cost*=1.23;
            System.out.println("No of tiles:\t" + total_count + "\tCost\t" + total_cost);


        }

        public static void main(String [] args) {
            Lab2Floor l = new Lab2Floor();
            l.draw(16, 16, 5);
            l.cost();
            //or
            //l.draw(5, 3);
            //if you haven’t added the last param to the draw method yet
            }
    }

