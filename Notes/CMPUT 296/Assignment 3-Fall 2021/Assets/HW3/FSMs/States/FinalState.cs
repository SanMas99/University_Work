using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FinalState : State
{
    //State to return to when completed Scatter State
    private State returnState;
    public FinalState() : base("Final") { }
    // Start is called before the first frame update
    public override State Update(FSMAgent agent)
    {
        //Determine if we've killed Pacman
        Vector3 pacmanLocation = PacmanInfo.Instance.transform.position;
        if (agent.CloseEnough(pacmanLocation))
        {
            ScoreHandler.Instance.KillPacman();
        }

        if (PelletHandler.Instance.JustEatenPowerPellet)
        {
            return new FrightenedState(this);
        }



        return this;
    }
    public override void EnterState(FSMAgent agent){
        agent.SetSpeedModifierNormal();
        agent.SetTarget(PacmanInfo.Instance.transform.position+PacmanInfo.Instance.Facing * (ObstacleHandler.Instance.GridSize));
    }


    // Update is called once per frame
    public override void ExitState(FSMAgent agent)
    {
        base.ExitState(agent);
    }
}