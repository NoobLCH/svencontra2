#include "utility"
#include "monsterdeath"
#include "hook"

#include "entity/info_weaponflag"
#include "entity/func_noprojclip"
#include "entity/trigger_rocketreplace"
#include "entity/trigger_tankdefine"
#include "entity/weaponballoon"

#include "proj/proj_bullet"

#include "weapon/weaponbase"
#include "weapon/weapon_sc2ar"
#include "weapon/weapon_sc2fg"
#include "weapon/weapon_sc2mg"
#include "weapon/weapon_sc2sg"

#include "point_checkpoint"

void PluginInit(){
    g_Module.ScriptInfo.SetAuthor( "❤Dr.Abc Official❤" );
    g_Module.ScriptInfo.SetContactInfo( "❤Love you❤" );
}

void MapInit(){
    g_CustomEntityFuncs.RegisterCustomEntity( "CNoProjClip", "func_noprojclip" );
    g_CustomEntityFuncs.RegisterCustomEntity( "CWeaponFlag", WEAPONFLAG_REGISTERNAME );
    g_CustomEntityFuncs.RegisterCustomEntity( "CProjBullet", BULLET_REGISTERNAME );
    g_CustomEntityFuncs.RegisterCustomEntity( "CWeaponBalloon", "weaponballoon" );
    g_CustomEntityFuncs.RegisterCustomEntity( "trigger_tankdefine", "trigger_tankdefine" );
    g_CustomEntityFuncs.RegisterCustomEntity( "trigger_rocketreplace", "trigger_rocketreplace" );
    g_Game.PrecacheOther(BULLET_REGISTERNAME);
    g_Game.PrecacheOther("trigger_rocketreplace");
    RegisterPointCheckPointEntity();

    PrecacheAllMonsterDeath();

    g_Hooks.RegisterHook( Hooks::Game::EntityCreated, @EntityCreated );
    g_Scheduler.SetInterval("SearchAndDestoryMonster", 0.01f, g_Scheduler.REPEAT_INFINITE_TIMES);
    
    g_CustomEntityFuncs.RegisterCustomEntity( "weapon_sc2ar", "weapon_sc2ar" );
	g_ItemRegistry.RegisterWeapon( "weapon_sc2ar", "svencontra2", "9mm", "ARgrenades" );
    g_CustomEntityFuncs.RegisterCustomEntity( "weapon_sc2fg", "weapon_sc2fg" );
	g_ItemRegistry.RegisterWeapon( "weapon_sc2fg", "svencontra2", "rockets");
    g_CustomEntityFuncs.RegisterCustomEntity( "weapon_sc2mg", "weapon_sc2mg" );
	g_ItemRegistry.RegisterWeapon( "weapon_sc2mg", "svencontra2", "556");
    g_CustomEntityFuncs.RegisterCustomEntity( "weapon_sc2sg", "weapon_sc2sg" );
	g_ItemRegistry.RegisterWeapon( "weapon_sc2sg", "svencontra2", "buckshot");
}

void MapStart(){
    InitMonsterList();
    g_EntityFuncs.Create("trigger_rocketreplace", g_vecZero, g_vecZero, false);
}