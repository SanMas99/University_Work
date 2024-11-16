/*
 * Task-4: Club
 * The doorman Bruno at the popular night club Heaven is having a hard time
 * fulfilling his duties. He was told by the owner that when the club is full,
 * the number of women and men let into the club should be roughly the same.
 * When the night club opens, people wanting to enter the club are already
 * lined up in a queue, and Bruno can only let them in one-by-one. He lets
 * them in more-or-less in the order they are lined up. He can however decide
 * to let the second person in the queue cut the line and slip into the club
 * before the person in front. This will no doubt upset the person first in
 * line, especially when this happens multiple times, but Bruno is quite a
 * big guy and is capable of handling troublemakers.
 *
 * Unfortunately though, he is not that strong on mental calculations under
 * these circumstances. He finds keeping track of the difference of the number
 * of women and number of men let into the club a challenging task. As soon
 * as the absolute difference gets too big, he loses track of his counting
 * and must declare to the party people remaining in the queue that the club
 * is full.
 *
 * Input: A string containing a positive integer (describing the largest
 * absolute difference between the number of women and number of men let
 * into the club that Bruno can handle) followed by a comma and then a
 * string consisting solely of the characters ’W’ and ’M’ of length at
 * most 100, describing the genders of the people in the queue, in order
 * of their arrival. The first character of this string is the gender
 * of the person first in line. You may assume that the club is large
 * enough to hold all the people in the queue.
 *
 * Output: The maximum number of people Bruno can let into the club
 * without losing track of his counting.
 */

import java.util.LinkedList;
import java.util.Queue;


// Simplified Enum for Gender
enum Gender {
    MALE, FEMALE
}

class Person {
    private Gender gender;

    public Person(char genderChar) {
        this.gender = (genderChar == 'M') ? Gender.MALE : Gender.FEMALE; // Determine gender from character
    }

    public Gender getGender() {
        return gender;
    }

    public char getGenderSymbol() {
        return (gender == Gender.MALE) ? 'M' : 'W'; // Accessor for gender symbol
    }
}

class Doorman {
    private int maxDifference;
    private int menCount;
    private int womenCount;

    public Doorman(int maxDifference) {
        this.maxDifference = maxDifference;
        this.menCount = 0;
        this.womenCount = 0;
    }

    public int letIn(Queue<Person> queue) {
        int count = 0;

        while (!queue.isEmpty()) {
            Person current = queue.poll();
            count++;
            updateCounts(current);

            // Check the absolute difference
            if (Math.abs(menCount - womenCount) > maxDifference) {
                break; // Club is full, stop letting people in
            }

            // Check if there is a second person in the queue
            if (!queue.isEmpty() && canLetSecondIn(queue)) {
                Person second = queue.poll();
                count++;
                updateCounts(second);
                // Check the absolute difference again
                if (Math.abs(menCount - womenCount) > maxDifference) {
                    break; // Club is full, stop letting people in
                }
            }
        }
        return count; // Return the total number of people let in
    }

    private boolean canLetSecondIn(Queue<Person> queue) {
        return true; // Always allow letting the second person in for simplicity
    }

    private void updateCounts(Person person) {
        if (person.getGender() == Gender.MALE) {
            menCount++;
        } else {
            womenCount++;
        }
    }

    public int getMaxDifference() {
        return maxDifference; // Accessor for maxDifference
    }

    public int getMenCount() {
        return menCount; // Accessor for menCount
    }

    public int getWomenCount() {
        return womenCount; // Accessor for womenCount
    }
}

class Club {
    private int maxDifference;
    private Queue<Person> queue;

    public Club(String input) {
        processInput(input);
    }

    private void processInput(String input) {
        String[] parts = input.split(",");
        if (parts.length != 2) {
            throw new IllegalArgumentException("Invalid input format. Expected 'maxDifference, queueString'.");
        }

        try {
            maxDifference = Integer.parseInt(parts[0].trim());
            if (maxDifference <= 0) {
                throw new IllegalArgumentException("Max difference must be a positive integer.");
            }
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Max difference must be a valid integer.");
        }

        queue = new LinkedList<>();
        String queueString = parts[1].trim();
        for (char c : queueString.toCharArray()) {
            if (c != 'M' && c != 'W') {
                throw new IllegalArgumentException("Queue string can only contain 'M' (Male) or 'W' (Female).");
            }
            queue.add(new Person(c)); // Add each person to the queue
        }
    }

    public int getMaxPeopleLetIn() {
        Doorman doorman = new Doorman(maxDifference);
        return doorman.letIn(queue);
    }

    public int getMaxDifference() {
        return maxDifference; // Accessor for maxDifference
    }

    public Queue<Person> getQueue() {
        return queue; // Accessor for the queue of people
    }
}

class ClubMain {
    public static void main(String[] args) {
        // Sample input: "2,WMMWM"
        String input = "2,WMMWM"; // You can modify this input as needed
        Club club = new Club(input);
        int maxPeopleLetIn = club.getMaxPeopleLetIn();

        System.out.println("Maximum number of people let into the club: " + maxPeopleLetIn);
    }
}
