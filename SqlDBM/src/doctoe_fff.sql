-- ******************** SqlDBM: Microsoft SQL Server ********************
-- ************************* Generated by SqlDBM ************************


-- ************************************** doctoe_fff
CREATE OR REPLACE VIEW doctoe_fff as 
  select name, dep_title
  from jofmi_ds emp JOIN jofmi_dep dep
  on emp.dep_id = dep.id
  where emp.title = 'doctor';
