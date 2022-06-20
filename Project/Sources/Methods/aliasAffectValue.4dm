//%attributes = {}
#DECLARE($entity : 4D:C1709.Entity; $aliasName : Text; $value : Variant)->$modifiedEntity : 4D:C1709.Entity
// Change linked entity and return it

var $path; $lastPath : Text
$path:=$entity.getDataClass()[$aliasName].path

var $paths : Collection
$paths:=Split string:C1554($path; ".")

$modifiedEntity:=$entity

$lastPath:=$paths.pop()

For each ($path; $paths) Until ($modifiedEntity=Null:C1517)
	$modifiedEntity:=$modifiedEntity[$path]
End for each 

If ($modifiedEntity#Null:C1517)
	$modifiedEntity[$lastPath]:=$value
End if 