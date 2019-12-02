#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR "Tetragromaton"
#define PLUGIN_VERSION "1.0"
#define foreach(%0) for (int %0 = 1; %0 <= MaxClients; %0++) if (IsClientInGame(%0))
#include <sourcemod>
#include <sdktools>
#include <cstrike>
//#include <sdkhooks>
#include <smlib>
//#pragma newdecls required

EngineVersion g_Game;

public Plugin myinfo = 
{
	name = "Fake Ping",
	author = PLUGIN_AUTHOR,
	description = "Display fake ping in tab scores",
	version = PLUGIN_VERSION,
	url = "https://github.com/Tetragromaton"
};
int FakePing[MAXPLAYERS + 1] = -1;
public void OnPluginStart()
{
	g_Game = GetEngineVersion();
	if(g_Game != Engine_CSGO && g_Game != Engine_CSS)
	{
		SetFailState("This plugin is for CSGO/CSS only.");	
	}
	RegAdminCmd("fakeping", Command_FakePing, ADMFLAG_GENERIC);
}
public IsValidClient(client)
{
	if (!(1 <= client <= MaxClients) || !IsClientInGame(client))
		return false;
	
	return true;
}
public OnClientPostAdminCheck(client)
{
	FakePing[client] = -1;
}
public OnGameFrame()
{
	foreach(X)
	{
		if(FakePing[X] > -1)
		{
			Client_SetPing(X, FakePing[X]);
		}
	}
}
public Action Command_FakePing(client,args)
{
	int ping = -1;
	char Wtf[36];
	GetCmdArg(1, Wtf, sizeof(Wtf));
	if(StrEqual(Wtf, ""))
	{
		PrintToChat(client, "Usage: /fakeping <ping to fake (-1 to disable)>");
		return Plugin_Handled;
	}
	ping = StringToInt(Wtf);
	PrintToChat(client, "Fake ping is set to %i", ping);
	FakePing[client] = ping;
	return Plugin_Handled;
}