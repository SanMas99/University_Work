"""
Solution stub for the River Problem.

Fill in the implementation of the `River_problem` class to match the
representation that you specified in problem XYZ.
"""
from searchProblem import Search_problem, Arc

class River_problem(Search_problem):
    def __init__(self):
        self.neighs = {}
        self.nodes ={tuple([0,0,0,0]),tuple([1,0,0,1]),tuple([1,0,1,0]),tuple([1,1,0,0]),tuple([0,0,1,0]),tuple([1,1,1,0]),
         tuple([1,0,1,1]),tuple([0,1,1,0]),tuple([0,0,1,1]),tuple([0,0,0,1]),tuple([0,1,0,1]),
         tuple([1,1,0,1]),tuple([1,0,1,0]),tuple([0,1,0,0]),tuple([1,1,1,1])}
        for node in self.nodes:
            self.neighs[node]=[]
            tuple([0,0,0,0]),tuple([1,0,1,0]),1
        self.arcs = [(Arc(tuple([0,0,0,0]) , tuple([1,0,0,1]) , 1))
         ,(Arc(tuple([0,0,0,0]),tuple([1,0,1,0]),1))
         ,(Arc(tuple([0,0,0,0]),tuple([1,1,0,0]),1))
         ,(Arc(tuple([1,0,1,0]),tuple([0,0,0,0]),1))
         ,(Arc(tuple([1,0,1,0]),tuple([0,0,1,0]),1))
         ,(Arc(tuple([0,0,1,0]),tuple([1,0,1,0]),1))
         ,(Arc(tuple([0,0,1,0]),tuple([1,0,1,1]),1))
         ,(Arc(tuple([0,0,1,0]),tuple([1,1,1,0]),1))
         ,(Arc(tuple([1,1,1,0]),tuple([0,0,1,0]),1))
         ,(Arc(tuple([1,1,1,0]),tuple([0,1,1,0]),1))
         ,(Arc(tuple([1,1,1,0]),tuple([0,1,0,0]),1))
         ,(Arc(tuple([1,0,1,1]),tuple([0,0,1,0]),1))
         ,(Arc(tuple([1,0,1,1]),tuple([0,0,0,1]),1))
         ,(Arc(tuple([1,0,1,1]),tuple([0,0,1,1]),1))
         ,(Arc(tuple([0,1,0,0]),tuple([1,1,1,0]),1))
         ,(Arc(tuple([0,0,0,1]),tuple([1,0,1,1]),1))
         ,(Arc(tuple([0,1,0,0]),tuple([1,1,0,1]),1))
         ,(Arc(tuple([0,0,0,1]),tuple([1,1,0,1]),1))
         ,(Arc(tuple([1,1,0,1]),tuple([0,1,0,0]),1))
         ,(Arc(tuple([1,1,0,1]),tuple([0,0,0,1]),1))
         ,(Arc(tuple([1,1,0,1]),tuple([0,1,0,1]),1))
         ,(Arc(tuple([0,1,0,1]),tuple([1,1,0,1]),1))
         ,(Arc(tuple([0,1,0,1]),tuple([1,1,1,1]),1))]
        
        for arc in self.arcs:
            self.neighs[arc.from_node].append(arc)
        self.start = tuple([0,0,0,0])#Indexes are Farmer,Grain,Hen,Fox where 0 indicates left side and 1 will indicate right side
        self.goals = tuple([1,1,1,1])
    def start_node(self):
        """returns start node"""
        return (self.start)
    
    def is_goal(self,node):
        """is True if node is a goal"""
        
        if node==self.goals:
            return True
        else:
            return False

    def neighbors(self,node):
        neighbors=[]
        connectedNodes=[]
        for i in range(0,len(self.arcs)):
            if((self.arcs)[i].from_node==node):
                connectedNodes.append((self.arcs)[i])   
        return connectedNodes

    def heuristic(self,n):
        """Gives the heuristic value of node n."""
        returnValue=0;
        if (n[1]==1 and n[2]==1 and n[0]==0 and n[3]==0) or (n[1]==0 and n[2]==0 and n[0]==1 and n[3]==1) or (n[1]==0 and n[2]==1 and n[0]==0 and n[3]==1) or (n[1]==1 and n[2]==0 and n[0]==1 and n[3]==0) :
            returnValue+=1
        for i in range (0,4):
            if n[i]==1:
                returnValue+=1
        return returnValue
    

