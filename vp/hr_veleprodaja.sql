use database dwh_prod;
use schema aplsdb;



select  
--        f.accounting_date_sid, 
--        d.year,
--        f.dokument,
--        f.source_module_code,
--        f.transaction_status_sid,
--        st.status_code,
        st.status_description,
--        pc.level03_code, pc.level03_name,
--        pc.level04_code, pc.level04_name,
        pc.level05_code, pc.level05_name,
        pc.level06_code, pc.level06_name,
--        pc.level07_code, pc.level07_name,
--        pc.level08_code, pc.level08_name,
--        pc.profit_center_code, pc.profit_center_name,
--        pc.profit_center_sid,
        
        pr.level01_code, pr.level01_name,
        pr.level02_code, pr.level02_name,
--        pr.level03_code, pr.level03_name,
--        pr.level04_code, pr.level04_name,
--        pr.level05_code, pr.level05_name,               
--        pr.product_code, pr.product_name_short,
--        pr.product_code_sap,
--        pr.product_sid,

--        pca.attribute_name,
--        pca.attribute_value_string,
--        pca.eff_to_date_sid,
--        pca.vld_to_dt,

        sum(sales_line_qty),
--        sum(sales_line_qty_kg),
        sum(net_sales_line_amt),
--        sum(net_sales_sap_line_amt),        
        sum(net_margin_line_amt),
        1        
        
from    f_sales_all_daily f
        inner join d_date d                     on f.accounting_date_sid = d.date_sid
        inner join d_company co                 on f.company_sid = co.company_sid               and co.company_code = '3000'
        inner join v_profit_center_bi pc        on f.sales_point_sid = pc.profit_center_sid     and pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' 
        inner join v_product_bi pr              on f.product_sid = pr.product_sid               and pr.hierarchy_ext_refr = 'PR|SAP'
        inner join d_status st                  on f.transaction_status_sid = st.status_sid
--        left join d_profit_center_attribute pca on pc.profit_center_sid = pca.profit_center_sid        
        
where   f.accounting_date_sid between 20200201 and 20200210
and     f.is_own_usage = 0
and     pr.level01_code <> ('06')
and     pr.level01_code in ('03')
--and     pr.level02_code = '0312'
--and     pr.level04_code = '3418|GR'
and     pc.level05_code in ('0P117') --'0P116', 



group by
--        f.accounting_date_sid,
--        d.year,
--        f.dokument,
--        f.source_module_code,
--        f.transaction_status_sid,
--        st.status_code,
        st.status_description,
--        pc.level03_code, pc.level03_name,
--        pc.level04_code, pc.level04_name,
        pc.level05_code, pc.level05_name,
        pc.level06_code, pc.level06_name,
--        pc.level07_code, pc.level07_name,        
--        pc.level08_code, pc.level08_name,
--        pc.profit_center_code, pc.profit_center_name,
--        pc.profit_center_sid,
        
        pr.level01_code, pr.level01_name,
        pr.level02_code, pr.level02_name,        
--        pr.level03_code, pr.level03_name,
--        pr.level04_code, pr.level04_name, 
--        pr.level05_code, pr.level05_name,  
--        pr.product_code, pr.product_name_short,
--        pr.product_code_sap,
--        pr.product_sid,

--        pca.attribute_name,
--        pca.attribute_value_string,
--        pca.eff_to_date_sid,
--        pca.vld_to_dt,
        1

--having count(pc.level07_code) over (partition by pc.level07_code) > 1
--having     cnt > 1

order by 1, 2, 3, 4, 5, 6, 7, 8, 9



