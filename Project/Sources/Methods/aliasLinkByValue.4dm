//%attributes = {}
#DECLARE($entity : 4D:C1709.Entity; $aliasName : Text; $value : Variant)->$modifiedEntity : 4D:C1709.Entity
// change link according to first item that match value and alias last past property

var $path; $lastPath; $linkPath : Text
$path:=$entity.getDataClass()[$aliasName].path

var $paths : Collection
$paths:=Split string:C1554($path; ".")

$modifiedEntity:=$entity

$lastPath:=$paths.pop()
$linkPath:=$paths.pop()

For each ($path; $paths) Until ($modifiedEntity=Null:C1517)
	$modifiedEntity:=$modifiedEntity[$path]
End for each 

If ($modifiedEntity#Null:C1517)
	
	$modifiedEntity[$linkPath]:=$modifiedEntity.getDataClass().getDataStore()[$modifiedEntity.getDataClass()[$linkPath].relatedDataClass]\
		.query($lastPath+" = :1"; $value).first()
	
End if 