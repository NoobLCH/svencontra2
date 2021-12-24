const string WEAPONFLAG_REGISTERNAME = "info_weaponflag";
class CWeaponFlag : ScriptBaseAnimating{
    void Spawn(){	
        if(self.pev.owner is null)
            return;
        Precache();
		pev.movetype = MOVETYPE_NOCLIP;
		pev.solid = SOLID_NOT;
        self.pev.framerate = 1.0f;
        if(self.pev.fuser1 <= 0)
            self.pev.fuser1 = 24;
        self.pev.scale = 0.25;
        self.pev.rendermode = kRenderTransAlpha;
        self.pev.renderamt = 255;
        self.pev.rendercolor = Vector(255, 255, 255);
		g_EntityFuncs.SetModel( self, self.pev.model );
        g_EntityFuncs.SetOrigin( self, self.pev.origin );
        self.pev.nextthink = g_Engine.time + 0.05f;
	}
    void Think(){
        Vector vecOrigin = self.pev.owner.vars.origin;
        vecOrigin.z += self.pev.fuser1;
        g_EntityFuncs.SetOrigin( self, vecOrigin );
        self.pev.nextthink = g_Engine.time + 0.05f;
    }
    void Precache(){
        g_Game.PrecacheModel( self.pev.model );
        g_Game.PrecacheGeneric( self.pev.model );
    }
}