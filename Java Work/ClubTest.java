import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;

import java.util.LinkedList;
import java.util.Queue;
import static org.junit.jupiter.api.Assertions.*;

//Sanad Masannat 24217734

//As we use this class often, we will test the constructors and getters here and make sure they work as intended

    class PersonTest {
        private Gender gender;


        @Test
        void getGenderSymbol() {// Create a queue with alternating genders
            Person fPerson = new Person('W');
            assertEquals('W', fPerson.getGenderSymbol(), "Expected gender symbol to be 'W' for female.");
            Person mPerson = new Person('M');
            assertEquals('M', mPerson.getGenderSymbol(), "Expected gender symbol to be 'M' for Male.");
        }

        @Test
        void getGender() {// Create a queue with alternating genders
            Person fPerson = new Person('W');
            assertEquals(gender.FEMALE, fPerson.getGender(), "Expected gender returned to be female.");
            Person mPerson = new Person('M');
            assertEquals(gender.MALE, mPerson.getGender(), "Expected gender returned to be Male.");
        }

        @Test
        void incorrectInput(){

            Person newPerson = new Person('S');
            assertThrows(IllegalArgumentException.class, () -> {new Person('S');});
        }
}


//Now we test the DoormanTest class, similar to above, we test correct input, incorrect input, edge cases and the getter methods

    class DoormanTest {
        private Doorman doorman;

        //Used for utility
        @BeforeEach
        void setUp() {
            // Initialize Doorman with a max difference of 1
            doorman = new Doorman(1);
        }
        @Test
            // Here we test a queue with alternating genders, which should work and let all 4 in
        void testAlternatingQueue() {
            Queue<Person> queue = new LinkedList<>();
            queue.add(new Person('W'));
            queue.add(new Person('M'));
            queue.add(new Person('W'));
            queue.add(new Person('M'));
            int allowedIn = doorman.letIn(queue);
            assertEquals(4, allowedIn, "Doorman should allow all 4 people into the club.");
        }

        @Test
            //Now we test a queue with all te same gender and see if it matches correct output
        void testAllSame() {
            // Create a queue with genders all being the same
            Queue<Person> queue = new LinkedList<>();
            queue.add(new Person('W'));
            queue.add(new Person('W'));
            queue.add(new Person('W'));
            int allowedIn = doorman.letIn(queue);
            assertEquals(2, allowedIn, "Doorman should stop when the maxDifference is exceeded.");
        }

        //Now we test incorrect input

        // here we aim to see if it handles the invalid character
        @Test
        void incorrectInput(){

            Queue<Person> queue = new LinkedList<>();
            Person person_test = new Person('F');
            queue.add(person_test);

            assertThrows(IllegalArgumentException.class, () -> {doorman.letIn(queue);});
            //F could be used for Female here so it's important to test this character

        }

        @Test
            //here we test when the queue is empty and see if it is handled properly
        void testNone() {

            Queue<Person> queue = new LinkedList<>();
            int allowedIn = doorman.letIn(queue);
            assertEquals(0, allowedIn, "People entered should be zero.");
        }
        @Test
            //here we test if we have a null entry in the queue and see if ti correctly handles the error
        void testNull() {
            Queue<Person> queue = new LinkedList<>();
            queue.add(new Person('W'));
            queue.add(null); // Null entry

            assertThrows(NullPointerException.class, () -> doorman.letIn(queue));

        }

        @Test

            //Similar to above, here we test a large queue
        void testLarge() {

            Queue<Person> queue = new LinkedList<>();
            for(int i= 0; i<50; i++){
                queue.add(new Person('M'));
                queue.add(new Person('W'));
            }

            int allowedIn = doorman.letIn(queue);
            assertEquals(100, allowedIn, "Doorman should let everyone in.");
        }
        @Test
            //Similar to above, we see if it handles a case when the queue is larger than the 100 quque limit
        void testGreaterThanMax() {

            Queue<Person> queue = new LinkedList<>();
            for(int i= 0; i<51; i++){
                queue.add(new Person('M'));
                queue.add(new Person('W'));
            }

            int allowedIn = doorman.letIn(queue);
            assertEquals(100, allowedIn, "Doorman should allow only 100 in.");
        }

        // Now we test the getter methods of the Doorman class and see if it works as intended.
        //For the get counts, we create a correct queue of a known number and see if it is handled correctly
        @Test
        void getmaxDifference() {// Create a queue with alternating genders
            int diff = doorman.getMaxDifference();

            // Since the queue is balanced, expect all four to be let in
            assertEquals(1, diff, "Difference should be one as that is what we set.");
        }

        @Test
        void getMenCount() {

            Queue<Person> queue = new LinkedList<>();
            queue.add(new Person('W'));
            queue.add(new Person('M'));
            queue.add(new Person('W'));
            queue.add(new Person('M'));

            int allowedIn = doorman.letIn(queue);
            int count = doorman.getMenCount();


            assertEquals(2, count, "Doorman should return a count of two.");
        }

        @Test
        void getWomenCount() {


            Queue<Person> queue = new LinkedList<>();
            queue.add(new Person('W'));
            queue.add(new Person('M'));
            queue.add(new Person('W'));
            queue.add(new Person('M'));

            int allowedIn = doorman.letIn(queue);
            int count = doorman.getWomenCount();

            assertEquals(2, count, "Doorman should return a count of two.");
        }



    }




class ClubTest {
    private Club club;
    private Doorman doorman;



    @Test
    //Here we are just doing a simple input to see if the program works as intended and provides the write input
    void simpleTest()
    {
        String input = "2,MWMWM";
        Club club = new Club(input);
        int maxPeopleLetIn = club.getMaxPeopleLetIn();
        assertEquals(5, maxPeopleLetIn, "Doorman should allow all 5 people into the club.");
    }
    @Test

    //Another working test, but here we test if the queue is a single gender and see if we return the expected value
    void sameGenderTest() {
        String input = "2,MMMM";
        Club club = new Club(input);
        int maxPeopleLetIn = club.getMaxPeopleLetIn();
        assertEquals(3, maxPeopleLetIn, "Doorman should allow 3 people before stopping.");
    }

    @Test
    //Another working test, but here we test if the program works for the maximum number of people, which is 100
    void testMax() {
        String preinput="";
        for(int i= 0; i<50; i++){
            preinput = preinput +"MW";
        }
        String input = "2,"+ preinput;
        Club club = new Club(input);
        int maxPeopleLetIn = club.getMaxPeopleLetIn();
        assertEquals(100, maxPeopleLetIn, "Doorman should let everyone in.");
    }
    @Test
    //Another working test, but know test when max difference is exceeded, the program handles it accordingly
    //One for sequential data and another non-sequential
    void testMaxDifferenceExceed(){

        String input = "3,MMMMMW";
        Club club = new Club(input);
        int maxPeopleLetIn = club.getMaxPeopleLetIn();
        assertEquals(4, maxPeopleLetIn, "Doorman should allow 4 people before stopping.");

    }

    @Test
        //Similar to the above, the bottom two tests test when we exceed the max difference but with non-sequential data this time
        //One for a small difference and small queue and another with a  large difference and large queue
    void testMaxDifferenceESmallQueueAndDiff(){

        String input = "2,WMWWMWWMMMMMM";
        Club club = new Club(input);
        int maxPeopleLetIn = club.getMaxPeopleLetIn();
        assertEquals(7, maxPeopleLetIn, "Doorman should allow 7 people before stopping.");

    }
    @Test
    void testMaxDifferenceLargeQueueAndDiff(){

        String input = "10,MMMMMMMMMMWWWWWWWWWWWMWWWWWWWWWWWWWWW";
        Club club = new Club(input);
        int maxPeopleLetIn = club.getMaxPeopleLetIn();
        assertEquals(33, maxPeopleLetIn, "Doorman should allow 33 people before stopping.");

    }

    @Test//Another test, but here we test when max difference reached but not exceed, we see if the program handles it correctly
    void testMaxDifferenceEqual(){

        String input = "3,WWWM";
        Club club = new Club(input);
        int maxPeopleLetIn = club.getMaxPeopleLetIn();
        assertEquals(4, maxPeopleLetIn, "Doorman should allow all.");

    }


    @Test
        //here we test a large queue but with a small difference and see if it stops
    void testLargeQueue(){

        String input = "2,MWMWWWMMWWMWMWMMWMWMWWMMWWWMMMWMWMMWM";
        Club club = new Club(input);
        int maxPeopleLetIn = club.getMaxPeopleLetIn();
        assertEquals(27, maxPeopleLetIn, "Doorman should allow all.");

    }



    //here we test for a large Gender difference and see if it stops as intended, with one testing to see if everyone is
        // let in and another to stop and not process rest of queue

    @Test
    void testLargeDiff(){

        String input = "10,MMMMMMMMMMWWWWWWWWWWMMMMMMMMMMMWWWWWMMMWMW";
        Club club = new Club(input);
        int maxPeopleLetIn = club.getMaxPeopleLetIn();
        assertEquals(31, maxPeopleLetIn, "Doorman should allow 31 in.");

    }


  //Here we test what would happen if the length of the queue is over 100, in which it should stop at 100


    //The next few tests test to see if the program handles various incorrect inputs properly
    // These are
    //1. EmptyQueue
    //2. Incorrect Character Input in Queue
    //3. Negative Difference
    //4. Zero Difference Input
    //5. Non-Integer Difference
    //6. Null input
    //7. Cases in which a lower case of the correct character is used
    // 8. Greater than 100
    @Test
    void emptyQueue() {
        String input = "1,";
        Exception exception = assertThrows(IllegalArgumentException.class, () -> {new Club(input);});
        assertEquals("Invalid input format. Expected 'maxDifference, queueString'.", exception.getMessage());

    }

    @Test
    void incorrectCharacterInput() {
        String input = "1,WMC";
        //Club club = new Club(input);
        Exception exception = assertThrows(IllegalArgumentException.class, () -> {new Club(input);});
        assertEquals("Queue string can only contain 'M' (Male) or 'W' (Female).", exception.getMessage());;
    }

    @Test
    void negativeDiffInput() {
        String input = "-1,WMWM";
        Exception exception = assertThrows(IllegalArgumentException.class, () -> {new Club(input);});
        assertEquals("Max difference must be a positive integer.", exception.getMessage());
    }

    @Test
    void emptyDiffInput() {
        String input = ",WMWM";
        Exception exception = assertThrows(IllegalArgumentException.class, () -> {new Club(input);});
        assertEquals("Invalid input format. Expected 'maxDifference, queueString'", exception.getMessage());;
    }


    @Test
    void zeroDiffInput() {
        String input = "0,WMWM";
        Exception exception = assertThrows(IllegalArgumentException.class, () -> {new Club(input);});
        assertEquals("Max difference must be a positive integer.", exception.getMessage());
    }

    @Test
    void incorrectDiffInput() {
        String input = "x,WMWM";
        Exception exception = assertThrows(IllegalArgumentException.class, () -> {new Club(input);});
        assertEquals("Max difference must be a valid integer.", exception.getMessage());
    }
    @Test
    void lowerCaseInput() {
        String input = "2,MWMWm";
        Club club = new Club(input);
        int maxPeopleLetIn = club.getMaxPeopleLetIn();
        assertEquals(5, maxPeopleLetIn, "Doorman should allow all 5 people into the club.");
    }
    @Test
    void testGreaterThanMax() {
        String preinput="";
        for(int i= 0; i<51; i++){
            preinput = preinput +"MW";
        }
        String input = "2,"+ preinput;
        Club club = new Club(input);
        int maxPeopleLetIn = club.getMaxPeopleLetIn();
        assertEquals(100, maxPeopleLetIn, "Doorman should allow 100 at max .");
    }


    //Final two tests make sure the get methods work as intended for the Club class
    @Test
    void testGetterMaxDifference() {
        String input = "2,MWMWMMWWW";
        Club club = new Club(input);
        int maxDiff = club.getMaxDifference();
        assertEquals(2,maxDiff, "Here we should get a difference of two as that is our input");

    }
    @Test
    void testGetterQueue() {
        String input = "2,MWMWMMWWW";
        Club club = new Club(input);
        Queue<Person> queue = club.getQueue();
        String assetTest="";
        for (Person person : queue) {
            assetTest += person.getGenderSymbol();
        }
        assertEquals("MWMWMMWWW",assetTest, "Here we should get MWMWMMWWW as that is what we inputted");

    }

}

