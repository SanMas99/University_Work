﻿using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AStarPathFinder : GreedyPathFinder
{
    public static int nodesOpened = 0;

    //ASSIGNMENT 2: EDIT BELOW THIS LINE, IMPLEMENT A*
    public override Vector3[] CalculatePath(GraphNode startNode, GraphNode goalNode)
    {
        nodesOpened = 0;

        AStarNode start = new AStarNode(null, startNode, Heuristic(startNode, goalNode));
        float gScore = 0;

        PriorityQueue<AStarNode> openSet = new PriorityQueue<AStarNode>();
        openSet.Enqueue(start);
        Dictionary<string, float> gScores = new Dictionary<string, float>();

        List<GraphNode> closedSet = new List<GraphNode>();
        Dictionary<AStarNode, float> gScoresOfParent = new Dictionary<AStarNode, float>();

        int attempts = 0;
        while (openSet.Count() > 0 && attempts<10000)
        {
            attempts += 1;
            AStarNode currNode = openSet.Dequeue();
            closedSet.Add(currNode.GraphNode);

            //Did we find the goal?
            if (currNode.Location == goalNode.Location)
            {
                Debug.Log("CHECKED " + nodesOpened + " NODES");//Don't delete this line
                //Reconstruct the path?
                return ReconstructPath(start, currNode);
            }
            
            //Check each neighbor
            foreach (GraphNode neighbor in currNode.GraphNode.Neighbors)
            {
                if (closedSet.Contains(neighbor))
                {
                    continue;
                }
                gScore = currNode.GetGScore() + ObstacleHandler.Instance.GridSize + 1f;
                if (openSet.Data.Find(x => x.GraphNode.Location == neighbor.Location) == null) {
                    AStarNode aStarNeighbor = new AStarNode(currNode, neighbor, Heuristic(neighbor, goalNode));
                    openSet.Enqueue(aStarNeighbor);
                    gScores[neighbor.Location.ToString()] = gScore;   
                }else if (gScore<gScores[neighbor.Location.ToString()]){
                    openSet.Remove(openSet.Data.Find(x => x.GraphNode.Location == neighbor.Location));
                    AStarNode aStarNeighbor = new AStarNode(currNode, neighbor, Heuristic(neighbor, goalNode));
                    openSet.Enqueue(aStarNeighbor);
                    gScores[neighbor.Location.ToString()] = gScore;
                }              
                
            }
        }
        Debug.Log("CHECKED "+ nodesOpened + " NODES");//Don't delete this line
        return null;
    }
    //ASSIGNMENT 2: EDIT ABOVE THIS LINE, IMPLEMENT A*

    //EXTRA CREDIT ASSIGNMENT 2 EDIT BELOW THIS LINE
    public float Heuristic(GraphNode currNode, GraphNode goalNode)
    {
        return (Mathf.Abs(currNode.Location.x-goalNode.Location.x) + Mathf.Abs(currNode.Location.y - goalNode.Location.y));
    }
    //EXTRA CREDIT ASSIGNMENT 2 EDIT ABOVE THIS LINE

    //Code for reconstructing the path, don't edit this.
    private Vector3[] ReconstructPath(AStarNode startNode, AStarNode currNode)
    {
        List<Vector3> backwardsPath = new List<Vector3>();

        while (currNode != startNode)
        {
            backwardsPath.Add(currNode.Location);
            currNode = currNode.Parent;
        }
        backwardsPath.Reverse();

        return backwardsPath.ToArray();
    }
}



