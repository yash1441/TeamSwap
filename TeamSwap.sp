#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR "Simon"
#define PLUGIN_VERSION "1.0"

#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <sdkhooks>

#pragma newdecls required

bool SwapClient[MAXPLAYERS + 1] =  { false, ... };

EngineVersion g_Game;

public Plugin myinfo = 
{
	name = "Team Swap",
	author = PLUGIN_AUTHOR,
	description = "Swap team of killer (CT) and victim (T) after round end.",
	version = PLUGIN_VERSION,
	url = "yash1441@yahoo.com"
};

public void OnPluginStart()
{
	g_Game = GetEngineVersion();
	if(g_Game != Engine_CSGO && g_Game != Engine_CSS)
	{
		SetFailState("This plugin is for CSGO/CSS only.");	
	}
	
	HookEvent("round_end", Event_RoundEnd);
	HookEvent("player_death", Event_PlayerDeath);
}

public Action Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
	int attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
	int victim = GetClientOfUserId(GetEventInt(event, "userid"));
	
	if(GetClientTeam(attacker) == CS_TEAM_CT && GetClientTeam(victim) == CS_TEAM_T)
	{
		SwapClient[attacker] = SwapClient[victim] = true;
	}
}

public Action Event_RoundEnd(Event event, const char[] name, bool dontBroadcast)
{
	for (int i = 1; i < MaxClients; i++)
	{
		if (SwapClient[i])
		{
			(GetClientTeam(i) == CS_TEAM_T) ? ChangeClientTeam(i, CS_TEAM_CT) : ChangeClientTeam(i, CS_TEAM_T);
			SwapClient[i] = false;
		}
	}
}