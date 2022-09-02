@AbapCatalog.sqlViewName: 'ZC111CDS0003_V'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[C1] Fake Standard Table'
define view ZC111CDS0003 as select from ztc1110001 
{
   bukrs,
   belnr,
   gjahr,
   buzei,
   bschl
} 
    
