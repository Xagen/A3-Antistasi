params ["_group", "_supportTypes", "_target"];

/*  Simulates the call for support by a group by making the teamleader a bit more dumb for a time

    Execution on: HC or Server

    Scope: Internal

    Params:
        _group: GROUP : The group which should call support
        _supportTypes: ARRAY of STRINGs : The types of support the group calls for
        _target: OBJECT : The target object the group wants support against

    Returns:
        Nothing
*/

private _groupLeader = leader _group;

//If groupleader is down, dont call support
if(![_groupLeader] call A3A_fnc_canFight) exitWith {};

//Lower skill of group leader to simulate radio communication (!!!Barbolanis idea!!!)
private _oldSkill = skill _groupLeader;
_groupLeader setSkill (_oldSkill - 0.2);

//Wait for the call to happen
private _timeToCallSupport = 10 + random 5;
sleep _timeToCallSupport;

//Reset leader skill
_groupLeader setSkill _oldSkill;

//If the group leader survived the call, proceed
if([_groupLeader] call A3A_fnc_canFight) then
{
    //Support successfully called in, setting cooldown
    private _date = date;
    _date set [4, (_date select 4) + 10];
    private _dateNumber = dateToNumber _date;
    _group setVariable ["canCallSupportAt", _dateNumber, true];

    //Starting the support
    [_target, _group knowsAbout _target, _supportTypes] spawn A3A_fnc_sendSupport;
};
