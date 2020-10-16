use database dwh_prod;
use schema aplsdb;

select   
--        *
--        f.accounting_date_sid, 
        pc.level03_code, pc.level03_name,
--        pc.level04_code, pc.level04_name,
--        pc.level05_code, pc.level05_name,
--        pc.level06_code, pc.level06_name,
--        pc.level07_code, pc.level07_name,
--        pc.level08_code, pc.level08_name,

        p.level01_code, p.level01_name,
--        p.level02_code, p.level02_name,
--        p.level03_code, p.level03_name,
--        p.level04_code, p.level04_name,     
--        p.product_code, p.product_name_short,                   

--        pca.attribute_name,
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
        sum(sales_line_qty_l),
        sum(net_sales_line_amt),
        sum(net_margin_line_amt)
        
        
from    f_sales_all_daily f
        inner join d_company co                         on f.company_sid = co.company_sid               and co.company_code = '812892'
        inner join v_profit_center_bi pc                on f.sales_point_sid = pc.profit_center_sid     and pc.hierarchy_ext_refr = 'PC|PIS' 
        inner join v_product_bi p                       on f.product_sid = p.product_sid                and p.hierarchy_ext_refr = 'PR|SAP'
--        left join d_profit_center_attribute pca         on pc.profit_center_sid = pca.profit_center_sid        
--        inner join d_payment_method_hierarchy pmh       on f.payment_method_sid = pmh.payment_method_sid
--        inner join d_card cd                            on f.payment_card_sid = cd.card_sid


where   accounting_date_sid between 20200301 and 20200322
and     f.is_own_usage = 0
and     p.level01_code <> ('06')
--and     p.level02_code = '0102'
and     pc.level03_code in ('6801') --, '6802', 
--and     pc.level04_code = '6803' 
--and     p.level01_code = '03'


--and     (pca.attribute_name in ('BS GEOGRAFSKO', 'LOKACIJA BS') or pca.attribute_name is null) --, 'LOKACIJA BS',
--and     (pca.vld_to_dt = '9999-12-31' or pca.vld_to_dt is null)
--and     (pca.eff_to_date_sid = 99991231 or pca.eff_to_date_sid is null)



group by
--        f.accounting_date_sid, 
        pc.level03_code, pc.level03_name,
--        pc.level04_code, pc.level04_name,
--        pc.level05_code, pc.level05_name,
--        pc.level06_code, pc.level06_name,
--        pc.level07_code, pc.level07_name,
--        pc.level08_code, pc.level08_name,

        p.level01_code, p.level01_name,
--        p.level02_code, p.level02_name,
--        p.level03_code, p.level03_name,
--        p.level04_code, p.level04_name,     
--        p.product_code, p.product_name_short,                   

--        pca.attribute_name,
--        pca.attribute_value_string,
--        pca.eff_to_date_sid,
--        pca.vld_to_dt,
--        
--        payment_method,
        
        1

order by 1, 2, 3, 4, 5, 6, 7, 8--, 9


