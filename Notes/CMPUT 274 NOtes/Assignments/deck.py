#Weekly Exercise #4: Deck Of Cards
#Sanad Masannat 1626221 Fall 2019 CMPUT 274
import sys
class Deck:
    """
    Stores playing cards
    """
    
    def __init__(self, cards):
        '''Initializes attribute for deck of cards
        
        Arguments:
            cards: list of two-character strings representing cards
        '''
        self.__deck = list(cards)
        
    def deal(self):
    	if len(self.__deck)>0:
    		CardDealt=self.__deck[0]#Stores Top card in a variable
    		self.__deck.pop(0)#Pops the Top Card
    		return (CardDealt)#Return the popped top card
    	else:
    		return False
    	'''Deals one card from top of deck.
        
        Returns:
            Either the top card (first element in the deck list), or
            False if there are no cards left in the deck
        '''
    def validate(self):
        is_valid=True
        StringOfCharacters="23456789KAJQT"#Stores all potiential number/letters
        Suits="SCDH"#Stores suits
        NoOfCards=len(self.__deck)
        if NoOfCards!=52:#Checks length of deck
            is_valid=False
            msg="This is not valid as there are ", NoOfCards ," Cards"
            ReturnTuple=[is_valid,msg]
            return(ReturnTuple)
        else:
            for i in range (0,NoOfCards):
                CurrentCard=self.__deck[i]
                j=0
                if CurrentCard[0] not in StringOfCharacters:#Checks if 1st half of card is valid
                    print ("Test1")
                    is_valid=False
                    msg="Card" + CurrentCard + "is not a valid card"
                    ReturnTuple=[is_valid,msg]
                    return (ReturnTuple)
                elif CurrentCard[-1:] not in Suits:#Checks if the card's suit is vaid
                	is_valid=False
                	msg="Card " +  CurrentCard + " is not a valid card"
                	ReturnTuple=[is_valid,msg]
                	return (ReturnTuple)
                if self.__deck.count(CurrentCard)!=1:#Counts the number of times the current card occurs
                	is_valid=False
                	msg= "Deck contains duplicate cards"
                	ReturnTuple=[is_valid,msg]
                	return (ReturnTuple)
                if is_valid==True:#If all conditions above are met, it is valid
                	is_valid=True
                	msg=" "
                	ReturnTuple=[is_valid,msg]
                	return (ReturnTuple)
        '''
        Returns:
           (is_valid, msg): a tuple containing a Boolean value indicating whether
                            the deck is valid (True) or not (False), and a string
                            that is either empty (when deck is valid) or contains
                            information about why the deck is no valid
        '''             
    
    def __str__(self):
        if len(self.__deck)>0:
            OutputString=" "
            for i in range (len(self.__deck)-1):#Loops throughout all of the deck excpet the last card
                OutputString= OutputString + str(self.__deck[i])+ "-"# Puts current card and a hyphen
            OutputString= OutputString + self.__deck[len(self.__deck)-1]#Stores last card
            return (OutputString)
        else:
            OutputString="Empty Deck"
            return (OutputString)

    '''Creates custom string to represent deck object
    Returns:
    String representation of deck object
    '''         

def ValidateDeck(newDeck):#Calls validate method in class
    Message=newDeck.validate()
    if Message[0]==False:
        print (Message)
        exit()
    else:
        print (Message)
def PlayHighCard(newCard):#Calls the funstion to play high card
    Numbers= "23456789"
    LetterNumbers="TJQKSA"
    Card1= " "
    Card2= " "
    j=1
    Card1=newDeck.deal()
    Card2=newDeck.deal()
    while Card1!=False:
        OutString=newDeck.__str__()#Prints the state of the deck after the two cards are dealt
        print (OutString)
        print (Card1)
        print (Card2)
        if Card1[0]==Card2[0]:#Checks if 1st half of card is equal
            print ("Round ", j , ": Tie!")
        elif (str(Card1[0]) in LetterNumbers and str(Card2[0] in Numbers) in Numbers) or(Card1[0]=="T" and Card2[0]==9) or (Card1[0]=="J" and Card2[0]=="T") or (Card1[0]=="Q" and Card2[0]=="J") or (Card1[0]=="K" and Card2=="Q") or (Card1[0]=="A" and Card2[0]=="K") or Card1[0]>Card2[0]:
            print ("Round ", j , ": Dealer Wins!")#After checking if Card 1 is higher than card 2, outputs that Dealer won
        elif (str(Card2[0]) in LetterNumbers and str(Card1[0] in Numbers) in Numbers) or (Card2[0]=="T" and Card1[0]==9) or (Card2[0]=="J" and Card1[0]=="T") or (Card2[0]=="Q" and Card1[0]=="J") or (Card2[0]=="K" and Card1=="Q") or (Card2[0]=="A" and Card1[0]=="K") or Card2[0]>Card1[0]:
            print ("Round ", j , ": Player Wins!")#Does the same as above but for checking if Card2 is higher than card 1
        Card1=newDeck.deal()#Calls the deal method again to check if the next card is available ot if False
        Card2=newDeck.deal()
        j+=1#Increase round counter

if __name__ == "__main__":
##    sys.argv
##    File=open(sys.argv[1],'r')#Passes in command arguement
    CardList=['KC','KS','AH','QS','6C','6D','5H','TS','JH','TH','TD','KD','7H','3C','9C','2C','8S','9S','4C','AD','2D','QH','AC','2H','4H','8H','4S','QD','4D','3S','5D','6S','3D','QC','TC','JD','8C','6H','JC','AS','9H','7S','5C','7D','7C','9D','5S','3H','JS','8D','2S','KH']
    for i in range(0,len(CardList)):
    	CardList[i]=CardList[i].upper()
    print (CardList)
    newDeck = Deck(CardList)
    ValidateDeck(newDeck)
    OutString=newDeck.__str__()
    print (OutString)
    PlayHighCard(newDeck)
