params ["_supportType", "_side", "_position"];

/*  Checks if the given support is available for use

    Execution on: Server

    Scope: External

    Params:
        _supportType: STRING : The type of support that should be checked
        _side: SIDE : The side for which the availability should be checked

    Returns:
        True if available, false otherwise
*/

private _available = false;
switch (_supportType) do
{
    case ("QRF"):
    {
        //Do a quick check for at least one available airport
        private _index = airportsX findIf
        {
            sidesX getVariable [_x, sideUnknown] == _side &&
            {(getMarkerPos _x) distance2D _position < distanceForAirAttack &&
            {[_x] call A3A_fnc_airportCanAttack}}
        };
        if(_index != -1) exitWith
        {
            _available = true;
        };
        //No airport found, search for bases
        private _index = outposts findIf
        {
            sidesX getVariable [_x, sideUnknown] == _side &&
            {(getMarkerPos _x) distance2D _position < distanceForLandAttack &&
            {[_x] call A3A_fnc_airportCanAttack &&
            {[getMarkerPos _x, _position] call A3A_fnc_isTheSameIsland}}}
        };
        if(_index != -1) then
        {
            _available = true;
        };
    };
    case ("AIRSTRIKE"):
    {
        //Hard coded level limit, no airstrikes on warlevels under 3
        if(tierWar < 3) exitWith {};
        if(_side == Occupants) then
        {
            _available = ((occupantsAirstrikes findIf {[_x] call A3A_fnc_unitAvailable}) != -1);
        };
        if(_side == Invaders) then
        {
            _available = ((invadersAirstrikes findIf {[_x] call A3A_fnc_unitAvailable}) != -1);
        };
    };
    case ("MORTAR"):
    {
        //Hard coded level limit, no mortar on warlevel 1
        if(tierWar < 2) exitWith {};
        if(_side == Occupants) then
        {
            _available = ((occupantsMortar findIf {[_x] call A3A_fnc_unitAvailable}) != -1);
        };
        if(_side == Invaders) then
        {
            _available = ((invadersMortar findIf {[_x] call A3A_fnc_unitAvailable}) != -1);
        };
    };
    default
    {
        //If unknown, set not available
        _available = false;
    };
};

_available;