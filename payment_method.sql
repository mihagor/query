use database dwh_prod;
use schema aplsdb;


select         
      --        f.accounting_date_sid, 
        pc.level03_code, pc.level03_name,
--        pc.level04_code, pc.level04_name,
--        pc.level05_code, pc.level05_name,
--        pc.level06_code, pc.level06_name,
--        pc.level07_code, pc.level07_name,
--        pc.level08_code, pc.level08_name,
--        pc.profit_center_code, pc.profit_center_name,

        p.level01_code, p.level01_name,
--        p.level02_code, p.level02_name,
--        p.level03_code, p.level03_name,
--        p.level04_code, p.level04_name,     
--        p.product_code,                   

--        pca.attribute_name,
--        pca.attribute_value_string,

--       f.net_sales_line_amt
        
        case 
        when pmh.LEVEL02_CODE = 'GOTOVINA'                      then pmh.LEVEL02_CODE
        when pmh.LEVEL03_CODE = 'PETROL KLUB PLAÈILNA KARTICA'  then pmh.LEVEL03_CODE
        when pmh.LEVEL04_CODE = 'BANÈNE KARTICE'                then pmh.LEVEL04_CODE
        when pmh.LEVEL04_CODE = 'PETROLOVE POSLOVNE KARTICE'    then pmh.LEVEL04_CODE
        when pmh.LEVEL04_CODE = 'TUJE KAMIONSKE KARTICE'        then pmh.LEVEL04_CODE
        else 'OSTALO' end as payment_method,
        
        
        pmh.level02_code, 
        pmh.level03_code, 
        pmh.level04_code, 
        pmh.level05_code,

        sum(sales_line_qty),
        sum(sales_line_qty_kg),
        sum(net_sales_line_amt),
        sum(net_margin_line_amt)
      
      
from    f_sales_all_daily f
        inner join v_profit_center_bi pc                on f.sales_point_sid = pc.profit_center_sid     and pc.hierarchy_ext_refr = 'PC|PIS'  
        inner join v_product_bi p                       on f.product_sid = p.product_sid                and p.hierarchy_ext_refr = 'PR|SAP'
        inner join d_payment_method_hierarchy pmh       on f.payment_method_sid = pmh.payment_method_sid

        
where   f.accounting_date_sid between 20200101 and 20200126
and     is_own_usage = 0
and     pc.level03_code in ('4802', '4803')
--and     pc.level05_code = '4831'

group by
--        f.accounting_date_sid, 
        pc.level03_code, pc.level03_name,
--        pc.level04_code, pc.level04_name,
--        pc.level05_code, pc.level05_name,
--        pc.level06_code, pc.level06_name,
--        pc.level07_code, pc.level07_name,
--        pc.level08_code, pc.level08_name,
--        pc.profit_center_code, pc.profit_center_name,

        p.level01_code, p.level01_name,
--        p.level02_code, p.level02_name,
--        p.level03_code, p.level03_name,
--        p.level04_code, p.level04_name,     
--        p.product_code,                   

--        pca.attribute_name,
--        pca.attribute_value_string,

--       f.net_sales_line_amt


        payment_method,

        pmh.level02_code, 
        pmh.level03_code, 
        pmh.level04_code, 
        pmh.level05_code,
        1
