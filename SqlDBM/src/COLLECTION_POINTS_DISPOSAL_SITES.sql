-- ******************** SqlDBM: Microsoft SQL Server ********************
-- ************************* Generated by SqlDBM ************************


-- ************************************** COLLECTION_POINTS_DISPOSAL_SITES
CREATE VIEW COLLECTION_POINTS_DISPOSAL_SITES as 

  select    t1.DispFacId from MART.COMRES_FACT t1 

            where  waste_Type in ('MSW','C&D','SPW') 

            and dispfacid is not null

            union 

  select    t1.DispFacId from MART.ROLLOFF_FACT t1 

            where  waste_Type in ('MSW','C&D','SPW') 

            and dispfacid is not null;
