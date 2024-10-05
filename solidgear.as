#include "utility"
#include "monsterdeath"
#include "hook"
#include "dynamicdifficult"

#include "entity/info_weaponflag"
#include "entity/func_noprojclip"
#include "entity/weaponballoon"
#include "entity/func_tank_custom"
#include "entity/trigger_changesky2"

#include "proj/proj_bullet"

#include "weapon/weaponbase"
#include "weapon/weapon_556ar"
#include "weapon/weapon_m32gl"
#include "weapon/weapon_evosmg"
#include "weapon/weapon_sho3"
#include "weapon/weapon_gaussrifle"

#include "point_checkpoint"

void PluginInit(){
    g_Module.ScriptInfo.SetAuthor( "Dr.Abc & NoobLCH" );
    g_Module.ScriptInfo.SetContactInfo( "BDSC Server" );
}

void MapInit(){
    g_CustomEntityFuncs.RegisterCustomEntity( "CChangeSky", "trigger_changesky2" );
    g_CustomEntityFuncs.RegisterCustomEntity( "CNoProjClip", "func_noprojclip" );
    g_CustomEntityFuncs.RegisterCustomEntity( "CWeaponFlag", WEAPONFLAG_REGISTERNAME );
    g_CustomEntityFuncs.RegisterCustomEntity( "CProjBullet", BULLET_REGISTERNAME );
    g_CustomEntityFuncs.RegisterCustomEntity( "CWeaponBalloon", "weaponballoon" );
    g_Game.PrecacheOther(BULLET_REGISTERNAME);
    g_CustomEntityFuncs.RegisterCustomEntity( "CustomTank::CFuncTankProj", "func_tanksg" );
    // RegisterPointCheckPointEntity();

    PrecacheAllMonsterDeath();

    g_Hooks.RegisterHook( Hooks::Game::EntityCreated, @EntityCreated );
    g_Hooks.RegisterHook( Hooks::Player::ClientPutInServer, @ClientPutInServer );
    g_Scheduler.SetInterval("SearchAndDestoryMonster", 0.01f, g_Scheduler.REPEAT_INFINITE_TIMES);
    
    g_CustomEntityFuncs.RegisterCustomEntity( "weapon_556ar", "weapon_556ar" );
    g_ItemRegistry.RegisterWeapon( "weapon_556ar", "solidgear", "556");
    g_CustomEntityFuncs.RegisterCustomEntity( "weapon_m32gl", "weapon_m32gl" );
    g_ItemRegistry.RegisterWeapon( "weapon_m32gl", "solidgear", "ARgrenades");
    g_CustomEntityFuncs.RegisterCustomEntity( "weapon_evosmg", "weapon_evosmg" );
    g_ItemRegistry.RegisterWeapon( "weapon_evosmg", "solidgear", "9mm");
    g_CustomEntityFuncs.RegisterCustomEntity( "weapon_sho3", "weapon_sho3" );
    g_ItemRegistry.RegisterWeapon( "weapon_sho3", "solidgear", "buckshot");
    g_CustomEntityFuncs.RegisterCustomEntity( "weapon_gaussrifle", "weapon_gaussrifle" );
    g_ItemRegistry.RegisterWeapon( "weapon_gaussrifle", "solidgear", "uranium");

    // g_SurvivalMode.EnableMapSupport();
}

void MapStart(){
    InitMonsterList();
}
