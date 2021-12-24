class trigger_rocketreplace : ScriptBaseEntity{
    private float flTankBulletSpeed = 1000;
    void Spawn(){
        Precache();
        BaseClass.Spawn();
        SetThink(ThinkFunction(this.Think));
        self.pev.nextthink = g_Engine.time + 0.1;
    }
    void Precache(){
        //1
        //机械-小型炮塔 (小黄球)
        g_Game.PrecacheModel("sprites/svencontra2/bullet_tta.spr");
        g_Game.PrecacheGeneric("sprites/svencontra2/bullet_tta.spr");	
        //2
        //机械-中型炮塔 (红球)
        g_Game.PrecacheModel("sprites/svencontra2/bullet_ttb.spr");
        g_Game.PrecacheGeneric("sprites/svencontra2/bullet_ttb.spr");	
        //3
        //机械-重型炮塔A型 (灰蓝球)
        g_Game.PrecacheModel("sprites/svencontra2/bullet_ttc.spr");
        g_Game.PrecacheGeneric("sprites/svencontra2/bullet_ttc.spr");	
        //4
        //机械-重型炮塔B型 (黄球)
        g_Game.PrecacheModel("sprites/svencontra2/bullet_ttd.spr");
        g_Game.PrecacheGeneric("sprites/svencontra2/bullet_ttd.spr");	
        //5
        //异形-中型炮塔 (绿球)
        g_Game.PrecacheModel("sprites/svencontra2/bullet_tte.spr");
        g_Game.PrecacheGeneric("sprites/svencontra2/bullet_tte.spr");
        //6
        //异形-小型炮塔 (小蓝球)
        g_Game.PrecacheModel("sprites/svencontra2/bullet_ttf.spr");
        g_Game.PrecacheGeneric("sprites/svencontra2/bullet_ttf.spr");
        //7
        //异形-小型炮塔 (小红球)
        g_Game.PrecacheModel("sprites/svencontra2/bullet_ttg.spr");
        g_Game.PrecacheGeneric("sprites/svencontra2/bullet_ttg.spr");
        //8
        //异形-大型炮塔 (紫球)
        g_Game.PrecacheModel("sprites/svencontra2/bullet_tth.spr");
        g_Game.PrecacheGeneric("sprites/svencontra2/bullet_tth.spr");
    }
    //EntityCreate无法捕捉到Bolt和rocket，只能暴力遍历
    void Think(){
        CBaseEntity@ pRPG = null;
        while((@pRPG = g_EntityFuncs.FindEntityByClassname(pRPG, "rpg_rocket")) !is null){
            if(pRPG.pev.owner !is null && pRPG.pev.owner.vars.classname == "func_tankrocket"){
                Vector vecVelocity;
                edict_t@ pOwner = pRPG.pev.owner;
                g_EngineFuncs.AngleVectors(pOwner.vars.angles, vecVelocity, void, void);
                Vector vecOrigin = pRPG.pev.origin;
                float flSpeed = dicTankRocketExt.exists(pRPG.pev.owner.vars.targetname) ? 
                    cast<CTankRocketExtItem@>(dicTankRocketExt[pRPG.pev.owner.vars.targetname]).flBulletSpeed : flTankBulletSpeed;
                string szBulletSpr = "sprites/svencontra2/bullet_tta.spr";
                switch(pRPG.pev.owner.vars.weaponanim){
                    case 1: szBulletSpr = "sprites/svencontra2/bullet_tta.spr";break;
                    case 2: szBulletSpr = "sprites/svencontra2/bullet_ttb.spr";break;
                    case 3: szBulletSpr = "sprites/svencontra2/bullet_ttc.spr";break;
                    case 4: szBulletSpr = "sprites/svencontra2/bullet_ttd.spr";break;
                    case 5: szBulletSpr = "sprites/svencontra2/bullet_tte.spr";break;
                    case 6: szBulletSpr = "sprites/svencontra2/bullet_ttf.spr";break;
                    case 7: szBulletSpr = "sprites/svencontra2/bullet_ttg.spr";break;
                    case 8: szBulletSpr = "sprites/svencontra2/bullet_tth.spr";break;
                    default:break;
                }
                g_EntityFuncs.Remove(@pRPG);
                CProjBullet@ pNew = ShootABullet(pOwner, vecOrigin, vecVelocity * flSpeed);
                pNew.pev.dmg = pOwner.vars.dmg;
                g_EntityFuncs.SetModel(pNew.self, szBulletSpr);
            }
        }
        self.pev.nextthink = g_Engine.time;
    }
}