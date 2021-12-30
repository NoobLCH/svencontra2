 class  weapon_sc2lg : CBaseContraWeapon{
    bool bInFiring = false;
    weapon_sc2ar(){
       szVModel = "models/svencontra2/v_sc2ar.mdl";
	    szPModel = "models/svencontra2/wp_sc2ar.mdl";
	    szWModel = "models/svencontra2/wp_sc2ar.mdl";
       szShellModel = "models/saw_shell.mdl";
       iMaxAmmo = 100;
       iMaxAmmo2 = 6;
       iDefaultAmmo = 100;
       iSlot = 1;
       iPosition = 20;

       flDeployTime = 0.8f;
       flPrimeFireTime = 0.11f;
       flSecconaryFireTime = 1.5f;

       szWeaponAnimeExt = "m16";

       iDeployAnime = 4;
       iReloadAnime = 3;
       aryFireAnime = {5, 6, 7};
       aryIdleAnime = {0, 1};

       szFireSound = "weapons/svencontra2/shot_ar.wav";

       flBulletSpeed = 1900;
       flDamage = g_WeaponDMG.AR;
       vecPunchX = Vector2D(-1,1);
       vecPunchY = Vector2D(-1,1);
       vecEjectOffset = Vector(24,8,-5);
    }
    void Precache() override{
       g_SoundSystem.PrecacheSound( "weapons/svencontra2/shot_ar.wav" );
	g_SoundSystem.PrecacheSound( "weapons/svencontra2/shot_gr.wav" );
       g_SoundSystem.PrecacheSound( szGrenadeFireSound );
       g_Game.PrecacheGeneric( "sound/" + szGrenadeFireSound );
	g_Game.PrecacheGeneric( "sound/weapons/svencontra2/shot_ar.wav" );
	g_Game.PrecacheGeneric( "sound/weapons/svencontra2/shot_gr.wav" );

       g_Game.PrecacheModel("sprites/svencontra2/bullet_ar.spr");
	g_Game.PrecacheModel("sprites/svencontra2/bullet_gr.spr");
       g_Game.PrecacheModel("sprites/svencontra2/hud_sc2ar.spr");
       g_Game.PrecacheModel(szGrenadeSpr);
       g_Game.PrecacheGeneric( szGrenadeSpr );
       g_Game.PrecacheGeneric( "sprites/svencontra2/bullet_ar.spr" );
	g_Game.PrecacheGeneric( "sprites/svencontra2/bullet_gr.spr" );
	g_Game.PrecacheGeneric( "sprites/svencontra2/hud_sc2ar.spr" );

	g_Game.PrecacheGeneric( "sprites/svencontra2/weapon_sc2ar.txt" );

       CBaseContraWeapon::Precache();
    }
    void Holster(int skiplocal){
        bInFiring = false;
        CBaseContraWeapon::Holster(skiplocal);
    }
    void CreateProj(int pellet = 1) override{
       
    }
    void EndEntityThink(){

    }
}