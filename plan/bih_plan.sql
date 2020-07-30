use database dwh_prod;
use schema aplsdb;



select  
--        f.date_sid,
--        f.scenario,
--        f.version,
--        f.status,

        pc.level03_code, pc.level03_name,
--        pc.level04_code, pc.level04_name,
        pc.level05_code, pc.level05_name,
--        pc.level06_code, pc.level06_name,
--        pc.level07_code, pc.level07_name,
--        pc.level08_code, pc.level08_name,

        p.level01_code, p.level01_name,
--        p.level02_code, p.level02_name,
--        p.level03_code, p.level03_name,
--        p.level04_code, p.level04_name,     
--        p.product_code, p.product_name_short,                   

        pca.attribute_name,
--        pca.attribute_value_string,
--        pca.eff_to_date_sid,
--        pca.vld_to_dt,
        
--        case 
--        when pmh.LEVEL02_CODE = 'Gotovina'                      then pmh.LEVEL02_CODE
--        when pmh.LEVEL03_CODE = 'Petrol klub plaèilna kartica'  then pmh.LEVEL03_CODE
--        when pmh.LEVEL04_CODE = 'Banène kartice'                then pmh.LEVEL04_CODE
--        when pmh.LEVEL04_CODE = 'Petrolove poslovne kartice'    then pmh.LEVEL04_CODE
--        when pmh.LEVEL04_CODE = 'Tuje kamionske kartice'        then pmh.LEVEL04_CODE
--        else 'Ostalo' end as payment_method,


        sum(sales_line_qty),
        sum(sales_line_qty_kg),
        sum(net_sales_line_amt),
        sum(margin_line_amt)
        
from    f_sales_plan_daily f
        inner join v_product_bi p              on p.product_sid = f.product_sid                and p.hierarchy_ext_refr = 'PR|SAP'         
        inner join v_profit_center_bi pc        on f.profit_center_sid = pc.profit_center_sid   and pc.hierarchy_ext_refr = 'PC|PIS' 
        inner join d_company co                 on f.company_sid = co.company_sid               and co.company_code = '812820'
        left join d_profit_center_attribute pca         on pc.profit_center_sid = pca.profit_center_sid        
--        inner join d_payment_method_hierarchy pmh       on f.payment_method_sid = pmh.payment_method_sid


                
where   1 = 1
and     f.date_sid between 20200101 and 20200101
and     f.is_own_usage = 0
and     f.scenario = 'P'
and     f.version = 1

--and     p.level02_code = '0102'
and     pc.level03_code in ('4802', '4803')
--and     p.level05_code = '4825'

and     (pca.attribute_name in ('BS GEOGRAFSKO', 'LOKACIJA BS', 'INŠTRUKTORJI BiH') or pca.attribute_name is null) --'BS GEOGRAFSKO', 'LOKACIJA BS', 'INŠTRUKTORJI BiH'
and     (pca.vld_to_dt = '9999-12-31' or pca.vld_to_dt is null)
and     (pca.eff_to_date_sid = 99991231 or pca.eff_to_date_sid is null)


group by
--        f.date_sid,
--        f.scenario,
--        f.version,
--        f.status,

        pc.level03_code, pc.level03_name,
--        pc.level04_code, pc.level04_name,
        pc.level05_code, pc.level05_name,
--        pc.level06_code, pc.level06_name,
--        pc.level07_code, pc.level07_name,
--        pc.level08_code, pc.level08_name,

        p.level01_code, p.level01_name,
--        p.level02_code, p.level02_name,
--        p.level03_code, p.level03_name,
--        p.level04_code, p.level04_name,     
--        p.product_code, p.product_name_short,                   

        pca.attribute_name,
--        pca.attribute_value_string,
--        pca.eff_to_date_sid,
--        pca.vld_to_dt,
        
--        payment_method,
        
        1

order by 1, 2, 3, 4, 5, 6, 7--, 8, 9   





