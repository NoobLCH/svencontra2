const string CVAR_ARNAME = "sk_plr_sc2ar";
const string CVAR_SGNAME = "sk_plr_sc2sg";
const string CVAR_MGNAME = "sk_plr_sc2mg";
const string CVAR_FGNAME = "sk_plr_sc2fg";
const string CVAR_FGENAME = "sk_plr_sc2fge";
const string CVAR_KNNAME = "sk_plr_crowbar";

CCVar@ pCVarAR = CCVar(CVAR_ARNAME, 15, "", ConCommandFlag::AdminOnly);
CCVar@ pCVarSG = CCVar(CVAR_SGNAME, 18, "", ConCommandFlag::AdminOnly);
CCVar@ pCVarMG = CCVar(CVAR_MGNAME, 25, "", ConCommandFlag::AdminOnly);
CCVar@ pCVarFG = CCVar(CVAR_FGNAME, 55, "", ConCommandFlag::AdminOnly);
CCVar@ pCVarFGE = CCVar(CVAR_FGENAME, 100, "", ConCommandFlag::AdminOnly);

class CWeaponDMGBase {
    int AR = int(g_EngineFuncs.CVarGetFloat(CVAR_ARNAME));
    int SG = int(g_EngineFuncs.CVarGetFloat(CVAR_SGNAME));
    int MG = int(g_EngineFuncs.CVarGetFloat(CVAR_MGNAME));
    int FG = int(g_EngineFuncs.CVarGetFloat(CVAR_FGNAME));
    int FGE = int(g_EngineFuncs.CVarGetFloat(CVAR_FGENAME));
    int KN = int(g_EngineFuncs.CVarGetFloat(CVAR_KNNAME));

    //默认值
    int ARD = AR;
    int SGD = SG;
    int MGD = MG;
    int FGD = FG;
    int FGED = FGE;
    int KND = KN;
    void Tweak(float factor){
        g_EngineFuncs.CVarSetFloat(CVAR_ARNAME, factor * ARD);
        g_EngineFuncs.CVarSetFloat(CVAR_SGNAME, factor * SGD);
        g_EngineFuncs.CVarSetFloat(CVAR_MGNAME, factor * MGD);
        g_EngineFuncs.CVarSetFloat(CVAR_FGNAME, factor * FGD);
        g_EngineFuncs.CVarSetFloat(CVAR_FGENAME, factor * FGED);
        KN = int(factor * KND);
        g_EngineFuncs.CVarSetFloat(CVAR_KNNAME, this.KN);
    }
    void Reset(){
        Tweak(1.0f);
    }
}
CWeaponDMGBase g_WeaponDMG;

void PlayerDMGTweak(){
    int iNowPlayerNum = 0;
    for(uint i = 0; i < 33; i++){
        CBasePlayer@ pEntity = cast<CBasePlayer@>(g_EntityFuncs.Instance(g_EntityFuncs.IndexEnt(i)));
        if(pEntity !is null && pEntity.IsPlayer() && pEntity.IsNetClient() && pEntity.IsConnected()){
            iNowPlayerNum++;
        }
    }
    g_WeaponDMG.Reset();
    //1 = 1.5
    //2 = 1
    //3 = 0.83
    //4 = 0.75
    //5 = 0.7
    //6 = 0.66
    //7 = 0.64
    //8 = 0.625
    //9 = 0.611
    //10 = 0.6
    //11 = 0.59
    //.......
    //+∞ = 0.5
    float flTweakFactor = 1.0f / (iNowPlayerNum) + 0.5f;
    g_WeaponDMG.Tweak(flTweakFactor);
}