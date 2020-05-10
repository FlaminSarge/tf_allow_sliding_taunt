#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <tf2_stocks>

bool bAllowSliding;

public Plugin myinfo = {
	name = "[TF2] Sliding Taunt Patch",
	author = "FlaminSarge",
	description = "Fixes tf_allow_sliding_taunt",
	version = "1.0.0",
	url = "https://github.com/FlaminSarge"
}

public void OnPluginStart() {
	ConVar cvSliding = FindConVar("tf_allow_sliding_taunt");
	cvSliding.AddChangeHook(CvhookSliding);
	bAllowSliding = cvSliding.BoolValue;
}

public void CvhookSliding(ConVar cvar, const char[] oldVal, const char[] newVal) {
	bAllowSliding = cvar.BoolValue;
}

public void TF2_OnConditionAdded(int client, TFCond condition) {
	if (!bAllowSliding) {
		return;
	}
	if (condition != TFCond_Taunting) {
		return;
	}
	int offs = GetEntSendPropOffs(client, "m_flVehicleReverseTime");
	if (offs <= 0) {
		return;
	}
	offs = offs + 8;	//"taunt move speed" sets this when taunt starts
	float speed = GetEntDataFloat(client, offs);
	float maxSpeed = GetEntPropFloat(client, Prop_Send, "m_flMaxspeed");
	if (speed == 0 && speed != maxSpeed) {
		SetEntDataFloat(client, offs, maxSpeed);
	}
}
