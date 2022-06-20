//%attributes = {}

// Setup entities data
ds:C1482.TestAlias.all().drop()

var $entity; $modified : cs:C1710.TestAliasEntity

$entity:=ds:C1482.TestAlias.new()
$entity.name:="a"
$entity.save()

$entity:=ds:C1482.TestAlias.new()
$entity.name:="b"
$entity.recu:=ds:C1482.TestAlias.query("name = :1"; "a").first()
$entity.save()

ASSERT:C1129($entity.aliasRecuName="a")

$entity:=ds:C1482.TestAlias.new()
$entity.name:="c"
$entity.recu:=ds:C1482.TestAlias.query("name = :1"; "b").first()
$entity.save()

ASSERT:C1129($entity.aliasRecuName="b")
ASSERT:C1129($entity.aliasRecuRecuName="a")

// tips: entity is c (linked to b, linked to a)

// test affect values

$modified:=aliasAffectValue($entity; "aliasRecuName"; "d")
ASSERT:C1129($entity.aliasRecuName="b")
$modified.save()
$entity.reload()
ASSERT:C1129($entity.aliasRecuName="d")


$modified:=aliasAffectValue($entity; "aliasRecuRecuName"; "e")
ASSERT:C1129($entity.aliasRecuRecuName="a")
$modified.save()
$entity.reload()
ASSERT:C1129($entity.aliasRecuRecuName="e")

// tips: entity is c (linked to d(b), linked to e(a))

// test affect link 

$entity:=$modified  // a(e) 
ASSERT:C1129($entity.recu=Null:C1517)
$modified:=aliasLinkByValue($entity; "aliasRecuName"; "c")
//ASSERT($entity.recu=Null) // seems to be already affected because one level
$modified.save()
$entity.reload()
ASSERT:C1129($entity.recu#Null:C1517)
ASSERT:C1129($entity.recu.name="c")

$modified:=aliasLinkByValue($entity; "aliasRecuName"; "unknown")
//ASSERT($entity.recu#Null) // seems to be already affected because one level
$modified.save()
$entity.reload()
ASSERT:C1129($entity.recu=Null:C1517)


// Nothing must happen if one intermediate do not exist
$modified:=aliasLinkByValue($entity; "aliasRecuRecuName"; "b")
ASSERT:C1129($modified=Null:C1517)
$entity.reload()
ASSERT:C1129($entity.recu=Null:C1517)
ASSERT:C1129($entity.recu.recu=Null:C1517)

$modified:=aliasLinkByValue($entity; "aliasRecuName"; "c")
$modified.save()
$entity.reload()
ASSERT:C1129($entity.recu.recu.name="d")  // a(e)->c->d(b)
// set unknown
$modified:=aliasLinkByValue($entity; "aliasRecuRecuName"; "unknown")
$modified.save()
$entity.reload()
ASSERT:C1129($entity.recu.recu=Null:C1517)
// set d
$modified:=aliasLinkByValue($entity; "aliasRecuRecuName"; "d")
$modified.save()
$entity.reload()
ASSERT:C1129($entity.recu.recu.name="d")


// after test clean
ds:C1482.TestAlias.all().drop()