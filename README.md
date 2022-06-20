# AliasUtils
 some utility for alias


## affect

Take an entity and use alias name to affect new values. There is two way

### modify the linked (leaf) entity attribute

taking an entity with an alias named "anAlias", we set "newValue" as new value

```4d
$modifiedEntity:=aliasAffectValue($entity; "anAlias"; "newValue")
```

the modified entity is returned, so do not forget to save it if not null

```4d
If($modifiedEntity#Null)
  $status:=modifiedEntity.save()
End if
```

then to see immediately the change thourght the alias you need to reload the entity
```4d
$entity.reload()
ASSERT($entity.anAlias="newValue")
```

### change the entity linked

now we look for an entity with "valueToLookFor" as value of alias last path component

```4d
$modifiedEntity:=aliasLinkByValue($entity; "anAlias"; "valueToLookFor")
```

if no entity with "valueToLookFor" as value, the alias will point on undefined value (ie. the last link will be broken)
