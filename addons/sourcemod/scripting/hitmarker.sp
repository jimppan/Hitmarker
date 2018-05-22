#pragma semicolon 1


#define PLUGIN_AUTHOR "Rachnus"
#define PLUGIN_VERSION "1.0"

#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <sdkhooks>

#pragma newdecls required

public Plugin myinfo = 
{
	name = "Hitmarker",
	author = PLUGIN_AUTHOR,
	description = "MLG420",
	version = PLUGIN_VERSION,
	url = "https://github.com/Rachnus"
};

public void OnPluginStart()
{
	for (int i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i))
			OnClientPutInServer(i);
	}
}

public Action OnPlayerTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype, int &weapon, float damageForce[3], float damagePosition[3])
{
	if(!IsValidClient(victim))
		return Plugin_Continue;
	
	if(weapon < 0 || !IsValidEntity(weapon))
		return Plugin_Continue;
		
	char className[64];
	GetEntityClassname(weapon, className, sizeof(className));
	
	if(!StrContains(className, "knife", false) || !StrContains(className, "bayonet", false)) // Not attacked by knife
		return Plugin_Continue;
	
	if(damage <= 0.0)
		return Plugin_Continue;
	
	EmitSoundToClient(attacker, "hitmarker.mp3");
	
	SetHudTextParams(0.495, 0.491, 0.1, 255, 255, 255, 255, 0, 0.0, 0.0, 0.0);
	ShowHudText(attacker, -1, "X");

	return Plugin_Continue;
}

stock bool IsValidClient(int client)
{
	if(client > 0 && client <= MaxClients)
	{
		if(IsClientInGame(client))
			return true;
	}
	return false;
}

public void OnClientPutInServer(int client)
{
	SDKHook(client, SDKHook_OnTakeDamage, OnPlayerTakeDamage);
	
	AddFileToDownloadsTable("sound/hitmarker.mp3");
	PrecacheSound("hitmarker.mp3", true);
}
