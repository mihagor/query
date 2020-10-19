with pc as (
select   
         pc.level03_code as pc_level03_code, pc.level03_name as pc_level03_name,
         pc.level04_code as pc_level04_code, pc.level04_name as pc_level04_name,
         pc.level05_code as pc_level05_code, pc.level05_name as pc_level05_name,
         pc.level06_code as pc_level06_code, pc.level06_name as pc_level06_name,
         pc.level07_code as pc_level07_code, pc.level07_name as pc_level07_name,
         max(case when attribute_name in ('AKTIVNOST NA BS') then attribute_value_string end)                                                   as aktivnost,
         max(case when attribute_name in ('FRESH', 'FRESH - MINI', 'DOPEKA') and attribute_value_string in ('X') then attribute_name end)       as fresh,
         max(case when attribute_name in ('AVTOPRALNICE NA BS') and attribute_value_string in ('AVTOMATSKA + ROÈNA AP', 'AVTOMATSKA AVTOPRALNICA', 'ROÈNA AVTOPRALNICA') then attribute_name end)   as avtopralnica,
         max(case when attribute_name in ('BAR') and attribute_value_string in ('X') then attribute_name end)                                           as bar,
--         attribute_name, attribute_value_string,
         1
from     dwh_prod.aplsdb.v_profit_center_bi       /*at (timestamp => to_timestamp_tz('2020-09-30 07:00:00'))*/ pc         
         inner join dwh_prod.aplsdb.d_company     /*at (timestamp => to_timestamp_tz('2020-09-30 07:00:00'))*/ co             on pc.company_sid = co.company_sid      
         inner join dwh_prod.aplsdb.d_profit_center_attribute                                                  pca            on pc.profit_center_sid = pca.profit_center_sid       and pca.eff_to_date_sid = '99991231'         

where    company_code = '1000'
and      pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS'
and      level04_code = '0P11'
and      level05_code in ('0P111', '0P112')
and      level06_code <> '0000101000'
and      attribute_name in ('FRESH', 'DOPEKA', 'FRESH - MINI', 'AKTIVNOST NA BS', 'AVTOPRALNICE NA BS', 'BAR', 'AKTIVNOST NA BS')
and      attribute_value_string in ('X', 'AVTOMATSKA + ROÈNA AP', 'AVTOMATSKA AVTOPRALNICA', 'ROÈNA AVTOPRALNICA', 'BS JE AKTIVEN')

group by
         pc.level03_code, pc.level03_name,
         pc.level04_code, pc.level04_name,
         pc.level05_code, pc.level05_name,
         pc.level06_code, pc.level06_name,
         pc.level07_code, pc.level07_name,
--         attribute_name, attribute_value_string,
         1

order by 1, 3, 5, 7, 9, 11  
)

select   
         pc_level05_name,
         count(fresh),
         count(avtopralnica),
         count(bar)

from     pc

group by pc_level05_name