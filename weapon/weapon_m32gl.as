class  weapon_m32gl : CBaseContraWeapon{
   weapon_m32gl(){
       szVModel = "models/solidgear/v_m32gl.mdl";
        szPModel = "models/solidgear/wp_m32gl.mdl";
        szWModel = "models/solidgear/wp_m32gl.mdl";

        szShellModel = "";

        iMaxAmmo = 30;
        iDefaultAmmo = 40;
        iSlot = 3;
        iPosition = 20;

        flDeployTime = 0.8f;
        flPrimeFireTime = 0.7f;
        flSecconaryFireTime = 0.5f;

        szWeaponAnimeExt = "gauss";

        iDeployAnime = 5;
        iReloadAnime = 3;
        aryFireAnime = {1, 2};
        aryIdleAnime = {0};

        szFireSound = "weapons/solidgear/m32gl_shot.wav";

        flBulletSpeed = 1200;
        flDamage = g_WeaponDMG.FG;
        vecPunchX = Vector2D(-4,5);
        vecPunchY = Vector2D(-1,1);
        vecEjectOffset = Vector(0,2,0);
   }
   void Precache() override{
      g_SoundSystem.PrecacheSound( "weapons/solidgear/m32gl_shot.wav" );
      g_Game.PrecacheGeneric( "sound/weapons/solidgear/m32gl_shot.wav" );
      
      g_Game.PrecacheModel("sprites/solidgear/hud_m32gl.spr");
      // g_Game.PrecacheModel("sprites/solidgear/bullet_m32gl.spr");

      g_Game.PrecacheGeneric( "sprites/solidgear/hud_m32gl.spr" );    
      // g_Game.PrecacheGeneric( "sprites/solidgear/bullet_m32gl.spr" );    

      g_Game.PrecacheGeneric( "sprites/solidgear/weapon_m32gl.txt" );

      CBaseContraWeapon::Precache();
   }
   void CreateProj(int pellet = 1) override{
      /* CProjBullet@ pBullet = cast<CProjBullet@>(CastToScriptClass(g_EntityFuncs.CreateEntity( BULLET_REGISTERNAME, null,  false)));
      g_EntityFuncs.SetOrigin( pBullet.self, m_pPlayer.GetGunPosition() );
      @pBullet.pev.owner = @m_pPlayer.edict();
      pBullet.pev.dmg = flDamage;
      pBullet.pev.model = "sprites/solidgear/bullet_m32gl.spr";
      //爆炸SPR, 爆炸音效, SPR缩放, 伤害范围, 伤害
      pBullet.pev.velocity = m_pPlayer.GetAutoaimVector( AUTOAIM_5DEGREES ) * flBulletSpeed;
      pBullet.pev.angles = Math.VecToAngles( pBullet.pev.velocity );
      @pBullet.pTouchFunc = @ProjBulletTouch::ExplodeTouch;
      g_EntityFuncs.DispatchSpawn( pBullet.self.edict() ); */

      //直接使用原版榴弹
      CGrenade@ pGrenade = g_EntityFuncs.ShootContact( m_pPlayer.pev, m_pPlayer.GetGunPosition(), m_pPlayer.GetAutoaimVector( AUTOAIM_5DEGREES ) * flBulletSpeed );
      pGrenade.pev.dmg = flDamage;
   }
 }
