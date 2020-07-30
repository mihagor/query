use database dwh_prod;
use schema aplsdb;



select  
        f.accounting_date_sid, 
        pc.level03_code, pc.level03_name,
        pc.level04_code, pc.level04_name,
        pc.level05_code, pc.level05_name,
--        pc.level06_code, pc.level06_name,
--        pc.level07_code, pc.level07_name,
--        pc.level08_code, pc.level08_name,

        p.level01_code, p.level01_name,
--        p.level02_code, p.level02_name,
--        p.level03_code, p.level03_name,
--        p.level04_code, p.level04_name,     
--        p.product_code,                   
--        pca.*,
        pca.attribute_name,
        pca.attribute_value_string,

--       f.net_sales_line_amt
--        sum(sales_line_qty),
        sum(net_sales_line_amt)
        
        
from    f_sales_all_daily f
        inner join d_company co                 on f.company_sid = co.company_sid               and co.company_code = '812820'
        inner join v_profit_center_bi pc        on f.sales_point_sid = pc.profit_center_sid     and pc.hierarchy_ext_refr = 'PC|PIS' 
        inner join v_product_bi p               on f.product_sid = p.product_sid                and p.hierarchy_ext_refr = 'PR|SAP'
        left join d_profit_center_attribute pca on pc.profit_center_sid = pca.profit_center_sid        
        
where   accounting_date_sid between 20191201 and 20191201
and     f.is_own_usage = 0
--and     p.level01_code in ('01', '02')
--and     p.level02_code = '0507'
and     pc.level03_code in ('4802', '4803')
and     pc.level05_code = '4825'
and     pca.attribute_name in ('BS GEOGRAFSKO', 'BS po regijah', 'LOKACIJA BS', 'INŠTRUKTORJI BiH')
and     pca.eff_to_date_sid = 99991231


group by
        f.accounting_date_sid,
        pc.level03_code, pc.level03_name,
        pc.level04_code, pc.level04_name,
        pc.level05_code, pc.level05_name,
        pc.level06_code, pc.level06_name,
--        pc.level07_code, pc.level07_name,        
--        pc.level08_code, pc.level08_name,
        
        p.level01_code, p.level01_name,
--        p.level02_code, p.level02_name,        
--        p.level03_code, p.level03_name,
--        p.level04_code, p.level04_name,  
--        p.product_code,

        pca.attribute_name,
        pca.attribute_value_string,
        1

order by 1, 3, 5, 7, 9


