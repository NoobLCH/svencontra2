class CTracePoint : ScriptBaseEntity{
    private bool m_bIsOn = false;

    private uint8 m_uiWidth = 1;
    private uint8 m_uiLife = 1;

    bool KeyValue( const string& in szKey, const string& in szValue )
	{
		if(szKey == "width")
		{
			m_uiWidth = uint8(atof(szValue) * 10);
			return true;
		}
        else if(szKey == "life")
		{
			m_uiLife = uint8(atof(szValue) * 10);
			return true;
		}
		else
			return BaseClass.KeyValue( szKey, szValue );
	}
    void Spawn(){
        if(self.pev.model == ""){
            self.SUB_Remove();
            return;
        }
        BaseClass.Spawn();
    }
    void Precache(){
        if(self.pev.model.IsEmpty != ""){
            g_Game.PrecacheModel(self.pev.model);
            g_Game.PrecacheGeneric(self.pev.model);
        }
    }
    void TurnOn(){
        NetworkMessage m(MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY, null);
            m.WriteByte(TE_BEAMFOLLOW);
            m.WriteShort(self.entindex());
            m.WriteShort(g_EngineFuncs.ModelIndex(self.pev.model));
            m.WriteByte(m_uiLife);
            m.WriteByte(m_uiWidth);
            m.WriteByte(uint8(self.pev.rendercolor.x));
            m.WriteByte(uint8(self.pev.rendercolor.y));
            m.WriteByte(uint8(self.pev.rendercolor.z));
            m.WriteByte(uint8(self.pev.renderamt));
        m.End();
        m_bIsOn = true;
    }
    void TurnOff(){
        NetworkMessage m(MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY, null);
            m.WriteByte(TE_KILLBEAM);
            m.WriteShort(self.entindex());
        m.End();
        m_bIsOn = false;
    }
    void Use(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue = 0.0f){
        switch(useType){
            case USE_KILL:
            case USE_OFF:{
                TurnOff();
                break;
            }

            case USE_SET:
            case USE_ON:{
                TurnOn();
                break;
            }
            case USE_TOGGLE:
            default:{
                if(m_bIsOn)
                    TurnOff();
                else
                    TurnOn();
                break;
            }
        }
    }
}