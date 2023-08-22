using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CustomGhostState : State
{

    public CustomGhostState() : base("Custom Ghost") { }

    public override void EnterState(FSMAgent agent)
    {
        agent.SetTimer(20f);
    }

    public override void ExitState(FSMAgent agent)
    {
        base.ExitState(agent);
    }
     
    public override State Update(FSMAgent agent)
    {
        //Handle Following Pacman
        Vector3 pacmanLocation = PacmanInfo.Instance.transform.position;
        if (agent.CloseEnough(pacmanLocation))
        {
            ScoreHandler.Instance.KillPacman();
        }

        //If timer complete, go to Scatter State
        if (agent.TimerComplete())
        {
            return new ScatterState(new Vector3(ObstacleHandler.Instance.XBound, -1 * (ObstacleHandler.Instance.YBound)), this);
        }

        //If Pacman ate a power pellet, go to Frightened State
        if (PelletHandler.Instance.JustEatenPowerPellet)
        {
            return new FrightenedState(this);
        }
        Vector3 closestPellet=(PelletHandler.Instance.GetClosestPellet(pacmanLocation)).transform.position;
        //If we didn't return follow Pacman
        agent.SetTarget(closestPellet);
        int noOfPellets=ScoreHandler.Instance.Score;
        if ( noOfPellets==52||noOfPellets==104||noOfPellets==156){
            return new FrenzyState();
        }
        //Stay in this state
        return this;
    }
}
