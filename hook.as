HookReturnCode EntityCreated( CBaseEntity@ pEntity ){
    if(pEntity is null)
        return HOOK_CONTINUE;
    if(pEntity.IsMonster())
        aryMonsterList.insertLast(EHandle(@pEntity));
    return HOOK_CONTINUE;
}