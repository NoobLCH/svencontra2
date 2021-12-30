class CTankRocketExtItem{
    float flBulletSpeed;
    int iWeapon;
}
dictionary dicTankRocketExt;

class trigger_tankdefine : ScriptBaseEntity{
    private int iWeapon;
    private float flSpeed;
    bool KeyValue(const string& in szKeyName, const string& in szValue){
        if(szKeyName == "weapon"){
            iWeapon = atoi(szValue);
            return true;
        }
        else if(szKeyName == "bulletspeed"){
            flSpeed = atof(szValue);
            return true;
        }
        return BaseClass.KeyValue(szKeyName, szValue);
    }
    void Spawn(){
        BaseClass.Spawn();
        g_Scheduler.SetTimeout(@this, "DelayTrigger", 0.1);
    }
    void DelayTrigger(){
        CBaseEntity@ pEntity = null;
        while((@pEntity = g_EntityFuncs.FindEntityByTargetname(pEntity, self.pev.target)) !is null){
            if(@pEntity !is null)
                pEntity.pev.weaponanim = iWeapon;
        }
        CTankRocketExtItem pItem;
        pItem.flBulletSpeed = flSpeed;
        pItem.iWeapon = iWeapon;
        dicTankRocketExt[self.pev.target] = @pItem;
        g_EntityFuncs.Remove(self);
    }
}