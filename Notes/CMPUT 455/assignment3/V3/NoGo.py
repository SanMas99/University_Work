#!/usr/local/bin/python3
# /usr/bin/python3
# Set the path to your python3 above

from gtp_connection import GtpConnection
from board_util import GoBoardUtil
from board import GoBoard,GO_COLOR, GO_POINT, NO_POINT, PASS
from ucb import runUcb, writeMoves, select_best_move
from simulation_engine import GoSimulationEngine, NoGoArgs

class Go0():
    def __init__():
        #In go3 they did smthin like this self, sim: int, move_select: str, sim_rule: str, check_selfatari: bool, limit: int = 10) -> None
        #GoSimulationEngine.__init__(self, "Go0", 1.0#sim, move_select, sim_rule, check_selfatari, limit)
        """
        NoGo player that selects moves randomly from the set of legal moves.

        Parameters
        ----------
        name : str
            name of the player (used by the GTP interface).
        version : float
            version number (used by the GTP interface).
        """
        self.name = "Go0"
        self.version = 1.0

    def playGame(self, board: GoBoard, color: GO_COLOR) -> GO_COLOR:
        """
        Run a simulation game.
        """
        #Here is another part that i cant figure out but most functionality is rigt, we would need to change PatternUtil to use ours
        '''
        for _ in range(self.args.limit):
            color = board.current_player
            if self.args.random_simulation:
                move = GoBoardUtil.generate_random_move(board, color, True)
            else:
                move = PatternUtil.generate_move_with_filter(
                    board, self.args.use_pattern, self.args.check_selfatari
                )
            board.play_move(move, color)
            if move == PASS:
                return color
'''
    def get_move(self, board: GoBoard, color: GO_COLOR) -> GO_POINT:
        """
        Run one-ply MC simulations to get a move to play.
        """
        cboard = board.copy()
        emptyPoints = board.get_empty_points()
        moves = []
        for p in emptyPoints:
            if board.is_legal(p, color):
                moves.append(p)
        if not moves:
            return PASS
        
        if self.args.use_ucb:
            C = 0.4  # sqrt(2) is safe, this is more aggressive
            best = runUcb(self, cboard, C, moves, color)
            return best
        else:
            moveWins = []
            for move in moves:
                wins = self.simulateMove(cboard, move, color)
                moveWins.append(wins)
            writeMoves(cboard, moves, moveWins, self.args.sim)
            return select_best_move(board, moves, moveWins)

        
    def getWeights(self, board: GoBoard, color: GO_COLOR): #Get the weights of all legal moves
        cboard = board.copy()
        emptyPoints = board.get_empty_points()
        moves = []
        for p in emptyPoints:
            if board.is_legal(p, color):
                moves.append(p)
        if not moves:
            return 0
        #moves.append(PASS)            
            
             
        weights = []
        with open('weights.txt') as f:
            lines = f.readlines        
        for move in moves:
            #Get all 8 neighbors, in two lists of four
            neighborsFlat = board._neighbors(move)
            neighborsDiag = board._diag_neighbors(move)
                
            #List of neighbors in order of the 0123p4567 shown on Part 2 specifications
            allNeighbors = [neighborsDiag[0], neighborsFlat[2], neighborsDiag[1], neighborsFlat[0], neighborsFlat[1], neighborsDiag[2], neighborsFlat[3], neighborsDiag[3]]
            #              Top Left           Top               Top Right         Left     (point)  Right             Bottom Left       Bottom            Bottom Right
                
            #Specs: "The pattern is matched to an eight digit base-4 number. The addressing in the weight table is in base-10, so this base-4 number
            #        will need to be converted to a base-10 address to query the corresponding weight coefficient."
                
            #For reference, bottom right should be multiplied by 4^7, top left should be multipled by 4^0 (1), according to the example in the specs
            #Convert to Base 10
            indexB10 = (allNeighbors[7] * (4**7)) + (allNeighbors[6] * (4**6)) + (allNeighbors[5] * (4**5)) + (allNeighbors[4] * (4**4)) + (allNeighbors[3] * (4**3)) + (allNeighbors[2] * (4**2)) + (allNeighbors[1] * (4**1)) + (allNeighbors[0])
            
            #The weight should be the base 10 index matched to the correct index in weights.txt,
            #split at the space (so the weight doesn't include the index itself), and then [1] to signify item 2 of the split (the weight value)
            #weight = (lines[indexB10].split(" "))[1]
            weights.append((lines[indexB10].split(" "))[1])
            
        return weights
            
        """    
        #Specs: "And let's say the corresponding weights for the three patterns are 0.5, 0.7, and 0.1, respectively. The probability of generating the corner move will then be 0.1 / (0.5 + 0.7 + 0.1)"
        #Does this mean to return the move with the highest probability of being picked?  Or with the highest weight?  I mean won't they be the same anyway?
            
        #Highest weight
        return moves[argmax(weights)] #move at the matching index with the highest weight value
            
        #Highest probability
        maxProbability = 0
        bestMove = moves[0] #Let's just assume it's the first one to begin with
        x = 0
        for weight in weights:
            probability = weights[x] / weightSum
            if probability > maxProbability:
                bestMove = moves[x]
            x = x + 1
                
        return bestMove   
        """
        
    def getWeight(self, board: GoBoard, color: GO_COLOR, point): #Get the weights of one specific move
        
        if not board.is_legal(point, color):
            return 0
        
        weights = []
        with open('weights.txt') as f:
            lines = f.readlines        

        #Get all 8 neighbors, in two lists of four
        neighborsFlat = board._neighbors(point)
        neighborsDiag = board._diag_neighbors(point)

        #List of neighbors in order of the 0123p4567 shown on Part 2 specifications
        allNeighbors = [neighborsDiag[0], neighborsFlat[2], neighborsDiag[1], neighborsFlat[0], neighborsFlat[1], neighborsDiag[2], neighborsFlat[3], neighborsDiag[3]]
        #              Top Left           Top               Top Right         Left     (point)  Right             Bottom Left       Bottom            Bottom Right

        #Specs: "The pattern is matched to an eight digit base-4 number. The addressing in the weight table is in base-10, so this base-4 number
        #        will need to be converted to a base-10 address to query the corresponding weight coefficient."

        #For reference, bottom right should be multiplied by 4^7, top left should be multipled by 4^0 (1), according to the example in the specs
        #Convert to Base 10
        indexB10 = (allNeighbors[7] * (4**7)) + (allNeighbors[6] * (4**6)) + (allNeighbors[5] * (4**5)) + (allNeighbors[4] * (4**4)) + (allNeighbors[3] * (4**3)) + (allNeighbors[2] * (4**2)) + (allNeighbors[1] * (4**1)) + (allNeighbors[0])

        #The weight should be the base 10 index matched to the correct index in weights.txt,
        #split at the space (so the weight doesn't include the index itself), and then [1] to signify item 2 of the split (the weight value)
        return (lines[indexB10].split(" "))[1]    

    
    
    def getProbabilities(self, board: GoBoard, color: GO_COLOR): #Get the probabilities each legal move
        cboard = board.copy()
        emptyPoints = board.get_empty_points()
        moves = []
        for p in emptyPoints:
            if board.is_legal(p, color):
                moves.append(p)
        if not moves:
            return 0
        #moves.append(PASS)            


        weights = []
        weightSum = 0
        with open('weights.txt') as f:
            lines = f.readlines        
        for move in moves:
            #Get all 8 neighbors, in two lists of four
            neighborsFlat = board._neighbors(move)
            neighborsDiag = board._diag_neighbors(move)

            #List of neighbors in order of the 0123p4567 shown on Part 2 specifications
            allNeighbors = [neighborsDiag[0], neighborsFlat[2], neighborsDiag[1], neighborsFlat[0], neighborsFlat[1], neighborsDiag[2], neighborsFlat[3], neighborsDiag[3]]
            #              Top Left           Top               Top Right         Left     (point)  Right             Bottom Left       Bottom            Bottom Right

            #Specs: "The pattern is matched to an eight digit base-4 number. The addressing in the weight table is in base-10, so this base-4 number
            #        will need to be converted to a base-10 address to query the corresponding weight coefficient."

            #For reference, bottom right should be multiplied by 4^7, top left should be multipled by 4^0 (1), according to the example in the specs
            #Convert to Base 10
            indexB10 = (allNeighbors[7] * (4**7)) + (allNeighbors[6] * (4**6)) + (allNeighbors[5] * (4**5)) + (allNeighbors[4] * (4**4)) + (allNeighbors[3] * (4**3)) + (allNeighbors[2] * (4**2)) + (allNeighbors[1] * (4**1)) + (allNeighbors[0])

            #The weight should be the base 10 index matched to the correct index in weights.txt,
            #split at the space (so the weight doesn't include the index itself), and then [1] to signify item 2 of the split (the weight value)
            weight = (lines[indexB10].split(" "))[1]
            weights.append(weight)
            weightSum = weightSum + weight
            
        probabilities = []
        for weight in weights:
            probability = weight / weightSum
            probabilities.append(probability)

        return probabilities

def run():
    """
    start the gtp connection and wait for commands.
    """
    board = GoBoard(7)
    con = GtpConnection(Go0(), board)
    con.start_connection()

if __name__ == "__main__":
    run()


"""
#Jake's get_move edit after initial interpretation of Assignment 3 Part 2
    def get_move(self, board: GoBoard, color: GO_COLOR) -> GO_POINT:
        
        #Run one-ply MC simulations to get a move to play.
        
        cboard = board.copy()
        emptyPoints = board.get_empty_points()
        moves = []
        for p in emptyPoints:
            if board.is_legal(p, color):
                moves.append(p)
        if not moves:
            return PASS
        moves.append(PASS)
        
        
        
        if len(moves) == 1:
            #If there's only one valid move then why bother with the next step?
            return moves[0]
         
        weightSum = 0
        weights = []
        with open('weights.txt') as f:
            lines = f.readlines        
        for move in moves:
            neighborsFlat = board._neighbors(move)
            neighborsDiag = board._diag_neighbors(move)
            
            #List of neighbors in order of the 0123p4567 shown on Part 2 specifications
            allNeighbors = [neighborsDiag[0], neighborsFlat[2], neighborsDiag[1], neighborsFlat[0], neighborsFlat[1], neighborsDiag[2], neighborsFlat[3], neighborsDiag[3]]
            #              Top Left           Top               Top Right         Left     (point)  Right             Bottom Left       Bottom            Bottom Right
            
            #Specs: "The pattern is matched to an eight digit base-4 number. The addressing in the weight table is in base-10, so this base-4 number
            # will need to be converted to a base-10 address to query the corresponding weight coefficient."
            
            #For reference, bottom right should be multiplied by 4^7, top left should be multipled by 4^0 (1) 
            #Convert to Base 10
            indexB10 = (allNeighbors[7] * (4**7)) + (allNeighbors[6] * (4**6)) + (allNeighbors[5] * (4**5)) + (allNeighbors[4] * (4**4)) + (allNeighbors[3] * (4**3)) + (allNeighbors[2] * (4**2)) + (allNeighbors[1] * (4**1)) + (allNeighbors[0])
        
            #The weight should be the base 10 index matched to the correct index in weights.txt, split at the space (so the weight doesn't include the index itself), and then [1] to signify item 2 of the split (the weight value)
            weight = (lines[indexB10].split(" "))[1]
            weights.append(weight)
            weightSum += weight #add the weight to the weight sum
            
        #Specs: "And let's say the corresponding weights for the three patterns are 0.5, 0.7, and 0.1, respectively. The probability of generating the corner move will then be 0.1 / (0.5 + 0.7 + 0.1)"
        #Does this mean to return the move with the highest probability of being picked?  Or with the highest weight?  I mean won't they be the same anyway?
        
        #Highest weight
        return moves[argmax(weights)] #move at the matching index with the highest weight value
        
        #Highest probability
        maxProbability = 0
        bestMove = moves[0] #Let's just assume it's the first one to begin with
        x = 0
        for weight in weights:
            probability = weights[x] / weightSum
            if probability > maxProbability:
                bestMove = moves[x]
            x = x + 1
            
        return bestMove
        """