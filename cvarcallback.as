void ARCVarCallback(CCVar@ cvar, const string& in szOldValue, float flOldValue){
    g_WeaponDMG.AR = cvar.GetFloat();
}
void SGCVarCallback(CCVar@ cvar, const string& in szOldValue, float flOldValue){
    g_WeaponDMG.SG = cvar.GetFloat();
}
void FGCVarCallback(CCVar@ cvar, const string& in szOldValue, float flOldValue){
    g_WeaponDMG.FG = cvar.GetFloat();
}
void FGECVarCallback(CCVar@ cvar, const string& in szOldValue, float flOldValue){
    g_WeaponDMG.FGE = cvar.GetFloat();
}
void MGCVarCallback(CCVar@ cvar, const string& in szOldValue, float flOldValue){
    g_WeaponDMG.MG = cvar.GetFloat();
}