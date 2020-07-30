use database dwh_prod;
use schema aplsdb;


select  distinct 
        'BU' as version,
--        floor(f.date_sid/100) as month_id,
        level07_code,
        level07_name
        
        
--        case    when level04_code = '8940'                                      then level04_code
--                when level03_code in ('3602', '4803', '6801', '3203', '6901')   then level03_code
--                else 'N/A'
--                end as maloprodaja_code,
--        
--        case    when level04_code = '8940'                                      then level04_name
--                when level03_code in ('3602', '4803', '6801', '3203', '6901')   then level03_name
--                else 'N/A'
--                end as maloprodaja_name,
--
--        case    when level04_code = '8940' and level06_name like 'BS%' then level06_code 
--                when level03_code = '3602' and level05_name like 'PM%' then level05_code 
--                when level03_code = '4803' and level05_name like 'BS%' then level05_code 
--                when level03_code = '6801' and level04_name like 'BS%' then level04_code 
--                when level03_code = '3203' and level04_name like 'BS%' then level04_code 
--                when level03_code = '6901' and level04_name like 'PB%' then level04_code
--                else 'N/A' 
--                end as bs_code,
--                
--        case    when level04_code = '8940' and level06_name like 'BS%' then level06_name 
--                when level03_code = '3602' and level05_name like 'PM%' then level05_name 
--                when level03_code = '4803' and level05_name like 'BS%' then level05_name 
--                when level03_code = '6801' and level04_name like 'BS%' then level04_name 
--                when level03_code = '3203' and level04_name like 'BS%' then level04_name 
--                when level03_code = '6901' and level04_name like 'PB%' then level04_name
--                else 'N/A' 
--                end as bs_name

from    f_sales_plan f
        inner join d_company co                 on f.company_sid = co.company_sid   
        inner join v_profit_center_bi pc        on f.profit_center_sid = pc.profit_center_sid   and pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS'
        inner join d_date d                     on f.date_sid = d.date_sid

where   d.ext_refr between '2020-01-01' and '2020-12-31'  
and     f.is_own_usage = 0        
--and     bs_code <> 'N/A'
and     level05_code = '0P111' 



