use database dwh_prod; use schema aplsdb;


-- ############################################################## SALES ##############################################################
with sales as (
select 
--         f.accounting_yearmonth_id as month_id,
         pc.level03_code as pc_level03_code, pc.level03_name as pc_level03_name,
         pc.level04_code as pc_level04_code, pc.level04_name as pc_level04_name,
         pc.level05_code as pc_level05_code, pc.level05_name as pc_level05_name,
--         pc.level06_code as pc_level06_code, pc.level06_name as pc_level06_name,
--         pc.level07_code as pc_level07_code, pc.level07_name as pc_level07_name,

--         case when co.company_code = '821071' then '3000' else co.company_code end                               as company_code,
--         case when co.company_code = '821071' then 'Petrol d.o.o., Zagreb' else co.name end                      as company_name,
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
--         pr.level02_code as pr_level02_code, pr.level02_name as pr_level02_name,
--         pr.level03_code as pr_level03_code, pr.level03_name as pr_level03_name,
--         pr.level04_code as pr_level04_code, pr.level04_name as pr_level04_name,
--         pr.level05_code as pr_level05_code, pr.level05_name as pr_level05_name,
--         pr.level06_code as pr_level06_code, pr.level06_name as pr_level06_name,                                
--         pr.product_code, pr.product_name_short,                                
       
         sum(sales_line_qty_l)                           as sales_line_qty_l,                
         sum(net_sales_line_amt)                         as net_sales_line_amt,
         sum(net_margin_line_amt)                        as net_margin_line_amt,        
         sum(net_sales_line_amt * exchange_rate_float)   as net_sales_line_amt_eur,
         sum(net_margin_line_amt * exchange_rate_float)  as net_margin_line_amt_eur,                        
       1        
       
from   f_sales_all_daily f 
       inner join d_date d                     on f.accounting_date_sid = d.date_sid
       inner join d_company co                 on f.company_sid = co.company_sid               
       inner join v_profit_center_bi pc        on f.sales_point_sid = pc.profit_center_sid     and pc.hierarchy_ext_refr in ('PC|STD_SAP_PIS') --'PC|PIS', 
       inner join v_product_bi pr              on f.product_sid = pr.product_sid               and pr.hierarchy_ext_refr = 'PR|SAP'
       inner join d_exchange_rate ex           on  f.currency_sid = ex.currency_from_sid 
                                               and f.country_sid = ex.country_sid                
                                               and f.accounting_date_sid = to_number(to_char(ex.eff_to_dt, 'yyyymmdd'))
                                               and ex.exchange_rate_type_ext_refr = 'D'
                                               and ex.currency_to_ext_refr = 'EUR'

where   1 = 1
and     f.accounting_date_sid between 20200701 and 20200720
and     f.is_own_usage = 0
and     pr.level01_code <> ('06') 
--and     pr.level01_code in ('03', '05')    
--and     pc.level05_code in ('0P111')
and      ((pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and co.company_code in ('1000', '3000', '821071')) or 
         (pc.hierarchy_ext_refr = 'PC|PIS' and co.company_code in ('812820', '812892', '812968', '812969')))

--and     bs_code <> 'N/A' 


group by
--         f.accounting_date_sid,
         pc.level03_code, pc.level03_name,
         pc.level04_code, pc.level04_name,
         pc.level05_code, pc.level05_name,
--         pc.level06_code, pc.level06_name,
--         pc.level07_code, pc.level07_name,

--         case when co.company_code = '821071' then '3000' else co.company_code end                               as company_code,
--         case when co.company_code = '821071' then 'Petrol d.o.o., Zagreb' else co.name end                      as company_name,
--         
--         case    when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and pc.level05_code in ('0P111')                  then pc.level05_code
--               when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS'                                                   then 'N/A'                     
--               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('4803', '6801', '3203', '6901')   then pc.level03_code
--               else 'N/A'
--               end  as mp_code,
--         
--         case    when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and pc.level05_code in ('0P111')                  then pc.level05_name                     
--               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('4803', '6801', '3203', '6901')   then pc.level03_name
--               else 'N/A'
--               end as mp_name,
--         
--         case    when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and pc.level05_code in ('0P111')                  then pc.level07_code
--               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('4803')                           then pc.level05_code
--               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('6801', '3203', '6901')           then pc.level04_code
--               else 'N/A'
--               end  as bs_code,
--         
--         case    when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and pc.level05_code in ('0P111')                  then pc.level07_name
--               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('4803')                           then pc.level05_name
--               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('6801', '3203', '6901')           then pc.level04_name
--               else 'N/A'
--               end  as bs_name, 
                                                                                   
         pr.level01_code, pr.level01_name,
--         pr.level02_code, pr.level02_name, 
--         pr.level03_code, pr.level03_name,
--         pr.level04_code, pr.level04_name,
--         pr.level05_code, pr.level05_name,
--         pr.level06_code, pr.level06_name,                                
--         pr.product_code, pr.product_name_short,                      
         1   

-- ############################################################## PLAN ##############################################################
), plan as (
select  
--         floor(date_sid/100) as month_id, 
         pc.level03_code as pc_level03_code, pc.level03_name as pc_level03_name,
         pc.level04_code as pc_level04_code, pc.level04_name as pc_level04_name,
         pc.level05_code as pc_level05_code, pc.level05_name as pc_level05_name,
--         pc.level06_code as pc_level06_code, pc.level06_name as pc_level06_name,
--         pc.level07_code as pc_level07_code, pc.level07_name as pc_level07_name,             
--         case when co.company_code = '821071' then '3000' else co.company_code end               as company_code,
--         case when co.company_code = '821071' then 'Petrol d.o.o., Zagreb' else co.name end      as company_name,
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
--         pr.level02_code as pr_level02_code, pr.level02_name as pr_level02_name,
--         pr.level03_code as pr_level03_code, pr.level03_name as pr_level03_name,
--         pr.level04_code as pr_level04_code, pr.level04_name as pr_level04_name,
--         pr.level05_code as pr_level05_code, pr.level05_name as pr_level05_name,
--         pr.level06_code as pr_level06_code, pr.level06_name as pr_level06_name,                                
--         pr.product_code, pr.product_name_short,                
         
         sum(sales_line_qty_liter)                                      as sales_line_qty_l,                
         sum(net_sales_line_amt)                                        as net_sales_line_amt,
         sum(margin_line_amt)                                           as margin_line_amt,
         sum(net_sales_line_amt * exchange_rate_float)                  as net_sales_line_amt_eur,
         sum(margin_line_amt * exchange_rate_float)                     as margin_line_amt_eur,
         1    
                      
from     f_sales_plan_daily f
         inner join d_date d                     on f.date_sid = d.date_sid
         inner join d_company co                 on f.company_sid = co.company_sid                 
         inner join v_profit_center_bi pc        on f.profit_center_sid = pc.profit_center_sid     and pc.hierarchy_ext_refr in ('PC|STD_SAP_PIS') --'PC|PIS', 
         inner join v_product_bi pr              on pr.product_sid = f.product_sid                 and pr.hierarchy_ext_refr = 'PR|SAP'
         left join  d_exchange_rate ex           on  f.currency_sid = ex.currency_from_sid 
                                               and f.country_sid = ex.country_sid                
                                               and f.date_sid = to_number(to_char(ex.eff_to_dt, 'yyyymmdd'))
                                               and ex.exchange_rate_type_ext_refr = 'PLN D'
                                               and ex.currency_to_ext_refr = 'EUR' 
               
where    1 = 1
and      f.date_sid between 20200701 and 20200720
and      f.scenario = 'P'
and      f.version = 1
and      f.is_own_usage = 0
and      pr.level01_code <> ('06') 
--and      pr.level01_code in ('03', '05')    
--and      pc.level05_code in ('0P111', '0000100209')
and      ((pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and co.company_code in ('1000', '3000', '821071')) or 
         (pc.hierarchy_ext_refr = 'PC|PIS' and co.company_code in ('812820', '812892', '812968', '812969')))
--and      bs_code <> 'N/A' 


group by
--         floor(date_sid/100), 
         pc.level03_code, pc.level03_name,
         pc.level04_code, pc.level04_name,
         pc.level05_code, pc.level05_name,
--         pc.level06_code, pc.level06_name,
--         pc.level07_code, pc.level07_name,                
--         case when co.company_code = '821071' then '3000' else co.company_code end               as company_code,
--         case when co.company_code = '821071' then 'Petrol d.o.o., Zagreb' else co.name end      as company_name,
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
--         pr.level02_code, pr.level02_name,
--         pr.level03_code, pr.level03_name,
--         pr.level04_code, pr.level04_name,
--         pr.level05_code, pr.level05_name,
--         pr.level06_code, pr.level06_name,                                
--         pr.product_code, pr.product_name_short,             
         1          


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
-----------------------------------------------------------------------------------

-- ############################################################## FINAL Q ##############################################################
select  
--         coalesce(s.month_id,     p.month_id    )        as month_id,
         coalesce(s.pc_level03_code, p.pc_level03_code)        as pc_level03_code,
         coalesce(s.pc_level03_name, p.pc_level03_name)        as pc_level03_name,
         coalesce(s.pc_level04_code, p.pc_level04_code)        as pc_level04_code,
         coalesce(s.pc_level04_name, p.pc_level04_name)        as pc_level04_name,
         coalesce(s.pc_level05_code, p.pc_level05_code)        as pc_level05_code,
         coalesce(s.pc_level05_name, p.pc_level05_name)        as pc_level05_name,
--         coalesce(s.pc_level06_code, p.pc_level06_code)        as pc_level06_code,
--         coalesce(s.pc_level06_name, p.pc_level06_name)        as pc_level06_name,
--         coalesce(s.pc_level07_code, p.pc_level07_code)        as pc_level07_code,
--         coalesce(s.pc_level07_name, p.pc_level07_name)        as pc_level07_name,
--         coalesce(s.company_code, p.company_code)        as company_code,
--         coalesce(s.company_name, p.company_name)        as company_name,
--         coalesce(s.bs_code,      p.bs_code     )        as bs_code,
--         coalesce(s.bs_name,      p.bs_name     )        as bs_name,       
--         ifnull(attribute_value_string, 'BREZ LOKACIJE') as attribute_value_string,                                
         coalesce(s.pr_level01_code, p.pr_level01_code)        as pr_level01_code,
         coalesce(s.pr_level01_name, p.pr_level01_name)        as pr_level01_name,
--         coalesce(s.pr_level02_code, p.pr_level02_code)        as pr_level02_code,
--         coalesce(s.pr_level02_name, p.pr_level02_name)        as pr_level02_name,
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
        
         ifnull(sum(s.sales_line_qty_l), 0)              as ac_sales_line_qty_l,
         ifnull(sum(s.net_sales_line_amt), 0)            as ac_net_sales_line_amt,
         ifnull(sum(s.net_margin_line_amt), 0)           as ac_net_margin_line_amt,     
         ifnull(sum(s.net_sales_line_amt_eur), 0)        as ac_net_sales_line_amt_eur,
         ifnull(sum(s.net_margin_line_amt_eur), 0)       as ac_net_margin_line_amt_eur,           
         ifnull(sum(p.sales_line_qty_l), 0)              as bu_sales_line_qty_l,
         ifnull(sum(p.net_sales_line_amt), 0)            as bu_net_sales_line_amt,
         ifnull(sum(p.margin_line_amt), 0)               as bu_margin_line_amt,
         ifnull(sum(p.net_sales_line_amt_eur), 0)        as bu_net_sales_line_amt_eur,
         ifnull(sum(p.margin_line_amt_eur), 0)           as bu_margin_line_amt_eur,
         1

from    sales s
        full join plan p        on 1 = 1
--                                and  s.month_id          = p.month_id
--                                and s.company_code      = p.company_code
--                                and s.bs_code           = p.bs_code
                                                               
                                and s.pc_level03_code      = p.pc_level03_code
                                and s.pc_level04_code      = p.pc_level04_code
                                and s.pc_level05_code      = p.pc_level05_code
--                                and s.pc_level06_code      = p.pc_level06_code
--                                and s.pc_level07_code      = p.pc_level07_code

                                and s.pr_level01_code      = p.pr_level01_code
--                                and s.pr_level02_code      = p.pr_level02_code
--                                and s.pr_level03_code      = p.pr_level03_code
--                                and s.pr_level04_code      = p.pr_level04_code
--                                and s.pr_level05_code      = p.pr_level05_code
--                                and s.pr_level06_code      = p.pr_level06_code
--                                and s.product_code         = p.product_code              
                                
--        left join bs_attribute b        on coalesce(s.bs_code, p.bs_code) = b.bs_code   
           
group by                                                  
--         coalesce(s.month_id,     p.month_id    )       ,
         coalesce(s.pc_level03_code, p.pc_level03_code)   ,
         coalesce(s.pc_level03_name, p.pc_level03_name)   ,
         coalesce(s.pc_level04_code, p.pc_level04_code)   ,
         coalesce(s.pc_level04_name, p.pc_level04_name)   ,
         coalesce(s.pc_level05_code, p.pc_level05_code)   ,
         coalesce(s.pc_level05_name, p.pc_level05_name)   ,
--         coalesce(s.pc_level06_code, p.pc_level06_code) ,
--         coalesce(s.pc_level06_name, p.pc_level06_name) ,
--         coalesce(s.pc_level07_code, p.pc_level07_code) ,
--         coalesce(s.pc_level07_name, p.pc_level07_name) ,
--         coalesce(s.company_code, p.company_code)       ,
--         coalesce(s.company_name, p.company_name)       ,
--         coalesce(s.bs_code,      p.bs_code     )       ,
--         coalesce(s.bs_name,      p.bs_name     )       ,
--         ifnull(attribute_value_string, 'BREZ LOKACIJE'),                            
         coalesce(s.pr_level01_code, p.pr_level01_code)   ,
         coalesce(s.pr_level01_name, p.pr_level01_name)   ,
--         coalesce(s.pr_level02_code, p.pr_level02_code) ,
--         coalesce(s.pr_level02_name, p.pr_level02_name) ,
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
      

-- ############################################################## TEST ROLLUP ##############################################################      
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
 
 -- ############################################################## PC CODES ##############################################################      
 
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