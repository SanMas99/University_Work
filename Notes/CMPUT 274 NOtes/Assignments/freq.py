# Weekly Exercise #3: Frequency Table
def AnalyzeList(WordList):
	NoOfWords=len(WordList)
	CurrentWord=" "
	FrequencyTable=[]
	WordTable=[]
	WordList.sort()#Will sort out the table lexilogically to allow the next part fo the code to work properly
	for i in range(0,NoOfWords):
		if CurrentWord!=WordList[i]:#Prevent the same word from being entered into table
			CurrentWord=WordList[i]#Will update current word so the same word can not be inputted again
			CurrentWordCount=WordList.count(CurrentWord)
			CurrentWordFrequency=float(round((CurrentWordCount/NoOfWords),3))
			FrequencyTable=[CurrentWord,CurrentWordCount,CurrentWordFrequency]
			WordTable.append(FrequencyTable)
	WordTable.sort()#Sorts Frequency Table into Lexilogical order
	return WordTable

def Output(WordTable):
	OutputFile=sys.argv[1] + " .out" #Adds out extenstion to output file
	for i in range (0,len(WordTable)):
		print(WordTable[i])#Prints table line by line
	OutFile=open(OutputFile, "w")#Stores into newly made file
	OutFile.writelines(str(WordTable))
	OutFile.close()
                        
                        
        
         
        
        
       
if __name__ == "__main__":
        import sys
        WordList=[]
        sys.argv
        try:#Exception handling is used when there is no arguments passed
        	File=open(sys.argv[1],'r')
        except:
        	print (" There is less than the required amount of arguments. The program will now exit. Please put in the correct number of arguments next time")
        	exit()

        if len(sys.argv)>2:#Checks length of arguments
                print (" There is more than the required amount of arguments. The program will now exit. Please put in correct number of arguments next time")
                exit()
        else:
        	WordList=File.read().split()#Splits the inputted file into indiviual words and store it            
        WordTable=AnalyzeList(WordList)
        Output(WordTable)#Calls the output function passsing word table in
