use database dwh_prod;
use schema aplsdb;



select  
--        f.accounting_date_sid, 
--        d.year,
--        d.month_id,
        case when co.company_code = '821071' then '3000' else co.company_code end                               as company_code,
        case when co.company_code = '821071' then 'Petrol d.o.o., Zagreb' else co.name end                      as company_name,
        
--        case    when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and pc.level05_code in ('0P111')                  then pc.level05_code
--                when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('4803', '6801', '3203', '6901')   then pc.level03_code
--                else 'N/A'
--                end  as mp_code,
--
--        case    when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and pc.level05_code in ('0P111')                  then pc.level05_name                     
--                when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('4803', '6801', '3203', '6901')   then pc.level03_name
--                else 'N/A'
--                end as mp_name,
--        pc.level01_code, pc.level01_name,
--        pc.level02_code, pc.level02_name,
--        pc.level03_code, pc.level03_name,
--        pc.level04_code, pc.level04_name,
--        pc.level05_code, pc.level05_name,
--        pc.level06_code, pc.level06_name,
--        pc.level07_code, pc.level07_name,
--        pc.level08_code, pc.level08_name,
--        pc.profit_center_code, pc.profit_center_name,
        pr.level01_code, pr.level01_name,
        pr.level02_code, pr.level02_name,
        pr.level03_code, pr.level03_name,
--        pr.level04_code, pr.level04_name,
--        pr.level05_code, pr.level05_name,  
--        pr.level06_code, pr.level06_name,
--        pr.level07_code, pr.level07_name,
--        pr.level08_code, pr.level08_name,
--        pr.level09_code, pr.level09_name,
--        pr.product_code, pr.product_name_short,
--        cs.customer_code, 
--        cle.full_name,
--        pca.attribute_name,
--        pca.attribute_value_string,
--        pca.eff_to_date_sid,
--        pca.vld_to_dt,
--        f.is_own_usage, 
--        sum(cnt_dst_document_hdr_code) as stevilo_racunov,
        sum(sales_line_qty),
        sum(sales_line_qty_kg),
        sum(net_sales_line_amt /** exchange_rate_float*/),
        sum(net_margin_line_amt /** exchange_rate_float*/),
        1        
        
from    f_sales_all_daily                 f             
        inner join d_date                 d         on f.accounting_date_sid = d.date_sid
        inner join d_company              co        on f.company_sid = co.company_sid                                                                                                  
        inner join v_profit_center_bi     pc        on f.sales_point_sid = pc.profit_center_sid and pc.hierarchy_ext_refr in ('PC|STD_SAP_PIS') --, 'PC|PIS'                                                                                                      
        inner join v_product_bi           pr        on f.product_sid = pr.product_sid           and pr.hierarchy_ext_refr = 'PR|SAP'
--        inner join d_exchange_rate        ex        on f.currency_sid = ex.currency_from_sid 
--                                                    and f.country_sid = ex.country_sid                
--                                                    and accounting_date_sid = to_number(to_char(eff_to_dt, 'yyyymmdd'))
--                                                    and exchange_rate_type_ext_refr = 'D'
--                                                    and ex.currency_to_ext_refr = 'EUR'                                                                                                                     
--        inner join d_customer             cs        on f.customer_sid = cs.customer_sid
--        inner join d_customer_core        cc        on cs.customer_core_sid = cc.customer_core_sid
--        inner join d_customer_le          cle       on cs.customer_le_sid = cle.customer_le_sid
--        left join d_profit_center_attribute pca     on pc.profit_center_sid = pca.profit_center_sid        
        
where   1 = 1
and     f.accounting_date_sid between 20200101 and 20200699                                     
and     f.is_own_usage = 0
and     pr.level01_code <> ('06')
--and     pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS'
--and     pc.hierarchy_ext_refr = 'PC|PIS'      
        
--and     pr.hierarchy_ext_refr = 'PR|PIS'      
--and     (pca.attribute_name in ('BS GEOGRAFSKO') or pca.attribute_name is null) and pca.vld_to_dt = '9999-12-31'
--and     mp_code <> 'N/A'
and

------------------------------------------------------------------------------------------------------

---- SI ------------------------------------------
(
(
        co.company_code = '1000'
and     pc.level05_code in (
                            '0P111'  -- mp    bs
--                            '0P114', -- vp    izredna prodaja
--                            '0P115', -- vp    skladišèenje
--                            '0P116', -- vp    centralna
--                            '0P117', -- vp    klasièna
--                            '0P118'  -- vp    aeroservisi
--                            '0P112', -- other hopin
--                            '0P119', -- other elektromobilnost
--                            '0P11A', -- other er za dom in mpo
--                            '0P11B'  -- other eshop  
--                            '0P113'  -- izvoz      
                            )
--and     pc.level07_code in ('0000101101') -- Primer BS
and     pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS'
)
--
------ HR ------------------------------------------
--or (
--        co.company_code = '3000'
--and     pc.level05_code in (
--                            '0P111'  -- mp    bs
----                            '0P114', -- vp    izredna prodaja
----                            '0P115', -- vp    skladišèenje
----                            '0P116', -- vp    centralna
----                            '0P117', -- vp    klasièna
----                            '0P118'  -- vp    aeroservisi
----                            '0P112', -- other hopin
----                            '0P119', -- other elektromobilnost
----                            '0P11A', -- other er za dom in mpo
----                            '0P11B'  -- other eshop  
----                            '0P113'  -- izvoz      
--                            )
----and     pc.level07_code in ('0000301203') -- Primer BS
--and     pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS'
--)
--
------ BA ------------------------------------------
--or (
--        co.company_code = '812820'
--and     pc.level03_code in (
--                            '4803' -- mp
----                            '4802' -- vp
--                           ) 
----and     pc.level05_code in ('5507') -- Primer BS
--and     pc.hierarchy_ext_refr = 'PC|PIS'
--)
--
------ SRB ------------------------------------------
--or (
--        co.company_code = '812892'      
--and     pc.level03_code in (
--                            '6801' -- mp
----                            '6802' -- vp
--                           ) 
----and     pc.level04_code in ('6826') -- Primer BS   
--and     pc.hierarchy_ext_refr = 'PC|PIS'
--)
--                       
------ CG ------------------------------------------
--or (
--        co.company_code = '812968'      
--and     pc.level03_code in (
--                            '3203' -- mp
----                            '3202' -- vp
--                           ) 
----and     pc.level04_code in ('3227') -- Primer BS
--and     pc.hierarchy_ext_refr = 'PC|PIS'
--)
--
------ XK ------------------------------------------
--or (
--        co.company_code = '812969'     
--and     pc.level03_code in (
--                            '6901' -- mp
----                            '6902' -- vp
--                           ) 
----and     pc.level04_code in ('6906') -- Primer BS
--and     pc.hierarchy_ext_refr = 'PC|PIS'
--)
--
--------------------------------------------------------------------------------------------------------
)


group by
--        f.accounting_date_sid, 
--        d.year,
--        d.month_id,
        case when co.company_code = '821071' then '3000' else co.company_code end,
        case when co.company_code = '821071' then 'Petrol d.o.o., Zagreb' else co.name end,
        
--        case    when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and pc.level05_code in ('0P111')                  then pc.level05_code
--                when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('4803', '6801', '3203', '6901')   then pc.level03_code
--                else 'N/A'
--                end,
--
--        case    when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and pc.level05_code in ('0P111')                  then pc.level05_name                     
--                when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('4803', '6801', '3203', '6901')   then pc.level03_name
--                else 'N/A'
--                end,
--        pc.level01_code, pc.level01_name,
--        pc.level02_code, pc.level02_name,
--        pc.level03_code, pc.level03_name,
--        pc.level04_code, pc.level04_name,
--        pc.level05_code, pc.level05_name,
--        pc.level06_code, pc.level06_name,
--        pc.level07_code, pc.level07_name,
--        pc.level08_code, pc.level08_name,
--        pc.profit_center_code, pc.profit_center_name,
        pr.level01_code, pr.level01_name,
        pr.level02_code, pr.level02_name,
        pr.level03_code, pr.level03_name,
--        pr.level04_code, pr.level04_name,
--        pr.level05_code, pr.level05_name,  
--        pr.level06_code, pr.level06_name,
--        pr.level07_code, pr.level07_name,
--        pr.level08_code, pr.level08_name,
--        pr.level09_code, pr.level09_name,
--        pr.product_code, pr.product_name_short,
--        cs.customer_code, 
--        cle.full_name,
--        pca.attribute_name,
--        pca.attribute_value_string,
--        pca.eff_to_date_sid,
--        pca.vld_to_dt,
--        f.is_own_usage, 
        1

order by 1, 2, 3, 4, 5--, 6--, 7, 8, 9



