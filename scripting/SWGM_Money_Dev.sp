#include <sourcemod>
#include <cstrike>
#include <sdktools>
#include <SteamWorks>
#include <SWGM>

#pragma semicolon 1
#pragma newdecls required

#define MESSAGE_PREFIX "[SM]"

Handle KillPerMoney;
Handle RoundStartMoney;

int iMoneyPerKill;
int iRoundStartMoney;

public Plugin myinfo = 
{
	name = "Round start and per kill money",
	author = "B3none, LazHoroni",
	description = "",
	version = "1.0.0",
	url = ""
};

public void OnPluginStart()
{
	HookEvent("round_start", OnRoundStart);
	HookEvent("player_death", OnPlayerDeath);
	
	KillPerMoney = CreateConVar("sm_moneyperkill", "50", "Money awarded per kill");
	RoundStartMoney = CreateConVar("sm_roundstartmoney", "1000", "Round start money");
}

public void OnMapStart()
{
	iMoneyPerKill = GetConVarInt(KillPerMoney);
	iRoundStartMoney = GetConVarInt(RoundStartMoney);
}

public Action OnRoundStart(Handle hEvent, const char[] Name, bool dontbroadcast)
{
	if (IsWarmup())
	{
		return;
	}
	
	if (IsRoundBlah(GetCurrentRound()))
	{
		for (int iClient = 1; iClient <= MaxClients; iClient++)
		{
			if(IsClientInGame(iClient))
			{
				if(SWGM_IsPlayerValidated(iClient) && !SWGM_InGroup(iClient))
				{
					PrintToChat(iClient, "%s \x04You can win \x07+$%i \x04by joining the group.", MESSAGE_PREFIX, iRoundStartMoney);
					PrintToChat(iClient, "%s \x04Click on the \x07server website button\x04 in the score table.", MESSAGE_PREFIX);
					SetEntProp(iClient, Prop_Send, "m_bHasHelmet", 100);
					SetEntProp(iClient, Prop_Send, "m_ArmorValue", 100);
				}
				else
				{
					PrintToChat(iClient, "%s \x04You won \x07+$%i \x04for joining the group.", MESSAGE_PREFIX, iRoundStartMoney);
					int money = GetEntProp(iClient, Prop_Send, "m_iAccount");
					SetEntProp(iClient, Prop_Send, "m_iAccount", money + iRoundStartMoney);
					SetEntProp(iClient, Prop_Send, "m_bHasHelmet", 100);
					SetEntProp(iClient, Prop_Send, "m_ArmorValue", 100);
				}
			}
		}
	}
	else
	{
		for (int iClient = 1; iClient <= MaxClients; iClient++)
		{
			if(IsClientInGame(iClient))
			{
				if(SWGM_IsPlayerValidated(iClient) && !SWGM_InGroup(iClient))
				{
					PrintToChat(iClient, "%s \x04You can win \x07+$%i \x04by joining the group.", MESSAGE_PREFIX, iRoundStartMoney);
					PrintToChat(iClient, "%s \x04Click on the \x07server website button\x04 in the score table.", MESSAGE_PREFIX);
				}
				else
				{
					PrintToChat(iClient, "%s \x04First 3 round \x07+$%i, helmet, armor \x04prize is disabled.", MESSAGE_PREFIX, iRoundStartMoney);
				}
			}
		}
	}		
}

public Action OnPlayerDeath(Handle event, const char[] name, bool dontBroadcast)
{
	int iClient = GetClientOfUserId(GetEventInt(event, "attacker"));
	if(IsClientInGame(iClient))
	{
		if(SWGM_IsPlayerValidated(iClient) && !SWGM_InGroup(iClient))
		{
			///
		}
		else
		{
			PrintToChat(iClient, "%s \x04You won \x07+$%i \x04for killing the player.", MESSAGE_PREFIX, iMoneyPerKill);
			int money = GetEntProp(iClient, Prop_Send, "m_iAccount");
			SetEntProp(iClient, Prop_Send, "m_iAccount", money + iMoneyPerKill);
		}
	}
}

bool IsRoundBlah(int iRound)
{
	return iRound != 0 && iRound != 1 && iRound != 2 && iRound != 15 && iRound != 16 && iRound != 17;
}

bool IsWarmup()
{
	return GameRules_GetProp("m_bWarmupPeriod") != 0;
}

int GetCurrentRound()
{
	return CS_GetTeamScore(CS_TEAM_T) + CS_GetTeamScore(CS_TEAM_CT);
}