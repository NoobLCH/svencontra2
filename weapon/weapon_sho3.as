class  weapon_sho3 : CBaseContraWeapon{
    //霰弹圆形扩散度;
    private float flRoundSpear = 50.0f;
     weapon_sho3(){
        szVModel = "models/solidgear/v_sho3.mdl";
        szPModel = "models/solidgear/wp_sho3.mdl";
        szWModel = "models/solidgear/wp_sho3.mdl";
        szShellModel = "models/shotgunshell.mdl";
        szFloatFlagModel = "sprites/solidgear/icon_sho3.spr";
        
        iMaxAmmo = 200;
        iDefaultAmmo = 80;
        iSlot = 2;
        iPosition = 21;

        flDeployTime = 0.8f;
        flPrimeFireTime = 0.8f;
        flSecconaryFireTime = 0.25f;

        szWeaponAnimeExt = "shotgun";

        iDeployAnime = 6;
        iReloadAnime = 3;
        aryFireAnime = {1, 2};
        aryIdleAnime = {0, 8};

        szFireSound = "weapons/solidgear/sho3_shot.wav";

        flBulletSpeed = 4000;
        flDamage = g_WeaponDMG.SG;
        vecPunchX = Vector2D(-1,1);
        vecPunchY = Vector2D(-1,1);
        iShellBounce = TE_BOUNCE_SHOTSHELL;
        vecEjectOffset = Vector(24,8,-5);
     }
     void Precache() override{
        g_SoundSystem.PrecacheSound( "weapons/solidgear/sho3_shot.wav" );
        g_Game.PrecacheGeneric( "sound/weapons/solidgear/sho3_shot.wav" );

        g_Game.PrecacheModel("sprites/solidgear/hud_sho3.spr");
        g_Game.PrecacheModel("sprites/solidgear/bullet_sho3.spr");
        g_Game.PrecacheGeneric("sprites/solidgear/hud_sho3.spr");    
        g_Game.PrecacheGeneric("sprites/solidgear/bullet_sho3.spr");            

        g_Game.PrecacheGeneric( "sprites/solidgear/weapon_sho3.txt" );

        CBaseContraWeapon::Precache();
     }
     void SingleProj(float r, float u){
         Vector vecAiming = m_pPlayer.GetAutoaimVector( AUTOAIM_5DEGREES );
         CProjBullet@ pBullet = cast<CProjBullet@>(CastToScriptClass(g_EntityFuncs.CreateEntity( BULLET_REGISTERNAME, null,  false)));
            g_EntityFuncs.SetOrigin( pBullet.self, m_pPlayer.GetGunPosition() );
            @pBullet.pev.owner = @m_pPlayer.edict();
            pBullet.pev.model = "sprites/solidgear/bullet_sho3.spr";
            pBullet.pev.velocity = vecAiming * flBulletSpeed + r * g_Engine.v_right + u *  g_Engine.v_up;
            pBullet.pev.angles = Math.VecToAngles( pBullet.pev.velocity );
            pBullet.pev.dmg = flDamage;
            g_EntityFuncs.DispatchSpawn(pBullet.self.edict());
     }
     void CreateProj(int pellet = 1) override{
        SingleProj(0, 0);
        for(int i = 0; i < pellet - 1; i++){
            float Angle = 2 * Math.PI * float(i) / float(pellet-1);
            SingleProj(flRoundSpear * cos(Angle), flRoundSpear * sin(Angle));
        }
    }
    void PrimaryAttack() override{
        if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0){
            self.PlayEmptySound();
            self.m_flNextPrimaryAttack = WeaponTimeBase() + 0.15f;
            return;
        }
        Fire(10);
        if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 )
            m_pPlayer.SetSuitUpdate( "!HEV_AMO0", false, 0 );
        self.m_flNextPrimaryAttack = WeaponTimeBase() + flPrimeFireTime;
    }
    void SecondaryAttack() override{
        if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0){
            self.PlayEmptySound();
            self.m_flNextSecondaryAttack = WeaponTimeBase() + 0.15f;
            return;
        }
        Fire(8);
        if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 )
            m_pPlayer.SetSuitUpdate( "!HEV_AMO0", false, 0 );
        self.m_flNextSecondaryAttack = WeaponTimeBase() + flSecconaryFireTime;
    }
}
        
