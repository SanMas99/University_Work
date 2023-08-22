using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FrenzyState : State
{
    //State to return to when completed Scatter State
    private State returnState;
    public FrenzyState() : base("Frenzy") { }
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
        if (agent.TimerComplete())
        {
            return new TiredState();
        }
        agent.SetTarget(PacmanInfo.Instance.transform.position+PacmanInfo.Instance.Facing * (ObstacleHandler.Instance.GridSize)*2);

        return this;
    }
    public override void EnterState(FSMAgent agent){
        Debug.Log("Frenzy entered");
        agent.SetTimer(10f);
        agent.SetSpeedModifierDouble();
        
    }


    // Update is called once per frame
    public override void ExitState(FSMAgent agent)
    {
        base.ExitState(agent);
    }
}
