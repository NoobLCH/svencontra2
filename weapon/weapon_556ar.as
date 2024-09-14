class  weapon_556ar : CBaseContraWeapon{
    private int iMaxBurstFire = 4;
    private int iBurstLeft = 0;
    private float flBurstTime = 0.035;
    private float flNextBurstTime;
     weapon_556ar(){
        szVModel = "models/solidgear/v_556ar.mdl";
        szPModel = "models/solidgear/wp_556ar.mdl";
        szWModel = "models/solidgear/wp_556ar.mdl";
        szShellModel = "models/saw_shell.mdl";
        szFloatFlagModel = "sprites/solidgear/icon_556ar.spr";

        iMaxAmmo = 600;
        iDefaultAmmo = 300;
        iSlot = 2;
        iPosition = 20;

        flDeployTime = 0.8f;
        flPrimeFireTime = 0.09f;
        flSecconaryFireTime = 0.5f;

        szWeaponAnimeExt = "m16";

        iDeployAnime = 5;
        iReloadAnime = 3;
        aryFireAnime = {6, 7, 8};
        aryIdleAnime = {0, 1};

        szFireSound = "weapons/solidgear/556ar_shot.wav";

        flBulletSpeed = 4500;
        flDamage = g_WeaponDMG.MG;
        vecPunchX = Vector2D(-1,1);
        vecPunchY = Vector2D(-1,1);
        vecEjectOffset = Vector(24,8,-5);
     }
     void Precache() override{
        g_SoundSystem.PrecacheSound( "weapons/solidgear/556ar_shot.wav" );
        g_Game.PrecacheGeneric( "sound/weapons/solidgear/556ar_shot.wav" );

        g_Game.PrecacheModel("sprites/solidgear/hud_556ar.spr");
        g_Game.PrecacheModel("sprites/solidgear/bullet_556ar.spr");
        g_Game.PrecacheGeneric("sprites/solidgear/hud_556ar.spr");
        g_Game.PrecacheGeneric("sprites/solidgear/bullet_556ar.spr");    

        g_Game.PrecacheGeneric( "sprites/solidgear/weapon_556ar.txt" );

        CBaseContraWeapon::Precache();
     }
     void Holster( int skiplocal /* = 0 */ ) override{
        iBurstLeft = 0;
        flNextBurstTime = 0;
        SetThink( null );
        CBaseContraWeapon::Holster(skiplocal);
    }
     void CreateProj(int pellet = 1) override{
        CProjBullet@ pBullet = cast<CProjBullet@>(CastToScriptClass(g_EntityFuncs.CreateEntity( BULLET_REGISTERNAME, null,  false)));
        g_EntityFuncs.SetOrigin( pBullet.self, m_pPlayer.GetGunPosition() );
        @pBullet.pev.owner = @m_pPlayer.edict();
        pBullet.pev.model = "sprites/solidgear/bullet_556ar.spr";
        pBullet.pev.velocity = m_pPlayer.GetAutoaimVector( AUTOAIM_5DEGREES ) * flBulletSpeed;
        pBullet.pev.angles = Math.VecToAngles( pBullet.pev.velocity );
        pBullet.pev.dmg = flDamage;
        g_EntityFuncs.DispatchSpawn( pBullet.self.edict() );
    }
    void SecondaryAttack() override{
        CBaseContraWeapon::SecondaryAttack();
        iBurstLeft = iMaxBurstFire - 1;
        flNextBurstTime = WeaponTimeBase() + flBurstTime;
        self.m_flNextSecondaryAttack = self.m_flNextPrimaryAttack = WeaponTimeBase() + flSecconaryFireTime;
    }
    void ItemPostFrame(){
        if( iBurstLeft > 0 ){
            if( flNextBurstTime < WeaponTimeBase() ){
                if(m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0){
                    iBurstLeft = 0;
                    return;
                }
                else
                    iBurstLeft--;
                Fire();

                if( iBurstLeft > 0 )
                    flNextBurstTime = WeaponTimeBase() + flBurstTime;
                else
                    flNextBurstTime = 0;
            }
            return;
        }
        BaseClass.ItemPostFrame();
    }
}
