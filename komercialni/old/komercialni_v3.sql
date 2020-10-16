use database dwh_prod; use schema aplsdb;


-- ############################################################## SALES ##############################################################
with sales as (
select 
--         *
         f.accounting_date_sid,
--         f.gm_indicator,
--         f.is_own_usage,
--         mdm_company_code_addn                                  as company_code,
--         mdm_name_addn                                          as company_name,        
         pc.level03_code as pc_level03_code, pc.level03_name as pc_level03_name,
         pc.level04_code as pc_level04_code, pc.level04_name as pc_level04_name,
         pc.level05_code as pc_level05_code, pc.level05_name as pc_level05_name,
         pc.level06_code as pc_level06_code, pc.level06_name as pc_level06_name,
         pc.level07_code as pc_level07_code, pc.level07_name as pc_level07_name,
--         case  when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and pc.level05_code in ('0P111')                  then pc.level05_code
--               when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS'                                                   then 'N/A'                     
--               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('4803', '6801', '3203', '6901')   then pc.level03_code
--               else 'N/A'
--               end  as mp_code,
--         
--         case  when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and pc.level05_code in ('0P111')                  then pc.level05_name                     
--               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('4803', '6801', '3203', '6901')   then pc.level03_name
--               else 'N/A'
--               end as mp_name,
--         
--         case  when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and pc.level05_code in ('0P111')                  then pc.level07_code
--               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('4803')                           then pc.level05_code
--               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('6801', '3203', '6901')           then pc.level04_code
--               else 'N/A'
--               end  as bs_code,
--         
--         case  when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and pc.level05_code in ('0P111')                  then pc.level07_name
--               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('4803')                           then pc.level05_name
--               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('6801', '3203', '6901')           then pc.level04_name
--               else 'N/A'
--               end  as bs_name,                                                                                    
         pr.level01_code as pr_level01_code, pr.level01_name as pr_level01_name,
         pr.level02_code as pr_level02_code, pr.level02_name as pr_level02_name,
--         pr.level03_code as pr_level03_code, pr.level03_name as pr_level03_name,
--         pr.level04_code as pr_level04_code, pr.level04_name as pr_level04_name,
--         pr.level05_code as pr_level05_code, pr.level05_name as pr_level05_name,
--         pr.level06_code as pr_level06_code, pr.level06_name as pr_level06_name,
--         pr.level07_code as pr_level07_code, pr.level07_name as pr_level07_name,
--         pr.product_code, pr.product_name_short,                                
--         sum(sales_line_qty)                                                                                as sales_line_qty,                      
--         sum(sales_line_qty_kg)                                                                             as sales_line_qty_kg,  
--         sum(sales_line_qty_l)                                                                              as sales_line_qty_l,                
--         sum(net_sales_line_amt)                                                                            as net_sales_line_amt,
         sum(net_margin_line_amt)                                                                           as net_margin_line_amt,        
--         sum(net_sales_line_amt * exchange_rate_float)                                                      as net_sales_line_amt_eur,
--         sum(net_margin_line_amt * exchange_rate_float)                                                     as net_margin_line_amt_eur,
--         sum(calculation_for_gm_amt)                                                                        as calculation_for_gm_amt,       
--         sum(calculation_for_gm_amt * exchange_rate_float)                                                  as calculation_for_gm_amt_eur,       
--         sum(net_sales_line_amt - calculation_for_gm_amt)                                                   as gross_margin,  
--         sum((net_sales_line_amt * exchange_rate_float) - (calculation_for_gm_amt * exchange_rate_float))   as gross_margin_eur,                          
         1        
       
from     f_sales_all_daily                   /*at (timestamp => to_timestamp_tz('2020-09-30 07:00:00'))*/ f 
--from     v_sales_all                       /*at (timestamp => to_timestamp_tz('2020-09-01 07:00:00'))*/ f 
         inner join d_date                   /*at (timestamp => to_timestamp_tz('2020-09-30 07:00:00'))*/ d          on f.accounting_date_sid = d.date_sid
         inner join d_company                /*at (timestamp => to_timestamp_tz('2020-09-30 07:00:00'))*/ co         on f.company_sid = co.company_sid               
         inner join v_profit_center_bi       /*at (timestamp => to_timestamp_tz('2020-09-30 07:00:00'))*/ pc         on f.sales_point_sid = pc.profit_center_sid  and pc.hierarchy_ext_refr in ('PC|PIS', 'PC|STD_SAP_PIS')
         inner join v_product_bi             /*at (timestamp => to_timestamp_tz('2020-09-30 07:00:00'))*/ pr         on f.product_sid = pr.product_sid            and pr.hierarchy_ext_refr = 'PR|SAP'
         inner join d_exchange_rate          /*at (timestamp => to_timestamp_tz('2020-09-01 07:00:00'))*/ ex         on f.currency_sid = ex.currency_from_sid     and f.country_sid = ex.country_sid                
                                                                                                                                                                  and f.accounting_date_sid = to_number(to_char(ex.eff_to_dt, 'yyyymmdd'))
                                                                                                                                                                  and ex.exchange_rate_type_ext_refr = 'D'
                                                                                                                                                                  and ex.currency_to_ext_refr = 'EUR'
where    1 = 1
and      f.accounting_date_sid between 20200101 and 20201008
and      f.is_own_usage = 0
and      f.gm_indicator = 1
and      pr.level01_code <> ('06') 
--and      pc.level03_code in ('4803')
and      pc.level05_code in ('0P111')
and      pr.level01_code in ('03')
--and      pr.level02_code in ('0306')
--and      pr.level03_code in ('030302')
--and      pr.level04_code in ('030302009')
--and      pr.level06_code = '7023|GR'
--and      pr.level07_code = '7107|GR'
and      co.company_code = '1000'
and      ((pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and co.company_code in ('1000', '3000', '821071')) or 
         (pc.hierarchy_ext_refr = 'PC|PIS' and co.company_code in ('812820', '812892', '812968', '812969')))

group by
         f.accounting_date_sid,
--         f.gm_indicator,
--         f.is_own_usage,
--         mdm_company_code_addn, 
--         mdm_name_addn,     
         pc.level03_code, pc.level03_name,
         pc.level04_code, pc.level04_name,
         pc.level05_code, pc.level05_name,
         pc.level06_code, pc.level06_name,
         pc.level07_code, pc.level07_name,   
--         case    when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and pc.level05_code in ('0P111')                  then pc.level05_code
--               when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS'                                                   then 'N/A'                     
--               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('4803', '6801', '3203', '6901')   then pc.level03_code
--               else 'N/A'
--               end,
--         
--         case    when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and pc.level05_code in ('0P111')                  then pc.level05_name                     
--               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('4803', '6801', '3203', '6901')   then pc.level03_name
--               else 'N/A'
--               end,
--         
--         case    when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and pc.level05_code in ('0P111')                  then pc.level07_code
--               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('4803')                           then pc.level05_code
--               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('6801', '3203', '6901')           then pc.level04_code
--               else 'N/A'
--               end,
--         
--         case    when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and pc.level05_code in ('0P111')                  then pc.level07_name
--               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('4803')                           then pc.level05_name
--               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('6801', '3203', '6901')           then pc.level04_name
--               else 'N/A'
--               end,                                                                                    
         pr.level01_code, pr.level01_name,
         pr.level02_code, pr.level02_name, 
--         pr.level03_code, pr.level03_name,
--         pr.level04_code, pr.level04_name,
--         pr.level05_code, pr.level05_name,
--         pr.level06_code, pr.level06_name,    
--         pr.level07_code, pr.level07_name,                                
--         pr.product_code, pr.product_name_short,                      
         1   

order by 1, 2, 3, 4, 5, 6, 7, 8, 9

-- ############################################################## PLAN ###################################################################
), plan as (
select  
         f.date_sid, 
--         f.scenario,
--         f.version,
--         f.status,
         pc.level03_code as pc_level03_code, pc.level03_name as pc_level03_name,
         pc.level04_code as pc_level04_code, pc.level04_name as pc_level04_name,
         pc.level05_code as pc_level05_code, pc.level05_name as pc_level05_name,
         pc.level06_code as pc_level06_code, pc.level06_name as pc_level06_name,
         pc.level07_code as pc_level07_code, pc.level07_name as pc_level07_name,             
--         mdm_company_code_addn                                                                                       as company_code,
--         mdm_name_addn                                                                                               as company_name,
--         
--         case  when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and pc.level05_code in ('0P111')                  then pc.level05_code
--               when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS'                                                   then 'N/A'                     
--               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('4803', '6801', '3203', '6901')   then pc.level03_code
--               else 'N/A'
--               end  as mp_code,
--         
--         case  when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and pc.level05_code in ('0P111')                  then pc.level05_name                     
--               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('4803', '6801', '3203', '6901')   then pc.level03_name
--               else 'N/A'
--               end as mp_name,
--         
--         case  when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and pc.level05_code in ('0P111')                  then pc.level07_code
--               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('4803')                           then pc.level05_code
--               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('6801', '3203', '6901')           then pc.level04_code
--               else 'N/A'
--               end  as bs_code,
--         
--         case  when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and pc.level05_code in ('0P111')                  then pc.level07_name
--               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('4803')                           then pc.level05_name
--               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('6801', '3203', '6901')           then pc.level04_name
--               else 'N/A'
--               end  as bs_name,
                                                                                                  
         pr.level01_code as pr_level01_code, pr.level01_name as pr_level01_name,
         pr.level02_code as pr_level02_code, pr.level02_name as pr_level02_name,
--         pr.level03_code as pr_level03_code, pr.level03_name as pr_level03_name,
--         pr.level04_code as pr_level04_code, pr.level04_name as pr_level04_name,
--         pr.level05_code as pr_level05_code, pr.level05_name as pr_level05_name,
--         pr.level06_code as pr_level06_code, pr.level06_name as pr_level06_name,                                
--         pr.product_code, pr.product_name_short,                
--         sum(sales_line_qty)                                                                                as sales_line_qty,                      
--         sum(sales_line_qty_kg)                                                                             as sales_line_qty_kg,           
--         sum(sales_line_qty_liter)                                      as sales_line_qty_l,                
--         sum(net_sales_line_amt)                                        as net_sales_line_amt,
         sum(margin_line_amt)                                           as margin_line_amt,
--         sum(net_sales_line_amt * exchange_rate_float)                  as net_sales_line_amt_eur,
--         sum(margin_line_amt * exchange_rate_float)                     as margin_line_amt_eur,
         1    
                      
from     f_sales_plan_daily f
         inner join d_date d                     on  f.date_sid = d.date_sid
         inner join d_company co                 on  f.company_sid = co.company_sid                 
         inner join v_profit_center_bi pc        on  f.profit_center_sid = pc.profit_center_sid     and pc.hierarchy_ext_refr in ('PC|STD_SAP_PIS', 'PC|PIS')
         inner join v_product_bi pr              on  pr.product_sid = f.product_sid                 and pr.hierarchy_ext_refr = 'PR|SAP'
--         inner join d_product pr                 on  pr.product_sid = f.product_sid
         left join  d_exchange_rate ex           on  f.currency_sid = ex.currency_from_sid 
                                                 and f.country_sid = ex.country_sid                
                                                 and f.date_sid = to_number(to_char(ex.eff_to_dt, 'yyyymmdd'))
                                                 and ex.exchange_rate_type_ext_refr = 'PLN D'
                                                 and ex.currency_to_ext_refr = 'EUR' 
               
where    1 = 1
and      f.date_sid between 20200101 and 20201008
and      f.scenario = 'FC'
and      f.version = 2
and      f.is_own_usage = 0
and      pr.level01_code <> ('06') 
and      pr.level01_code in ('03')    
and      pc.level05_code in ('0P111')
and      co.company_code = '1000'
and      ((pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and co.company_code in ('1000', '3000', '821071')) or 
         (pc.hierarchy_ext_refr = 'PC|PIS' and co.company_code in ('812820', '812892', '812968', '812969')))
--and      bs_code <> 'N/A' 


group by
         f.date_sid, 
--         f.scenario,
--         f.version,
--         f.status,
         pc.level03_code, pc.level03_name,
         pc.level04_code, pc.level04_name,
         pc.level05_code, pc.level05_name,
         pc.level06_code, pc.level06_name,
         pc.level07_code, pc.level07_name,                
--          mdm_company_code_addn, 
--          mdm_name_addn,    
--         
--         case  when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and pc.level05_code in ('0P111')                  then pc.level05_code
--               when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS'                                                   then 'N/A'                     
--               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('4803', '6801', '3203', '6901')   then pc.level03_code
--               else 'N/A'
--               end  as mp_code,
--         
--         case  when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and pc.level05_code in ('0P111')                  then pc.level05_name                     
--               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('4803', '6801', '3203', '6901')   then pc.level03_name
--               else 'N/A'
--               end as mp_name,
--         
--         case  when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and pc.level05_code in ('0P111')                  then pc.level07_code
--               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('4803')                           then pc.level05_code
--               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('6801', '3203', '6901')           then pc.level04_code
--               else 'N/A'
--               end  as bs_code,
--         
--         case  when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and pc.level05_code in ('0P111')                  then pc.level07_name
--               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('4803')                           then pc.level05_name
--               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('6801', '3203', '6901')           then pc.level04_name
--               else 'N/A'
--               end  as bs_name,
                                                                                                  
         pr.level01_code, pr.level01_name,
         pr.level02_code, pr.level02_name,
--         pr.level03_code, pr.level03_name,
--         pr.level04_code, pr.level04_name,
--         pr.level05_code, pr.level05_name,
--         pr.level06_code, pr.level06_name,                                
--         pr.product_code, pr.product_name_short,             
         1     

order by 1, 2, 3, 4, 5, 6, 7, 8, 9         
        
-- ############################################################## ATTRIBUTE ##############################################################
--), bs_attribute as (
--select  distinct
--         case  when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and pc.level05_code in ('0P111')                  then pc.level05_code
--               when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS'                                                   then 'N/A'                     
--               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('4803', '6801', '3203', '6901')   then pc.level03_code
--               else 'N/A'
--               end  as mp_code,
--         
--         case  when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and pc.level05_code in ('0P111')                  then pc.level05_name                     
--               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('4803', '6801', '3203', '6901')   then pc.level03_name
--               else 'N/A'
--               end as mp_name,
--         
--         case  when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and pc.level05_code in ('0P111')                  then pc.level07_code
--               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('4803')                           then pc.level05_code
--               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('6801', '3203', '6901')           then pc.level04_code
--               else 'N/A'
--               end  as bs_code,
--         
--         case  when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and pc.level05_code in ('0P111')                  then pc.level07_name
--               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('4803')                           then pc.level05_name
--               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('6801', '3203', '6901')           then pc.level04_name
--               else 'N/A'
--               end  as bs_name,
--         pca.attribute_name,
--         pca.attribute_value_string,
--         pca.eff_to_date_sid,
--         pca.vld_to_dt
--from     v_profit_center_bi pc
--         inner join d_profit_center_attribute pca        on pc.profit_center_sid = pca.profit_center_sid
--         inner join d_company co                         on pc.company_sid = co.company_sid 
--where    pca.attribute_name = 'LOKACIJA BS'
--and      pc.hierarchy_ext_refr in ('PC|PIS', 'PC|STD_SAP_PIS')
--
--and      eff_to_date_sid = 99991231
        

)
   
-----------------------------------------------------------------------------------
--, test as (      
----------------------------------------------------------------------------------
-- ############################################################## FINAL Q ################################################################
select  
--         coalesce(s.month_id,     p.month_id    )        as month_id,
         coalesce(s.accounting_date_sid, p.date_sid   )        as date_id,
         coalesce(s.pc_level03_code, p.pc_level03_code)        as pc_level03_code,
         coalesce(s.pc_level03_name, p.pc_level03_name)        as pc_level03_name,
         coalesce(s.pc_level04_code, p.pc_level04_code)        as pc_level04_code,
         coalesce(s.pc_level04_name, p.pc_level04_name)        as pc_level04_name,
         coalesce(s.pc_level05_code, p.pc_level05_code)        as pc_level05_code,
         coalesce(s.pc_level05_name, p.pc_level05_name)        as pc_level05_name,
         coalesce(s.pc_level06_code, p.pc_level06_code)        as pc_level06_code,
         coalesce(s.pc_level06_name, p.pc_level06_name)        as pc_level06_name,
         coalesce(s.pc_level07_code, p.pc_level07_code)        as pc_level07_code,
         coalesce(s.pc_level07_name, p.pc_level07_name)        as pc_level07_name,
--         coalesce(s.company_code, p.company_code)        as company_code,
--         coalesce(s.company_name, p.company_name)        as company_name,
--         coalesce(s.bs_code,      p.bs_code     )        as bs_code,
--         coalesce(s.bs_name,      p.bs_name     )        as bs_name,       
--         ifnull(attribute_value_string, 'BREZ LOKACIJE') as attribute_value_string,                                
         coalesce(s.pr_level01_code, p.pr_level01_code)        as pr_level01_code,
         coalesce(s.pr_level01_name, p.pr_level01_name)        as pr_level01_name,
         coalesce(s.pr_level02_code, p.pr_level02_code)        as pr_level02_code,
         coalesce(s.pr_level02_name, p.pr_level02_name)        as pr_level02_name,
--         coalesce(s.pr_level03_code, p.pr_level03_code)        as pr_level03_code,
--         coalesce(s.pr_level03_name, p.pr_level03_name)        as pr_level03_name,
--         coalesce(s.pr_level04_code, p.pr_level04_code)        as pr_level04_code,
--         coalesce(s.pr_level04_name, p.pr_level04_name)        as pr_level04_name,
--         coalesce(s.pr_level05_code, p.pr_level05_code)        as pr_level05_code,
--         coalesce(s.pr_level05_name, p.pr_level05_name)        as pr_level05_name,
--         coalesce(s.pr_level06_code, p.pr_level06_code)        as pr_level06_code,
--         coalesce(s.pr_level06_name, p.pr_level06_name)        as pr_level06_name,
--         coalesce(s.product_code, p.product_code)              as product_code,
--         coalesce(s.product_name_short, p.product_name_short)  as product_name_short,
        
--         ifnull(sum(s.sales_line_qty_l), 0)              as ac_sales_line_qty_l,
--         ifnull(sum(s.net_sales_line_amt), 0)            as ac_net_sales_line_amt,
         ifnull(sum(s.net_margin_line_amt), 0)           as ac_net_margin_line_amt,     
--         ifnull(sum(s.net_sales_line_amt_eur), 0)        as ac_net_sales_line_amt_eur,
--         ifnull(sum(s.net_margin_line_amt_eur), 0)       as ac_net_margin_line_amt_eur,           
--         ifnull(sum(p.sales_line_qty_l), 0)              as bu_sales_line_qty_l,
--         ifnull(sum(p.net_sales_line_amt), 0)            as bu_net_sales_line_amt,
         ifnull(sum(p.margin_line_amt), 0)               as bu_margin_line_amt,
--         ifnull(sum(p.net_sales_line_amt_eur), 0)        as bu_net_sales_line_amt_eur,
--         ifnull(sum(p.margin_line_amt_eur), 0)           as bu_margin_line_amt_eur,
         1

from    sales s
        full join plan p        on 1 = 1
                                and s.accounting_date_sid = p.date_sid
--                                and  s.month_id          = p.month_id
--                                and s.company_code      = p.company_code
--                                and s.bs_code           = p.bs_code
                                                               
                                and s.pc_level03_code      = p.pc_level03_code
                                and s.pc_level04_code      = p.pc_level04_code
                                and s.pc_level05_code      = p.pc_level05_code
                                and s.pc_level06_code      = p.pc_level06_code
                                and s.pc_level07_code      = p.pc_level07_code

                                and s.pr_level01_code      = p.pr_level01_code
                                and s.pr_level02_code      = p.pr_level02_code
--                                and s.pr_level03_code      = p.pr_level03_code
--                                and s.pr_level04_code      = p.pr_level04_code
--                                and s.pr_level05_code      = p.pr_level05_code
--                                and s.pr_level06_code      = p.pr_level06_code
--                                and s.product_code         = p.product_code              
                                
--        left join bs_attribute b        on coalesce(s.bs_code, p.bs_code) = b.bs_code   
           
group by                                                  
--         coalesce(s.month_id,     p.month_id    )       ,
         coalesce(s.accounting_date_sid, p.date_sid   )   ,    
         coalesce(s.pc_level03_code, p.pc_level03_code)   ,
         coalesce(s.pc_level03_name, p.pc_level03_name)   ,
         coalesce(s.pc_level04_code, p.pc_level04_code)   ,
         coalesce(s.pc_level04_name, p.pc_level04_name)   ,
         coalesce(s.pc_level05_code, p.pc_level05_code)   ,
         coalesce(s.pc_level05_name, p.pc_level05_name)   ,
         coalesce(s.pc_level06_code, p.pc_level06_code) ,
         coalesce(s.pc_level06_name, p.pc_level06_name) ,
         coalesce(s.pc_level07_code, p.pc_level07_code) ,
         coalesce(s.pc_level07_name, p.pc_level07_name) ,
--         coalesce(s.company_code, p.company_code)       ,
--         coalesce(s.company_name, p.company_name)       ,
--         coalesce(s.bs_code,      p.bs_code     )       ,
--         coalesce(s.bs_name,      p.bs_name     )       ,
--         ifnull(attribute_value_string, 'BREZ LOKACIJE'),                            
         coalesce(s.pr_level01_code, p.pr_level01_code)   ,
         coalesce(s.pr_level01_name, p.pr_level01_name)   ,
         coalesce(s.pr_level02_code, p.pr_level02_code) ,
         coalesce(s.pr_level02_name, p.pr_level02_name) ,
--         coalesce(s.pr_level03_code, p.pr_level03_code) ,
--         coalesce(s.pr_level03_name, p.pr_level03_name) ,
--         coalesce(s.pr_level04_code, p.pr_level04_code) ,
--         coalesce(s.pr_level04_name, p.pr_level04_name) ,
--         coalesce(s.pr_level05_code, p.pr_level05_code) ,
--         coalesce(s.pr_level05_name, p.pr_level05_name) ,
--         coalesce(s.pr_level06_code, p.pr_level06_code) ,
--         coalesce(s.pr_level06_name, p.pr_level06_name) ,
--         coalesce(s.product_code, p.product_code)       ,
--         coalesce(s.product_name_short, p.product_name_short),
         1

                
order by 1, 2, 4, 6, 8, 10, 12, 14


;    
      
-- ############################################################## TEST ROLLUP ############################################################      
-------------------------------------------------------------------------------        
--)       
--select 
--        month_id,              
--        company_code,          
--        iff(company_code is null, null, min(company_name)) as company_name,   
----        bs_code,               
----        bs_name,               
----        attribute_value_string,
--        level01_code,
--        iff(level01_code is null, null, min(level01_name)) as level01_name,           
----        level02_code,          
----        level02_name,              
--        sum(ac_sales_line_qty_l),    
--        sum(ac_net_sales_line_amt),  
--        sum(ac_net_margin_line_amt), 
--        sum(ac_net_sales_line_amt_eur),
--        sum(ac_net_margin_line_amt_eur),
--        sum(bu_sales_line_qty_l),
--        sum(bu_net_sales_line_amt),  
--        sum(bu_margin_line_amt),
--        sum(bu_net_sales_line_amt_eur),
--        sum(bu_margin_line_amt_eur)
--
--from    test 
--
--group by        month_id,                                    
--                rollup(
--                company_code,
--                level01_code         
--                ),
--
----                bs_code,               
----                bs_name,               
----                attribute_value_string,
----                level02_code,          
----                level02_name,
--                1 
--                
--order by 1, 2, 3, 4, 5--, 6, 7, 8, 9, 10, 11       
 
-- ############################################################## PC CODES ###############################################################      
 
 ---- SI ------------------------------------------
--(
--        co.company_code = '1000'
--and     pc.level05_code in (
--                            '0P111'  -- mp    bs
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
--                            )
--and     pc.level07_code in ('0000101101') -- Primer BS
--and     pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS'
--)
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


;
-- ############################################################## BRUTO MARŽA ############################################################
), gross_margin as (

select 
--         *
--         f.accounting_date_sid,
--         f.gm_indicator,
--         f.is_own_usage,
         mdm_company_code_addn                                  as company_code,
         mdm_name_addn                                          as company_name,        
         pc.level03_code as pc_level03_code, pc.level03_name as pc_level03_name,
--         pc.level04_code as pc_level04_code, pc.level04_name as pc_level04_name,
--         pc.level05_code as pc_level05_code, pc.level05_name as pc_level05_name,
--         pc.level06_code as pc_level06_code, pc.level06_name as pc_level06_name,
--         pc.level07_code as pc_level07_code, pc.level07_name as pc_level07_name,
--         case  when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and pc.level05_code in ('0P111')                  then pc.level05_code
--               when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS'                                                   then 'N/A'                     
--               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('4803', '6801', '3203', '6901')   then pc.level03_code
--               else 'N/A'
--               end  as mp_code,
--         
--         case  when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and pc.level05_code in ('0P111')                  then pc.level05_name                     
--               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('4803', '6801', '3203', '6901')   then pc.level03_name
--               else 'N/A'
--               end as mp_name,
--         
--         case  when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and pc.level05_code in ('0P111')                  then pc.level07_code
--               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('4803')                           then pc.level05_code
--               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('6801', '3203', '6901')           then pc.level04_code
--               else 'N/A'
--               end  as bs_code,
--         
--         case  when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and pc.level05_code in ('0P111')                  then pc.level07_name
--               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('4803')                           then pc.level05_name
--               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('6801', '3203', '6901')           then pc.level04_name
--               else 'N/A'
--               end  as bs_name,                                                                                    
         pr.level01_code as pr_level01_code, pr.level01_name as pr_level01_name,
         pr.level02_code as pr_level02_code, pr.level02_name as pr_level02_name,
         pr.level03_code as pr_level03_code, pr.level03_name as pr_level03_name,
         pr.level04_code as pr_level04_code, pr.level04_name as pr_level04_name,
--         pr.level05_code as pr_level05_code, pr.level05_name as pr_level05_name,
--         pr.level06_code as pr_level06_code, pr.level06_name as pr_level06_name,                                
         pr.product_code, pr.product_name_short,                                
--         (        - sum(super_rebates_for_customers) 
--                  - sum(applied_super_rebates_for_customers) 
--                  - (sum(case when d.year >= 2020 and company_code_pis ='821071' then purchase_price_amt_copa
--                              when d.year >= 2019 and company_code_pis ='9110'   then purchase_price_amt_copa
--                              else purchase_price_amt_pis end)
--                           + sum(rebates_for_suppliers) 
--                           + sum(applied_rebates_for_suppliers) 
--                           + sum(case when d.year >= 2020 and company_code_pis ='821071' then price_variance_copa
--                                      when d.year >= 2019 and company_code_pis ='9110'   then price_variance_copa
--                                      else price_variance_pis end)
--                           + sum(inventory_deficit) +sum(extraordinary_deficit)+sum(transport_ullage)+sum(deficit)+sum(applied_deficit)+sum(escape_value) + sum(own_usage_purchase_price_marketing)  + sum(stock_adjustment)
--                           + sum(procurement_costs) 
--                           + sum(taxes_and_excise_duties_impact))
--           ) as calc_for_gm,
--           
--         sum(case  when d.year >= 2020 and company_code_pis ='821071' then purchase_price_amt_copa
--               when d.year >= 2019 and company_code_pis ='9110'   then purchase_price_amt_copa
--               else purchase_price_amt_pis end)                         as nv,
--         sum(super_rebates_for_customers)                               as naknadno_dani_rabati,
--         sum(applied_super_rebates_for_customers)                       as vkalkulirani_dani_rabati,
         sum(rebates_for_suppliers)                                     as naknadno_prejeti_rabati,
--         sum(applied_rebates_for_suppliers)                             as vkalkulirani_prejeti_rabati,
--         sum(inventory_deficit)+sum(extraordinary_deficit)+sum(transport_ullage)+sum(deficit)+sum(applied_deficit)+sum(escape_value) + sum(own_usage_purchase_price_marketing)  + sum(stock_adjustment) as manki_skupaj,
--         sum(case when d.year >= 2020 and company_code_pis ='821071' then price_variance_copa
--               when d.year >= 2019 and company_code_pis ='9110'      then price_variance_copa
--               else price_variance_pis end)                             as cenovni_odmiki,
--         sum(procurement_costs)                                         as procurement_costs,
--         sum(taxes_and_excise_duties_impact)                            as taxes_and_excise_duties_impact,                
         1        
       
from     f_gross_margin                      /*at (timestamp => to_timestamp_tz('2020-09-01 07:00:00'))*/ f 
--from     v_sales_all                         /*at (timestamp => to_timestamp_tz('2020-09-01 07:00:00'))*/ f 
         inner join d_date                   /*at (timestamp => to_timestamp_tz('2020-09-01 07:00:00'))*/ d          on f.accounting_date_sid = d.date_sid
         inner join d_company                /*at (timestamp => to_timestamp_tz('2020-09-01 07:00:00'))*/ co         on f.company_sid = co.company_sid               
         inner join v_profit_center_bi       /*at (timestamp => to_timestamp_tz('2020-09-01 07:00:00'))*/ pc         on f.profit_center_sid = pc.profit_center_sid and pc.hierarchy_ext_refr in ('PC|PIS', 'PC|STD_SAP_PIS')
         inner join v_product_bi             /*at (timestamp => to_timestamp_tz('2020-09-01 07:00:00'))*/ pr         on f.product_sid = pr.product_sid            and pr.hierarchy_ext_refr = 'PR|SAP'
--         inner join d_exchange_rate          /*at (timestamp => to_timestamp_tz('2020-09-01 07:00:00'))*/ ex         on f.currency_sid = ex.currency_from_sid     and f.country_sid = ex.country_sid                
--                                                                                                                                                                  and f.accounting_date_sid = to_number(to_char(ex.eff_to_dt, 'yyyymmdd'))
--                                                                                                                                                                  and ex.exchange_rate_type_ext_refr = 'D'
--                                                                                                                                                                  and ex.currency_to_ext_refr = 'EUR'
where    1 = 1
and      f.accounting_date_sid between 20200101 and 20200199
--and      f.is_own_usage = 0
and      pr.level01_code <> ('06') 
--and      pc.level05_code in ('0P113')
and      pc.level03_code in ('4803')
and      pr.level01_code in ('03')
and      pr.level02_code in ('0305')
and      pr.level04_code = '030501003'
--and      pr.product_code = '137099|BL'
and      co.company_code = '812820'
and      ((pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and co.company_code in ('1000', '3000', '821071')) or 
         (pc.hierarchy_ext_refr = 'PC|PIS' and co.company_code in ('812820', '812892', '812968', '812969')))

group by
--         f.accounting_date_sid,
--         f.gm_indicator,
--         f.is_own_usage,
         mdm_company_code_addn, 
         mdm_name_addn,     
         pc.level03_code, pc.level03_name,
--         pc.level04_code, pc.level04_name,
--         pc.level05_code, pc.level05_name,
--         pc.level06_code, pc.level06_name,
--         pc.level07_code, pc.level07_name,   
--         case    when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and pc.level05_code in ('0P111')                  then pc.level05_code
--               when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS'                                                   then 'N/A'                     
--               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('4803', '6801', '3203', '6901')   then pc.level03_code
--               else 'N/A'
--               end,
--         
--         case    when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and pc.level05_code in ('0P111')                  then pc.level05_name                     
--               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('4803', '6801', '3203', '6901')   then pc.level03_name
--               else 'N/A'
--               end,
--         
--         case    when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and pc.level05_code in ('0P111')                  then pc.level07_code
--               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('4803')                           then pc.level05_code
--               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('6801', '3203', '6901')           then pc.level04_code
--               else 'N/A'
--               end,
--         
--         case    when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and pc.level05_code in ('0P111')                  then pc.level07_name
--               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('4803')                           then pc.level05_name
--               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('6801', '3203', '6901')           then pc.level04_name
--               else 'N/A'
--               end,                                                                                    
         pr.level01_code, pr.level01_name,
         pr.level02_code, pr.level02_name, 
         pr.level03_code, pr.level03_name,
         pr.level04_code, pr.level04_name,
--         pr.level05_code, pr.level05_name,
--         pr.level06_code, pr.level06_name,                                
         pr.product_code, pr.product_name_short,                      
         1   

order by 1, 2, 3, 4, 5, 6, 7, 8
;
)

select  
         s.company_code,
         s.company_name,
--         s.is_own_usage,
         s.pc_level03_code, s.pc_level03_name,
--         s.pc_level04_code, s.pc_level04_name,
--         s.pc_level05_code, s.pc_level05_name,
--         s.pc_level06_code, s.pc_level06_name,
--         s.pc_level07_code, s.pc_level07_name,                                                                                    
         s.pr_level01_code, s.pr_level01_name,
         s.pr_level02_code, s.pr_level02_name, 
--         s.pr_level03_code, s.pr_level03_name,
--         s.pr_level04_code, s.pr_level04_name,
--         s.pr_level05_code, s.pr_level05_name,
--         s.pr_level06_code, s.pr_level06_name,                                
--         s.pr_product_code, s.pr_product_name_short,           
         s.net_sales_line_amt,
         s.gross_margin,
         s.calculation_for_gm_amt,
         '                    ',
         gm.calc_for_gm,
         gm.naknadno_dani_rabati,       
         gm.vkalkulirani_dani_rabati,   
         gm.nv,                         
         gm.naknadno_prejeti_rabati,    
         gm.vkalkulirani_prejeti_rabati,
         gm.cenovni_odmiki,                 
         gm.manki_skupaj,
         gm.procurement_costs,              
         gm.taxes_and_excise_duties_impact
         
from     sales s
         full join gross_margin gm  on  s.company_code         = gm.company_code
--                                    and s.is_own_usage         = gm.is_own_usage
                                    and s.pc_level03_code      = gm.pc_level03_code
                                    and s.pr_level01_code      = gm.pr_level01_code
                                    and s.pr_level02_code      = gm.pr_level02_code
     
;