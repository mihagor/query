use database dwh_prod;
use schema aplsdb;

select  
*
        
from    v_sales_all f
        inner join v_product_bi pr              on pr.product_sid = f.product_sid               
        inner join v_profit_center_bi pc        on f.sales_point_sid = pc.profit_center_sid     
        inner join d_company co                 on f.company_sid = co.company_sid               
                
where   1 = 1
and     f.is_own_usage = 0
and     f.accounting_date_sid between 20191001 and 20191031
and     pr.hierarchy_ext_refr = 'PR|SAP'
and     pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS'
--and     pc.hierarchy_ext_refr = 'PC|PIS'

and     pc.level05_code = '0P111' 
--and     pc.level03_code = '3602'
and     co.company_code = '1000'
--and     co.company_code = '821071'
and     pr.level03_code = '030701'
and     pr.product_code = '5722|GR'

group by
--        f.accounting_date_sid,
--        co.company_code,
        pr.product_code, pr.product_name_short, 
        pr.level01_code, pr.level01_name,
        pr.level02_code, pr.level02_name,
        pr.level03_code, pr.level03_name,    
        pc.level04_code, pc.level04_name,
        pc.level05_code, pc.level05_name,
--        pc.level06_code, pc.level06_name,
--        pc.level07_code, pc.level07_name,
        1        






