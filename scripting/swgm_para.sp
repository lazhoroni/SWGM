#pragma tabsize 0
#pragma semicolon 1

#define PLUGIN_AUTHOR "LazHoroni"
#define PLUGIN_VERSION "1.00"

#include <steamworks>
#include <sdktools>
#include <swgm>
#include <multicolors>

int g_iRound;
Handle g_hCvRestart;

public Plugin myinfo = 
{
	name = "",
	author = PLUGIN_AUTHOR,
	description = "",
	version = PLUGIN_VERSION,
	url = ""
};

public void OnPluginStart()
{
	HookEvent("round_start", lazRoundStart);
	g_hCvRestart = FindConVar("mp_restartgame");
	HookConVarChange(g_hCvRestart, lazCvarChange);
	LoadTranslations("swgm_para.phrases");
}

public void OnMapStart()
{
	g_iRound = 0;
}

public void OnMapEnd()
{
	g_iRound = 0;
}

public void lazCvarChange( Handle hCvar, const char[] sOldValue, const char[] sNewValue )
{
	if( StringToInt(sNewValue) > 0 ) g_iRound = 0;
}

public Action lazRoundStart(Handle hEvent, const char[] Name, bool dontbroadcast)
{
	if (GameRules_GetProp("m_bWarmupPeriod") == 0)
	{
		g_iRound++;
		if(g_iRound != 1 && g_iRound != 2 && g_iRound != 3 && g_iRound != 16 && g_iRound != 17 && g_iRound != 18)
		{
			for (int iClient = 1; iClient <= MaxClients; iClient++)
			if (SWGM_IsPlayerValidated(iClient))
				{
					if(!SWGM_InGroup(iClient))
					{
						CPrintToChat(iClient, "%t", "GrubaKatilmaDuyurusu");
						SetEntProp(iClient, Prop_Send, "m_bHasHelmet", 100);
						SetEntProp(iClient, Prop_Send, "m_ArmorValue", 100);
					}
					else
					{
						int Parasi = GetEntProp(iClient, Prop_Send, "m_iAccount");
						SetEntProp(iClient, Prop_Send, "m_iAccount", Parasi + 1000);
						SetEntProp(iClient, Prop_Send, "m_bHasHelmet", 100);
						SetEntProp(iClient, Prop_Send, "m_ArmorValue", 100);
						CPrintToChat(iClient, "%t", "OdulDuyurusu");
					}
				}
		}
		else
		{
			for (int iClient = 1; iClient <= MaxClients; iClient++)
			if (SWGM_IsPlayerValidated(iClient))
				{
					if(!SWGM_InGroup(iClient))
					{
						/// BOŞ
					}
					else
					{
						CPrintToChat(iClient, "%t", "Ilk3RoundMesaji");
					}
				}
		}
	}
}

