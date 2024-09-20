string BULLET_REGISTERNAME = "contra_bullet";
string BULLET_HITSOUND = "common/null.wav";

funcdef void BulletTouchCallback( CProjBullet@, CBaseEntity@ );
namespace ProjBulletTouch{
    void DefaultDirectTouch(CProjBullet@ pThis, CBaseEntity@ pOther){
        if(pOther.IsAlive()){
            g_WeaponFuncs.DamageDecal(@pOther, pThis.iDamageType);
            g_WeaponFuncs.SpawnBlood(pThis.self.pev.origin, pOther.BloodColor(), pThis.self.pev.dmg);
            pOther.TakeDamage( pThis.self.pev, pThis.self.pev.owner.vars, pThis.self.pev.dmg, pThis.iDamageType);
        }
    }
    void DefaultPostTouch(CProjBullet@ pThis, CBaseEntity@ pOther){
        g_SoundSystem.EmitSound( pThis.self.edict(), CHAN_AUTO, pThis.szHitSound, 1.0f, ATTN_NONE );
        g_EntityFuncs.Remove(pThis.self);
    }
    void DefaultTouch(CProjBullet@ pThis, CBaseEntity@ pOther){
        ProjBulletTouch::DefaultDirectTouch(@pThis, @pOther);
        ProjBulletTouch::DefaultPostTouch(@pThis, @pOther);
    }
    void ExplodeTouch(CProjBullet@ pThis, CBaseEntity@ pOther){
        ProjBulletTouch::DefaultDirectTouch(@pThis, @pOther);
        g_WeaponFuncs.RadiusDamage(pThis.self.pev.origin, pThis.self.pev, pThis.self.pev.owner.vars, pThis.flExpDmg, pThis.iExpRadius, -1, pThis.iDamageType);
        NetworkMessage m(MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY, null);
            m.WriteByte(TE_EXPLOSION);
            m.WriteCoord(pThis.self.pev.origin.x);
            m.WriteCoord(pThis.self.pev.origin.y);
            m.WriteCoord(pThis.self.pev.origin.z);
            m.WriteShort(g_EngineFuncs.ModelIndex(pThis.szExpSpr));
            m.WriteByte(pThis.iExpSclae);
            m.WriteByte(15);
            m.WriteByte(0);
        m.End();
        ProjBulletTouch::DefaultPostTouch(@pThis, @pOther);
    }
    void BonusTouch(CProjBullet@ pThis, CBaseEntity@ pOther){
        //飞到地图外面直接消失
        if( g_EngineFuncs.PointContents( pThis.self.pev.origin ) == CONTENTS_SKY )
		{
			g_EntityFuncs.Remove( pThis.self );
			return;
		}
        ProjBulletTouch::DefaultDirectTouch(@pThis, @pOther);
        ProjBulletTouch::BonusPostTouch(@pThis, @pOther);
    }
    void BonusPostTouch(CProjBullet@ pThis, CBaseEntity@ pOther){
        g_SoundSystem.EmitSound( pThis.self.edict(), CHAN_AUTO, pThis.szHitSound, 1.0f, ATTN_NONE );
        if (pThis.iMaxBonus <= 0)
            g_EntityFuncs.Remove(pThis.self);
        else
            pThis.iMaxBonus--;
    }
}
class CProjBullet : ScriptBaseAnimating{
    string szSprPath = "sprites/svencontra2/bullet_mg.spr";
    string szHitSound = BULLET_HITSOUND;
    float flSpeed = 800;
    float flScale = 0.5f;
    int iDamageType = DMG_BULLET;
    Vector vecHullMin = Vector(-4, -4, -4);
    Vector vecHullMax = Vector(4, 4, 4);
    //Exp vars
    string szExpSpr = "sprites/svencontra2/bullet_fghit.spr";
    string szExpSound = "weapons/svencontra2/shot_fghit.wav";
    int iExpSclae;
    int iExpRadius;
    float flExpDmg;
    //Bonus vars
    int iMaxBonus = 5;

    BulletTouchCallback@ pTouchFunc = null;

    void SetExpVar(string _s, string _es, int _sc, int _r, float _d){
        szExpSpr = _s;
        szExpSound = _es;
        iExpSclae = _sc;
        iExpRadius = _r;
        flExpDmg = _d;
    }

    void Spawn(){    
        if(self.pev.owner is null)
            return;
        Precache();
        pev.movetype = MOVETYPE_FLYMISSILE;
        pev.solid = SOLID_TRIGGER;
        self.pev.framerate = 1.0f;
        if(self.pev.model == "")
            self.pev.model = szSprPath;
        if(self.pev.speed <= 0)
            self.pev.speed = flSpeed;
        if(self.pev.dmg <= 0)
            self.pev.dmg = 30;
        if(self.pev.scale <= 0)
            self.pev.scale = flScale;
        if(@pTouchFunc is null)
            @pTouchFunc = @ProjBulletTouch::DefaultTouch;
        self.pev.rendermode = kRenderTransAdd;
        self.pev.renderamt = 255;
        self.pev.rendercolor = Vector(255, 255, 255);
        self.pev.groupinfo = 114514;
        g_EntityFuncs.SetModel( self, self.pev.model );
        g_EntityFuncs.SetSize(self.pev, vecHullMin, vecHullMax);
        g_EntityFuncs.SetOrigin( self, self.pev.origin );
    }

    void SetAnim( int animIndex ) {
        self.pev.sequence = animIndex;
        self.pev.frame = 0;
        self.ResetSequenceInfo();
    }

    void Precache(){
        BaseClass.Precache();
        
        string szTemp = string( self.pev.model ).IsEmpty() ? szSprPath : string(self.pev.model);
        g_Game.PrecacheModel( szTemp );
        g_Game.PrecacheGeneric( szTemp );

        g_Game.PrecacheModel( szExpSpr );
        g_Game.PrecacheGeneric( szExpSpr );

        g_Game.PrecacheModel( szSprPath );
        g_Game.PrecacheGeneric( szSprPath );

        g_SoundSystem.PrecacheSound( szHitSound );
        g_Game.PrecacheGeneric( "sound/" + szHitSound );
         g_SoundSystem.PrecacheSound( szExpSound );
        g_Game.PrecacheGeneric( "sound/" + szExpSound );
    }
    void Touch( CBaseEntity@ pOther ){
        if( pOther.GetClassname() == self.GetClassname() || pOther.edict() is self.pev.owner)
            return;
        pTouchFunc(this, pOther);
    }
}

CProjBullet@ ShootABullet(edict_t@ pOwner, Vector vecOrigin, Vector vecVelocity, int iDamage = 0, int iDamageType = DMG_BULLET, string szHitSnd = ""){
    CProjBullet@ pBullet = cast<CProjBullet@>(CastToScriptClass(g_EntityFuncs.CreateEntity( BULLET_REGISTERNAME, null,  false)));

    g_EntityFuncs.SetOrigin( pBullet.self, vecOrigin );
    @pBullet.pev.owner = @pOwner;

    pBullet.pev.velocity = vecVelocity;
    pBullet.pev.angles = Math.VecToAngles( pBullet.pev.velocity );
    
    pBullet.SetTouch( TouchFunction( pBullet.Touch ) );

    pBullet.pev.dmg = iDamage;
    pBullet.iDamageType = iDamageType;
    if (!szHitSnd.IsEmpty())
        pBullet.szHitSound = szHitSnd;

    g_EntityFuncs.DispatchSpawn( pBullet.self.edict() );

    return pBullet;
}

CProjBullet@ ShootABullet(CBaseEntity@ pOwner, Vector vecOrigin, Vector vecVelocity, int iDamage = 0, int iDamageType = DMG_BULLET, string szHitSnd = ""){
    CProjBullet@ pBullet = cast<CProjBullet@>(CastToScriptClass(g_EntityFuncs.CreateEntity( BULLET_REGISTERNAME, null,  false)));

    g_EntityFuncs.SetOrigin( pBullet.self, vecOrigin );
    @pBullet.pev.owner = @pOwner.edict();

    pBullet.pev.velocity = vecVelocity;
    pBullet.pev.angles = Math.VecToAngles( pBullet.pev.velocity );
    
    pBullet.SetTouch( TouchFunction( pBullet.Touch ) );

    pBullet.pev.dmg = iDamage;
    pBullet.iDamageType = iDamageType;
    if (!szHitSnd.IsEmpty())
        pBullet.szHitSound = szHitSnd;

    g_EntityFuncs.DispatchSpawn( pBullet.self.edict() );

    return pBullet;
}

CProjBullet@ ShootAExpBullet(CBaseEntity@ pOwner, Vector vecOrigin, Vector vecVelocity, int iDamage = 0, int iExpDmg = 0, int iExpRadius = 0, string szHitSnd = ""){
    CProjBullet@ pBullet = cast<CProjBullet@>(CastToScriptClass(g_EntityFuncs.CreateEntity( BULLET_REGISTERNAME, null,  false)));

    g_EntityFuncs.SetOrigin( pBullet.self, vecOrigin );
    @pBullet.pev.owner = @pOwner.edict();

    pBullet.pev.velocity = vecVelocity;
    pBullet.pev.angles = Math.VecToAngles( pBullet.pev.velocity );
    @pBullet.pTouchFunc = @ProjBulletTouch::ExplodeTouch;
    pBullet.SetTouch( TouchFunction( pBullet.Touch ) );

    pBullet.pev.dmg = iDamage;
    pBullet.iDamageType = DMG_BLAST;
    if (!szHitSnd.IsEmpty())
        pBullet.szHitSound = szHitSnd;
    //设置爆炸相关
    pBullet.flExpDmg = float(iExpDmg);
    pBullet.iExpRadius = iExpRadius;
    pBullet.iExpSclae = Math.min(int(iRadius * 0.15), 255);

    g_EntityFuncs.DispatchSpawn( pBullet.self.edict() );

    return pBullet;
}

CProjBullet@ ShootABonusLaser(CBaseEntity@ pOwner, Vector vecOrigin, Vector vecVelocity, int iDamage = 0, int iMaxBonus, string szHitSnd = ""){
    CProjBullet@ pBullet = cast<CProjBullet@>(CastToScriptClass(g_EntityFuncs.CreateEntity( BULLET_REGISTERNAME, null,  false)));

    g_EntityFuncs.SetOrigin( pBullet.self, vecOrigin );
    @pBullet.pev.owner = @pOwner.edict();

    pBullet.pev.velocity = vecVelocity;
    pBullet.pev.angles = Math.VecToAngles( pBullet.pev.velocity );
    @pBullet.pTouchFunc = @ProjBulletTouch::BonusTouch;
    pBullet.SetTouch( TouchFunction( pBullet.Touch ) );
    pBullet.iMaxBonus = iMaxBonus;
    pBullet.pev.dmg = iDamage;
    pBullet.iDamageType = DMG_ENERGYBEAM;
    if (!szHitSnd.IsEmpty())
        pBullet.szHitSound = szHitSnd;

    g_EntityFuncs.DispatchSpawn( pBullet.self.edict() );
    pBullet.pev.movetype = MOVETYPE_BOUNCEMISSILE;
    return pBullet;
}
