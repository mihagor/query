use database dwh_prod;
use schema aplsdb;

with realizacija as (
;
select 
         d.month_id,
         co.country_ext_refr, 
         case when co.company_code = '821071' then '3000' else co.company_code end                                   as company_code, 
         case when co.company_code = '821071' then 'Petrol d.o.o., Zagreb' else co.name end                          as company_name, 
         case when pc.level05_code in ('0P111')                                           then pc.level05_code
              when pc.level03_code in ('6801', '4803', '3203', '6901')                    then pc.level03_code
              else 'N/A' 
              end                                                                                                    as maloprodaja_code,
         case when pc.level05_code in ('0P111')                                           then pc.level05_name 
              when pc.level03_code in ('6801', '4803', '3203', '6901')                    then pc.level03_name
              else 'N/A' 
              end                                                                                                    as maloprodaja_name,                        
         case when pc.level05_code in ('0P111')                                           then pc.level07_code
              when pc.level03_code in ('6801', '3203', '6901')                            then pc.level04_code
              when pc.level03_code in ('4803')                                            then pc.level05_code
              else 'N/A' 
              end                                                                                                    as pm_code,
         case when pc.level05_code in ('0P111')                                           then pc.level07_name 
              when pc.level03_code in ('6801', '3203', '6901')                            then pc.level04_name
              when pc.level03_code in ('4803')                                            then pc.level05_name
              else 'N/A' 
              end                                                                                                    as pm_name,    
         
--         pc.level01_code as pr_level01_code,  pc.level01_name as pr_level01_name,
--         pc.level02_code as pr_level02_code,  pc.level02_name as pr_level02_name,
--         pc.level03_code as pr_level03_code,  pc.level03_name as pr_level03_name,
--         pc.level04_code as pr_level04_code,  pc.level04_name as pr_level04_name,
--         pc.level05_code as pr_level05_code,  pc.level05_name as pr_level05_name,
--         pc.level06_code as pr_level06_code,  pc.level06_name as pr_level06_name,
--         pc.level07_code as pr_level07_code,  pc.level07_name as pr_level07_name,
--         pc.level08_code as pr_level08_code,  pc.level08_name as pr_level08_name,
--         pc.level09_code as pr_level09_code,  pc.level09_name as pr_level09_name,        
--         pc.level10_code as pr_level10_code,  pc.level10_name as pr_level10_name, 
         
         pr.level01_code as pr_level01_code,  pr.level01_name as pr_levell01_name,
         pr.level02_code as pr_level02_code,  pr.level02_name as pr_levell02_name,
         pr.level03_code as pr_level03_code,  pr.level03_name as pr_levell03_name,
         pr.level04_code as pr_level04_code,  pr.level04_name as pr_levell04_name,
--         pr.level05_code as pr_level05_code,  pr.level05_name as pr_levell05_name,
--         pr.level06_code as pr_level06_code,  pr.level06_name as pr_levell06_name,
--         pr.level07_code as pr_level07_code,  pr.level07_name as pr_levell07_name,
--         pr.level08_code as pr_level08_code,  pr.level08_name as pr_levell08_name,
--         pr.level09_code as pr_level09_code,  pr.level09_name as pr_levell09_name,        
--         pr.level10_code as pr_level10_code,  pr.level10_name as pr_levell10_name,      

         sum(sales_line_qty                                                                                          as ac_sales_line_qty,
         sum(sales_line_qty_kg                                                                                       as ac_sales_line_qty_kg,
         sum(sales_line_qty_l                                                                                        as ac_sales_line_qty_l,
         sum(net_sales_line_amt * coalesce(ex.exchange_rate_float, 1)                                                as ac_net_sales_line_amt,
         sum(net_margin_line_amt * coalesce(ex.exchange_rate_float, 1)                                               as ac_net_margin_line_amt,
                 
--         sum(case when d.year = year(current_date)        then sales_line_qty end)                                            as ac_sales_line_qty,
--         sum(case when d.year = year(current_date)        then sales_line_qty_kg end)                                         as ac_sales_line_qty_kg,
--         sum(case when d.year = year(current_date)        then sales_line_qty_l end)                                          as ac_sales_line_qty_l,
--         sum(case when d.year = year(current_date)        then net_sales_line_amt * coalesce(ex.exchange_rate_float, 1) end)  as ac_net_sales_line_amt,
--         sum(case when d.year = year(current_date)        then net_margin_line_amt * coalesce(ex.exchange_rate_float, 1) end) as ac_net_margin_line_amt,
--         sum(case when dpy.year = year(current_date)      then sales_line_qty end)                                            as py_sales_line_qty,
--         sum(case when dpy.year = year(current_date)      then sales_line_qty_kg end)                                         as py_sales_line_qty_kg,
--         sum(case when dpy.year = year(current_date)      then sales_line_qty_l end)                                          as py_sales_line_qty_l,
--         sum(case when dpy.year = year(current_date)      then net_sales_line_amt * coalesce(ex.exchange_rate_float, 1) end)  as py_net_sales_line_amt,
--         sum(case when dpy.year = year(current_date)      then net_margin_line_amt * coalesce(ex.exchange_rate_float, 1) end) as py_net_margin_line_amt,
         1         
         
from     f_sales_all_daily f 
         inner join d_date d                     on  f.accounting_date_sid = d.date_sid
         inner join d_date dpy                   on  f.accounting_date_sid = dpy.py_date_id
         inner join d_company co                 on  f.company_sid = co.company_sid
         inner join v_profit_center_bi pc        on  f.sales_point_sid = pc.profit_center_sid
         inner join v_product_bi pr              on  f.product_sid = pr.product_sid               and pr.hierarchy_ext_refr = 'PR|SAP'
         inner join d_exchange_rate ex           on  f.currency_sid = ex.currency_from_sid 
                                                 and f.country_sid = ex.country_sid                
                                                 and accounting_date_sid /*between to_number(to_char(eff_fm_dt, 'yyyymmdd')) and*/ = to_number(to_char(eff_to_dt, 'yyyymmdd'))
                                                 and exchange_rate_type_ext_refr = 'D'
                                                 and ex.currency_to_ext_refr = 'EUR'     
 

where    1 = 1
--and      f.accounting_date_sid between to_number(to_char(dateadd(years, -3, current_date), 'yyyy0101'))
--                                   and to_number(to_char(dateadd(day, -1, current_date), 'yyyymmdd'))

and      accounting_date_sid between 20200101 and 20200131

and      f.is_own_usage = 0
and      ((pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and co.company_code in ('1000', '3000')) or (pc.hierarchy_ext_refr = 'PC|PIS' and co.company_code in ('812820', '812892', '812968', '812969')))

group by 
         d.month_id,
         co.country_ext_refr, 
         case when co.company_code = '821071' then '3000' else co.company_code end                                   ,
         case when co.company_code = '821071' then 'Petrol d.o.o., Zagreb' else co.name end                          ,
         case when pc.level05_code in ('0P111')                                           then pc.level05_code       
              when pc.level03_code in ('6801', '4803', '3203', '6901')                    then pc.level03_code       
              else 'N/A'                                                                                             
              end                                                                                                    ,
         case when pc.level05_code in ('0P111')                                           then pc.level05_name       
              when pc.level03_code in ('6801', '4803', '3203', '6901')                    then pc.level03_name       
              else 'N/A'                                                                                             
              end                                                                                                    ,                     
         case when pc.level05_code in ('0P111')                                           then pc.level07_code       
              when pc.level03_code in ('6801', '3203', '6901')                            then pc.level04_code       
              when pc.level03_code in ('4803')                                            then pc.level05_code       
              else 'N/A'                                                                                             
              end                                                                                                    ,
         case when pc.level05_code in ('0P111')                                           then pc.level07_name       
              when pc.level03_code in ('6801', '3203', '6901')                            then pc.level04_name       
              when pc.level03_code in ('4803')                                            then pc.level05_name       
              else 'N/A'                                                                                             
              end                                                                                                    ,
         
--         pc.level01_code,  pc.level01_name,
--         pc.level02_code,  pc.level02_name,
--         pc.level03_code,  pc.level03_name,
--         pc.level04_code,  pc.level04_name,
--         pc.level05_code,  pc.level05_name,
--         pc.level06_code,  pc.level06_name,
--         pc.level07_code,  pc.level07_name,
--         pc.level08_code,  pc.level08_name,
--         pc.level09_code,  pc.level09_name,        
--         pc.level10_code,  pc.level10_name, 
         
         pr.level01_code,  pr.level01_name,
         pr.level02_code,  pr.level02_name,
         pr.level03_code,  pr.level03_name,
         pr.level04_code,  pr.level04_name,
--         pr.level05_code,  pr.level05_name,
--         pr.level06_code,  pr.level06_name,
--         pr.level07_code,  pr.level07_name,
--         pr.level08_code,  pr.level08_name,
--         pr.level09_code,  pr.level09_name,        
--         pr.level10_code,  pr.level10_name,      
                   
         1

;
         
-------- --------------------------------------------------------------------------------------------------------------------
), py (
-------- --------------------------------------------------------------------------------------------------------------------

select
         d.month_id,
         co.country_ext_refr, 
         co.company_code, co.name, 
         case when pc.level05_code in ('0P111')                                          then 'MP' 
              when pc.level05_code in ('0P116','0P117','0P118')                          then 'VP'
              when pc.level05_code in ('0P11A','0P11B','0P112','0P114','0P115','0P161')  then 'Ostali kanali'
              when pc.level03_code in ('6801', '4803', '3203', '6901')                   then 'MP'
              when pc.level03_code in ('6802','4802', '3202', '6902')                    then 'VP'
              else 'NERAZPOREJENO' 
              end as pc_lvl01,
           
         case when pc.level05_code in ('0P111')                                          then pc.level06_code
              when pc.level05_code in ('0P116','0P117','0P118')                          then pc.level05_code
              when pc.level05_code in ('0P11A','0P11B','0P112','0P114','0P115','0P161')  then pc.level05_code
              when pc.level03_code in ('4803')                                           then pc.level04_code
              when pc.level03_code in ('6801', '3203', '6901', '4802', '6802', '6902')   then pc.level03_code
              else pc.profit_center_code || ' - ' || pc.profit_center_name
              end as pc_lvl02_c,

         case when pc.level05_code in ('0P111')                                          then pc.level06_name
              when pc.level05_code in ('0P116','0P117','0P118')                          then pc.level05_name
              when pc.level05_code in ('0P11A','0P11B','0P112','0P114','0P115','0P161')  then pc.level05_name
              when pc.level03_code in ('4803')                                           then pc.level04_name
              when pc.level03_code in ('6801', '3203', '6901', '4802', '6802', '6902')   then pc.level03_name
              else pc.profit_center_code || ' - ' || pc.profit_center_name
              end as pc_lvl02_n,
         
--         pc.level01_code as pr_lvl01_c,  pc.level01_name as pr_lvl01_n,
--         pc.level02_code as pr_lvl02_c,  pc.level02_name as pr_lvl02_n,
--         pc.level03_code as pr_lvl03_c,  pc.level03_name as pr_lvl03_n,
--         pc.level04_code as pr_lvl04_c,  pc.level04_name as pr_lvl04_n,
--         pc.level05_code as pr_lvl05_c,  pc.level05_name as pr_lvl05_n,
--         pc.level06_code as pr_lvl06_c,  pc.level06_name as pr_lvl06_n,
--         pc.level07_code as pr_lvl07_c,  pc.level07_name as pr_lvl07_n,
--         pc.level08_code as pr_lvl08_c,  pc.level08_name as pr_lvl08_n,
--         pc.level09_code as pr_lvl09_c,  pc.level09_name as pr_lvl09_n,        
--         pc.level10_code as pr_lvl10_c,  pc.level10_name as pr_lvl10_n, 
         
         pr.level01_code as pr_lvl01_c,  pr.level01_name as pr_lvl01_n,
         pr.level02_code as pr_lvl02_c,  pr.level02_name as pr_lvl02_n,
         pr.level03_code as pr_lvl03_c,  pr.level03_name as pr_lvl03_n,
         pr.level04_code as pr_lvl04_c,  pr.level04_name as pr_lvl04_n,
         pr.level05_code as pr_lvl05_c,  pr.level05_name as pr_lvl05_n,
         pr.level06_code as pr_lvl06_c,  pr.level06_name as pr_lvl06_n,
         pr.level07_code as pr_lvl07_c,  pr.level07_name as pr_lvl07_n,
         pr.level08_code as pr_lvl08_c,  pr.level08_name as pr_lvl08_n,
         pr.level09_code as pr_lvl09_c,  pr.level09_name as pr_lvl09_n,        
         pr.level10_code as pr_lvl10_c,  pr.level10_name as pr_lvl10_n,  
         
         sum(sales_line_qty)                                             as py_sales_line_qty,
         sum(sales_line_qty_kg)                                          as py_sales_line_qty_kg,
         sum(sales_line_qty_l)                                           as py_sales_line_qty_l,
         sum(net_sales_line_amt * coalesce(ex.exchange_rate_float, 1))   as py_net_sales_line_amt,
         sum(net_margin_line_amt * coalesce(ex.exchange_rate_float, 1))  as py_net_margin_line_amt

from     f_sales_all_daily f 
         inner join d_date d                     on  f.accounting_date_sid = d.date_sid
         inner join d_company co                 on  f.company_sid = co.company_sid
         inner join v_profit_center_bi pc        on  f.sales_point_sid = pc.profit_center_sid
         inner join v_product_bi pr              on  f.product_sid = pr.product_sid               and pr.hierarchy_ext_refr = 'PR|SAP'
         inner join d_exchange_rate ex           on  f.currency_sid = ex.currency_from_sid 
                                                 and f.country_sid = ex.country_sid                
                                                 and accounting_date_sid /*between to_number(to_char(eff_fm_dt, 'yyyymmdd')) and*/ = to_number(to_char(eff_to_dt, 'yyyymmdd'))
                                                 and exchange_rate_type_ext_refr = 'D'
                                                 and ex.currency_to_ext_refr = 'EUR'     

where    1 = 1
and      f.accounting_date_sid between 20190401 and 20190499
and      f.is_own_usage = 0
and      pr.level01_code <> '06'
and      ((pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and co.company_code in ('1000', '3000')) or (pc.hierarchy_ext_refr = 'PC|PIS' and co.company_code in ('812820', '812892', '812968', '812969')))

group by 
         d.month_id,
         co.country_ext_refr, 
         co.company_code, co.name, 
         case when pc.level05_code in ('0P111')                                          then 'MP' 
              when pc.level05_code in ('0P116','0P117','0P118')                          then 'VP'
              when pc.level05_code in ('0P11A','0P11B','0P112','0P114','0P115','0P161')  then 'Ostali kanali'
              when pc.level03_code in ('6801', '4803', '3203', '6901')                   then 'MP'
              when pc.level03_code in ('6802','4802', '3202', '6902')                    then 'VP'
              else 'NERAZPOREJENO' 
              end,
           
         case when pc.level05_code in ('0P111')                                          then pc.level06_code
              when pc.level05_code in ('0P116','0P117','0P118')                          then pc.level05_code
              when pc.level05_code in ('0P11A','0P11B','0P112','0P114','0P115','0P161')  then pc.level05_code
              when pc.level03_code in ('4803')                                           then pc.level04_code
              when pc.level03_code in ('6801', '3203', '6901', '4802', '6802', '6902')   then pc.level03_code
              else pc.profit_center_code || ' - ' || pc.profit_center_name
              end,

         case when pc.level05_code in ('0P111')                                          then pc.level06_name
              when pc.level05_code in ('0P116','0P117','0P118')                          then pc.level05_name
              when pc.level05_code in ('0P11A','0P11B','0P112','0P114','0P115','0P161')  then pc.level05_name
              when pc.level03_code in ('4803')                                           then pc.level04_name
              when pc.level03_code in ('6801', '3203', '6901', '4802', '6802', '6902')   then pc.level03_name
              else pc.profit_center_code || ' - ' || pc.profit_center_name
              end,
         
--         pc.level01_code,  pc.level01_name,
--         pc.level02_code,  pc.level02_name,
--         pc.level03_code,  pc.level03_name,
--         pc.level04_code,  pc.level04_name,
--         pc.level05_code,  pc.level05_name,
--         pc.level06_code,  pc.level06_name,
--         pc.level07_code,  pc.level07_name,
--         pc.level08_code,  pc.level08_name,
--         pc.level09_code,  pc.level09_name,        
--         pc.level10_code,  pc.level10_name, 
         
         pr.level01_code,  pr.level01_name,
         pr.level02_code,  pr.level02_name,
         pr.level03_code,  pr.level03_name,
         pr.level04_code,  pr.level04_name,
         pr.level05_code,  pr.level05_name,
         pr.level06_code,  pr.level06_name,
         pr.level07_code,  pr.level07_name,
         pr.level08_code,  pr.level08_name,
         pr.level09_code,  pr.level09_name,        
         pr.level10_code,  pr.level10_name,  
         1

-------- --------------------------------------------------------------------------------------------------------------------
), bu (
-------- --------------------------------------------------------------------------------------------------------------------

select
         d.month_id,
         co.country_ext_refr, 
         co.company_code, co.name, 
         case when pc.level05_code in ('0P111')                                          then 'MP' 
              when pc.level05_code in ('0P116','0P117','0P118')                          then 'VP'
              when pc.level05_code in ('0P11A','0P11B','0P112','0P114','0P115','0P161')  then 'Ostali kanali'
              when pc.level03_code in ('6801', '4803', '3203', '6901')                   then 'MP'
              when pc.level03_code in ('6802','4802', '3202', '6902')                    then 'VP'
              else 'NERAZPOREJENO' 
              end as pc_lvl01,
           
         case when pc.level05_code in ('0P111')                                          then pc.level06_code
              when pc.level05_code in ('0P116','0P117','0P118')                          then pc.level05_code
              when pc.level05_code in ('0P11A','0P11B','0P112','0P114','0P115','0P161')  then pc.level05_code
              when pc.level03_code in ('4803')                                           then pc.level04_code
              when pc.level03_code in ('6801', '3203', '6901', '4802', '6802', '6902')   then pc.level03_code
              else pc.profit_center_code || ' - ' || pc.profit_center_name
              end as pc_lvl02_c,

         case when pc.level05_code in ('0P111')                                          then pc.level06_name
              when pc.level05_code in ('0P116','0P117','0P118')                          then pc.level05_name
              when pc.level05_code in ('0P11A','0P11B','0P112','0P114','0P115','0P161')  then pc.level05_name
              when pc.level03_code in ('4803')                                           then pc.level04_name
              when pc.level03_code in ('6801', '3203', '6901', '4802', '6802', '6902')   then pc.level03_name
              else pc.profit_center_code || ' - ' || pc.profit_center_name
              end as pc_lvl02_n,
         
--         pc.level01_code as pr_lvl01_c,  pc.level01_name as pr_lvl01_n,
--         pc.level02_code as pr_lvl02_c,  pc.level02_name as pr_lvl02_n,
--         pc.level03_code as pr_lvl03_c,  pc.level03_name as pr_lvl03_n,
--         pc.level04_code as pr_lvl04_c,  pc.level04_name as pr_lvl04_n,
--         pc.level05_code as pr_lvl05_c,  pc.level05_name as pr_lvl05_n,
--         pc.level06_code as pr_lvl06_c,  pc.level06_name as pr_lvl06_n,
--         pc.level07_code as pr_lvl07_c,  pc.level07_name as pr_lvl07_n,
--         pc.level08_code as pr_lvl08_c,  pc.level08_name as pr_lvl08_n,
--         pc.level09_code as pr_lvl09_c,  pc.level09_name as pr_lvl09_n,        
--         pc.level10_code as pr_lvl10_c,  pc.level10_name as pr_lvl10_n, 
         
         pr.level01_code as pr_lvl01_c,  pr.level01_name as pr_lvl01_n,
         pr.level02_code as pr_lvl02_c,  pr.level02_name as pr_lvl02_n,
         pr.level03_code as pr_lvl03_c,  pr.level03_name as pr_lvl03_n,
         pr.level04_code as pr_lvl04_c,  pr.level04_name as pr_lvl04_n,
         pr.level05_code as pr_lvl05_c,  pr.level05_name as pr_lvl05_n,
         pr.level06_code as pr_lvl06_c,  pr.level06_name as pr_lvl06_n,
         pr.level07_code as pr_lvl07_c,  pr.level07_name as pr_lvl07_n,
         pr.level08_code as pr_lvl08_c,  pr.level08_name as pr_lvl08_n,
         pr.level09_code as pr_lvl09_c,  pr.level09_name as pr_lvl09_n,        
         pr.level10_code as pr_lvl10_c,  pr.level10_name as pr_lvl10_n,  
         
         sum(sales_line_qty)                                             as bu_sales_line_qty,
         sum(sales_line_qty_kg)                                          as bu_sales_line_qty_kg,
         sum(sales_line_qty_l)                                           as bu_sales_line_qty_l,
         sum(net_sales_line_amt * coalesce(ex.exchange_rate_float, 1))   as bu_net_sales_line_amt,
         sum(net_margin_line_amt * coalesce(ex.exchange_rate_float, 1))  as bu_net_margin_line_amt

from     f_sales_plan_daily f 
         inner join d_date d                     on  f.date_sid = d.date_sid
         inner join d_company co                 on  f.company_sid = co.company_sid
         inner join v_profit_center_bi pc        on  f.profit_center_sid = pc.profit_center_sid
         inner join v_product_bi pr              on  f.product_sid = pr.product_sid               and pr.hierarchy_ext_refr = 'PR|SAP'
         inner join d_exchange_rate ex           on  f.currency_sid = ex.currency_from_sid 
                                                 and f.country_sid = ex.country_sid                
                                                 and accounting_date_sid /*between to_number(to_char(eff_fm_dt, 'yyyymmdd')) and*/ = to_number(to_char(eff_to_dt, 'yyyymmdd'))
                                                 and exchange_rate_type_ext_refr = 'D'
                                                 and ex.currency_to_ext_refr = 'EUR'     

where    1 = 1
and      f.date_sid between 20190401 and 20190499
and      f.is_own_usage = 0
and      pr.level01_code <> '06'
and      ((pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and co.company_code in ('1000', '3000')) or (pc.hierarchy_ext_refr = 'PC|PIS' and co.company_code in ('812820', '812892', '812968', '812969')))

group by 
         d.month_id,
         co.country_ext_refr, 
         co.company_code, co.name, 
         case when pc.level05_code in ('0P111')                                          then 'MP' 
              when pc.level05_code in ('0P116','0P117','0P118')                          then 'VP'
              when pc.level05_code in ('0P11A','0P11B','0P112','0P114','0P115','0P161')  then 'Ostali kanali'
              when pc.level03_code in ('6801', '4803', '3203', '6901')                   then 'MP'
              when pc.level03_code in ('6802','4802', '3202', '6902')                    then 'VP'
              else 'NERAZPOREJENO' 
              end,
           
         case when pc.level05_code in ('0P111')                                          then pc.level06_code
              when pc.level05_code in ('0P116','0P117','0P118')                          then pc.level05_code
              when pc.level05_code in ('0P11A','0P11B','0P112','0P114','0P115','0P161')  then pc.level05_code
              when pc.level03_code in ('4803')                                           then pc.level04_code
              when pc.level03_code in ('6801', '3203', '6901', '4802', '6802', '6902')   then pc.level03_code
              else pc.profit_center_code || ' - ' || pc.profit_center_name
              end,

         case when pc.level05_code in ('0P111')                                          then pc.level06_name
              when pc.level05_code in ('0P116','0P117','0P118')                          then pc.level05_name
              when pc.level05_code in ('0P11A','0P11B','0P112','0P114','0P115','0P161')  then pc.level05_name
              when pc.level03_code in ('4803')                                           then pc.level04_name
              when pc.level03_code in ('6801', '3203', '6901', '4802', '6802', '6902')   then pc.level03_name
              else pc.profit_center_code || ' - ' || pc.profit_center_name
              end,
         
--         pc.level01_code,  pc.level01_name,
--         pc.level02_code,  pc.level02_name,
--         pc.level03_code,  pc.level03_name,
--         pc.level04_code,  pc.level04_name,
--         pc.level05_code,  pc.level05_name,
--         pc.level06_code,  pc.level06_name,
--         pc.level07_code,  pc.level07_name,
--         pc.level08_code,  pc.level08_name,
--         pc.level09_code,  pc.level09_name,        
--         pc.level10_code,  pc.level10_name, 
         
         pr.level01_code,  pr.level01_name,
         pr.level02_code,  pr.level02_name,
         pr.level03_code,  pr.level03_name,
         pr.level04_code,  pr.level04_name,
         pr.level05_code,  pr.level05_name,
         pr.level06_code,  pr.level06_name,
         pr.level07_code,  pr.level07_name,
         pr.level08_code,  pr.level08_name,
         pr.level09_code,  pr.level09_name,        
         pr.level10_code,  pr.level10_name,  
         1


-------- --------------------------------------------------------------------------------------------------------------------
) -- END 
-------- --------------------------------------------------------------------------------------------------------------------

select 
         coalesce(ac.month_id,         py.month_id,         bu.month_id)                 as month_id,        
         coalesce(ac.country_ext_refr, py.country_ext_refr, bu.country_ext_refr)         as country_ext_refr,
         coalesce(ac.company_code,     py.company_code,     bu.company_code)             as company_code,
         coalesce(ac.name,             py.name,             bu.name)                     as name,           
         coalesce(ac.pc_lvl01,         py.pc_lvl01,         bu.pc_lvl01)                 as pc_lvl01,        
         coalesce(ac.pc_lvl02_c,       py.pc_lvl02_c,       bu.pc_lvl02_c)               as pc_lvl02_c,     
         coalesce(ac.pc_lvl02_n,       py.pc_lvl02_n,       bu.pc_lvl02_n)               as pc_lvl02_n,      
         
--         coalesce(ac.pc_lvl01_c, py.pc_lvl01_c, bu.pc_lvl01_c) as pc_lvl01_c,    coalesce(ac.pc_lvl01_n, py.pc_lvl01_n, bu.pc_lvl01_n) as pc_lvl01_n,    
--         coalesce(ac.pc_lvl02_c, py.pc_lvl02_c, bu.pc_lvl02_c) as pc_lvl02_c,    coalesce(ac.pc_lvl02_n, py.pc_lvl02_n, bu.pc_lvl02_n) as pc_lvl02_n,    
--         coalesce(ac.pc_lvl03_c, py.pc_lvl03_c, bu.pc_lvl03_c) as pc_lvl03_c,    coalesce(ac.pc_lvl03_n, py.pc_lvl03_n, bu.pc_lvl03_n) as pc_lvl03_n,    
--         coalesce(ac.pc_lvl04_c, py.pc_lvl04_c, bu.pc_lvl04_c) as pc_lvl04_c,    coalesce(ac.pc_lvl04_n, py.pc_lvl04_n, bu.pc_lvl04_n) as pc_lvl04_n,    
--         coalesce(ac.pc_lvl05_c, py.pc_lvl05_c, bu.pc_lvl05_c) as pc_lvl05_c,    coalesce(ac.pc_lvl05_n, py.pc_lvl05_n, bu.pc_lvl05_n) as pc_lvl05_n,    
--         coalesce(ac.pc_lvl06_c, py.pc_lvl06_c, bu.pc_lvl06_c) as pc_lvl06_c,    coalesce(ac.pc_lvl06_n, py.pc_lvl06_n, bu.pc_lvl06_n) as pc_lvl06_n,    
--         coalesce(ac.pc_lvl07_c, py.pc_lvl07_c, bu.pc_lvl07_c) as pc_lvl07_c,    coalesce(ac.pc_lvl07_n, py.pc_lvl07_n, bu.pc_lvl07_n) as pc_lvl07_n,    
--         coalesce(ac.pc_lvl08_c, py.pc_lvl08_c, bu.pc_lvl08_c) as pc_lvl08_c,    coalesce(ac.pc_lvl08_n, py.pc_lvl08_n, bu.pc_lvl08_n) as pc_lvl08_n,    
--         coalesce(ac.pc_lvl09_c, py.pc_lvl09_c, bu.pc_lvl09_c) as pc_lvl09_c,    coalesce(ac.pc_lvl09_n, py.pc_lvl09_n, bu.pc_lvl09_n) as pc_lvl09_n,                    
--         coalesce(ac.pc_lvl10_c, py.pc_lvl10_c, bu.pc_lvl10_c) as pc_lvl10_c,    coalesce(ac.pc_lvl10_n, py.pc_lvl10_n, bu.pc_lvl10_n) as pc_lvl10_n,   
         
--         coalesce(ac.pr_lvl01_c, py.pr_lvl01_c, bu.pr_lvl01_c) as pr_lvl01_c,    coalesce(ac.pr_lvl01_n, py.pr_lvl01_n, bu.pr_lvl01_n) as pr_lvl01_n,    
--         coalesce(ac.pr_lvl02_c, py.pr_lvl02_c, bu.pr_lvl02_c) as pr_lvl02_c,    coalesce(ac.pr_lvl02_n, py.pr_lvl02_n, bu.pr_lvl02_n) as pr_lvl02_n,    
--         coalesce(ac.pr_lvl03_c, py.pr_lvl03_c, bu.pr_lvl03_c) as pr_lvl03_c,    coalesce(ac.pr_lvl03_n, py.pr_lvl03_n, bu.pr_lvl03_n) as pr_lvl03_n,    
--         coalesce(ac.pr_lvl04_c, py.pr_lvl04_c, bu.pr_lvl04_c) as pr_lvl04_c,    coalesce(ac.pr_lvl04_n, py.pr_lvl04_n, bu.pr_lvl04_n) as pr_lvl04_n,    
--         coalesce(ac.pr_lvl05_c, py.pr_lvl05_c, bu.pr_lvl05_c) as pr_lvl05_c,    coalesce(ac.pr_lvl05_n, py.pr_lvl05_n, bu.pr_lvl05_n) as pr_lvl05_n,    
--         coalesce(ac.pr_lvl06_c, py.pr_lvl06_c, bu.pr_lvl06_c) as pr_lvl06_c,    coalesce(ac.pr_lvl06_n, py.pr_lvl06_n, bu.pr_lvl06_n) as pr_lvl06_n,    
--         coalesce(ac.pr_lvl07_c, py.pr_lvl07_c, bu.pr_lvl07_c) as pr_lvl07_c,    coalesce(ac.pr_lvl07_n, py.pr_lvl07_n, bu.pr_lvl07_n) as pr_lvl07_n,    
--         coalesce(ac.pr_lvl08_c, py.pr_lvl08_c, bu.pr_lvl08_c) as pr_lvl08_c,    coalesce(ac.pr_lvl08_n, py.pr_lvl08_n, bu.pr_lvl08_n) as pr_lvl08_n,    
--         coalesce(ac.pr_lvl09_c, py.pr_lvl09_c, bu.pr_lvl09_c) as pr_lvl09_c,    coalesce(ac.pr_lvl09_n, py.pr_lvl09_n, bu.pr_lvl09_n) as pr_lvl09_n,                    
--         coalesce(ac.pr_lvl10_c, py.pr_lvl10_c, bu.pr_lvl10_c) as pr_lvl10_c,    coalesce(ac.pr_lvl10_n, py.pr_lvl10_n, bu.pr_lvl10_n) as pr_lvl10_n,      

         ac_sales_line_qty,
         ac_sales_line_qty_kg,
         ac_sales_line_qty_l,
         ac_net_sales_line_amt,
         ac_net_margin_line_amt,        
         py_sales_line_qty,
         py_sales_line_qty_kg,
         py_sales_line_qty_l,
         py_net_sales_line_amt,
         py_net_margin_line_amt,
         bu_sales_line_qty,
         bu_sales_line_qty_kg,
         bu_sales_line_qty_l,
         bu_net_sales_line_amt,
         bu_net_margin_line_amt,
         1
                 
from     ac
         full join py    on  ac.month_id         = py.month_id        
                         and ac.country_ext_refr = py.country_ext_refr
                         and ac.company_code     = py.company_code    
                         and ac.name             = py.name            
                         and ac.pc_lvl01         = py.pc_lvl01        
                         and ac.pc_lvl02_c       = py.pc_lvl02_c      
                         and ac.pc_lvl02_n       = py.pc_lvl02_n      
                                         
         full join bu    on  ac.month_id         = bu.month_id        
                         and ac.country_ext_refr = bu.country_ext_refr
                         and ac.company_code     = bu.company_code    
                         and ac.name             = bu.name            
                         and ac.pc_lvl01         = bu.pc_lvl01        
                         and ac.pc_lvl02_c       = bu.pc_lvl02_c      
                         and ac.pc_lvl02_n       = bu.pc_lvl02_n 
         
         
         
         
         
         
         