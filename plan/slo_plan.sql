use database dwh_prod;
use schema aplsdb;



select  
--        floor(f.date_sid/100),
--        f.scenario,
--        f.version,
--        f.status,
        co.company_code, co.name,
--        pc.level03_code, pc.level03_name,
--        pc.level04_code, pc.level04_name,
        pc.level05_code, pc.level05_name,
--        pc.level06_code, pc.level06_name,
--        pc.level07_code, pc.level07_name,
--        pc.level08_code, pc.level08_name,
--        pc.profit_center_code, pc.profit_center_name,
--        pc.profit_center_sid,
        
        pr.level01_code, pr.level01_name,
        pr.level02_code, pr.level02_name,
--        pr.level03_code, pr.level03_name,
--        pr.level04_code, pr.level04_name,     
--        pr.product_code, pr.product_name_short,
--        pr.product_sid,

--        pca.attribute_name,
--        pca.attribute_value_string,
--        pca.eff_to_date_sid,
--        pca.vld_to_dt,

        sum(sales_line_qty),
        sum(sales_line_qty_kg),
        sum(net_sales_line_amt),
        sum(margin_line_amt)
        
from    f_sales_plan f
        inner join d_company co                 on f.company_sid = co.company_sid                 and co.company_code = '1000'
        inner join v_product_bi pr              on pr.product_sid = f.product_sid                 and pr.hierarchy_ext_refr = 'PR|SAP'
        inner join v_profit_center_bi pc        on f.profit_center_sid = pc.profit_center_sid     and pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS'              
--        left join d_profit_center_attribute pca on pc.profit_center_sid = pca.profit_center_sid        

                
where   1 = 1
and     f.date_sid between 20200601 and 20200631
--and     f.scenario = 'P'
and     f.scenario = 'FC'
--and     f.version = 1
and     f.version = 2
and     f.status = 'C'
and     f.is_own_usage = 0
and     pr.level01_code <> ('06') --('01', '02')
--and      pc.level05_code not in ('0P113', '0P162')
--and     pr.level02_code = '0508'
--and     pr.level03_code = '010202'
--and     pc.level05_code = '0P111'
--and     pc.level04_code = '0P14'
--and     pc.level07_code in ('0000101369', '0000101420')
--and     pc.profit_center_name in ('BS GOLO BRDO V BRDIH', 'BS LORMANJE AC - JUG')
--and     (pca.attribute_name in ('BS GEOGRAFSKO') or pca.attribute_name is null)
--and     (pca.attribute_name in ('LOKACIJA BS') or pca.attribute_name is null)
--and     pca.vld_to_dt = '9999-12-31'

group by
--        floor(f.date_sid/100),
--        f.scenario,
--        f.version,
--        f.status,
        co.company_code, co.name,
--        pc.level03_code, pc.level03_name,
--        pc.level04_code, pc.level04_name,
        pc.level05_code, pc.level05_name,
--        pc.level06_code, pc.level06_name,
--        pc.level07_code, pc.level07_name,
--        pc.level08_code, pc.level08_name,
--        pc.profit_center_code, pc.profit_center_name,
--        pc.profit_center_sid,
        
        pr.level01_code, pr.level01_name,
        pr.level02_code, pr.level02_name,
--        pr.level03_code, pr.level03_name,
--        pr.level04_code, pr.level04_name,     
--        pr.product_code, pr.product_name_short,
--        pr.product_sid,

--        pca.attribute_name,
--        pca.attribute_value_string,
--        pca.eff_to_date_sid,
--        pca.vld_to_dt,
         1


;
group by rollup(
--        floor(f.date_sid/100),
--        f.scenario,
--        f.version,
--        f.status,
        co.company_code, co.name,
--        pc.level03_code, pc.level03_name,
--        pc.level04_code, pc.level04_name,
--        pc.level05_code, pc.level05_name,
--        pc.level06_code, pc.level06_name,
--        pc.level07_code, pc.level07_name,
--        pc.level08_code, pc.level08_name,
--        pc.profit_center_code, pc.profit_center_name,
--        pc.profit_center_sid,
        
        pr.level01_code, pr.level01_name,
--        pr.level02_code, pr.level02_name,
--        pr.level03_code, pr.level03_name,
--        pr.level04_code, pr.level04_name,     
--        pr.product_code, pr.product_name_short,
--        pr.product_sid,

--        pca.attribute_name,
--        pca.attribute_value_string,
--        pca.eff_to_date_sid,
--        pca.vld_to_dt,
        1)        

--having count(*) > 1
        
order by 1, 2, 3, 4--, 5, 7      





