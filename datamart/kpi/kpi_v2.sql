use database dwh_prod;
use schema aplsdb;

-- ##### SALES DATA ########################################################################################################################################################
with sales as (
;
select 
         f.accounting_date_sid, d.date_sid ac_date_sid, dpy.date_sid py_date_sid,
--         d.month_id,
--         co.country_ext_refr, 
--         case when co.company_code = '821071' then '3000' else co.company_code end                                   as company_code, 
--         case when co.company_code = '821071' then 'Petrol d.o.o., Zagreb' else co.name end                          as company_name, 
--         case when pc.level05_code in ('0P111')                                           then pc.level05_code
--              when pc.level03_code in ('6801', '4803', '3203', '6901')                    then pc.level03_code
--              else 'N/A' 
--              end                                                                                                    as maloprodaja_code,
--         case when pc.level05_code in ('0P111')                                           then pc.level05_name 
--              when pc.level03_code in ('6801', '4803', '3203', '6901')                    then pc.level03_name
--              else 'N/A' 
--              end                                                                                                    as maloprodaja_name,                        
--         case when pc.level05_code in ('0P111')                                           then pc.level07_code
--              when pc.level03_code in ('6801', '3203', '6901')                            then pc.level04_code
--              when pc.level03_code in ('4803')                                            then pc.level05_code
--              else 'N/A' 
--              end                                                                                                    as pm_code,
--         case when pc.level05_code in ('0P111')                                           then pc.level07_name 
--              when pc.level03_code in ('6801', '3203', '6901')                            then pc.level04_name
--              when pc.level03_code in ('4803')                                            then pc.level05_name
--              else 'N/A' 
--              end                                                                                                    as pm_name,    
         
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
         
--         pr.level01_code as pr_level01_code,  pr.level01_name as pr_level01_name,
--         pr.level02_code as pr_level02_code,  pr.level02_name as pr_level02_name,
--         pr.level03_code as pr_level03_code,  pr.level03_name as pr_level03_name,
--         pr.level04_code as pr_level04_code,  pr.level04_name as pr_level04_name,
--         pr.level05_code as pr_level05_code,  pr.level05_name as pr_levell05_name,
--         pr.level06_code as pr_level06_code,  pr.level06_name as pr_levell06_name,
--         pr.level07_code as pr_level07_code,  pr.level07_name as pr_levell07_name,
--         pr.level08_code as pr_level08_code,  pr.level08_name as pr_levell08_name,
--         pr.level09_code as pr_level09_code,  pr.level09_name as pr_levell09_name,        
--         pr.level10_code as pr_level10_code,  pr.level10_name as pr_levell10_name,      

         sum(case when d.date_sid = accounting_date_sid   then sales_line_qty                                            end) as ac_sales_line_qty,
         sum(case when d.date_sid = accounting_date_sid   then sales_line_qty_kg                                         end) as ac_sales_line_qty_kg,
         sum(case when d.date_sid = accounting_date_sid   then sales_line_qty_l                                          end) as ac_sales_line_qty_l,
         sum(case when d.date_sid = accounting_date_sid   then net_sales_line_amt * coalesce(ex.exchange_rate_float, 1)  end) as ac_net_sales_line_amt,
         sum(case when d.date_sid = accounting_date_sid   then net_margin_line_amt * coalesce(ex.exchange_rate_float, 1) end) as ac_net_margin_line_amt,
         sum(case when dpy.date_sid = accounting_date_sid - 10000 then sales_line_qty                                            end) as py_sales_line_qty,
         sum(case when dpy.date_sid = accounting_date_sid - 10000 then sales_line_qty_kg                                         end) as py_sales_line_qty_kg,
         sum(case when dpy.date_sid = accounting_date_sid - 10000 then sales_line_qty_l                                          end) as py_sales_line_qty_l,
         sum(case when dpy.date_sid = accounting_date_sid - 10000 then net_sales_line_amt * coalesce(ex.exchange_rate_float, 1)  end) as py_net_sales_line_amt,
         sum(case when dpy.date_sid = accounting_date_sid - 10000 then net_margin_line_amt * coalesce(ex.exchange_rate_float, 1) end) as py_net_margin_line_amt,         
         case when accounting_date_sid in d.date_sid then 'ac' else null end ac,
         (case when to_number(substr(f_sales_all_daily.accounting_date_sid, 0, 4)) in (to_number(to_char(year(current_date) - 1)), to_number(to_char(year(current_date) - 2))) then 'py' else null end) py,
         f_sales_all_daily.accounting_date_sid,
                 
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
         inner join (select date_sid from d_date where dpy                   on  f.accounting_date_sid = dpy.py_date_id
         inner join d_company co                 on  f.company_sid = co.company_sid
         inner join v_profit_center_bi pc        on  f.sales_point_sid = pc.profit_center_sid
         inner join v_product_bi pr              on  f.product_sid = pr.product_sid               and pr.hierarchy_ext_refr = 'PR|SAP'
         inner join d_exchange_rate ex           on  f.currency_sid = ex.currency_from_sid 
                                                 and f.country_sid = ex.country_sid                
                                                 and accounting_date_sid = to_number(to_char(eff_to_dt, 'yyyymmdd'))
                                                 and exchange_rate_type_ext_refr = 'D'
                                                 and ex.currency_to_ext_refr = 'EUR'     

where    1 = 1
--and      f.accounting_date_sid between to_number(to_char(dateadd(years, -3, current_date), 'yyyy0101'))
--                                   and to_number(to_char(dateadd(day, -1, current_date), 'yyyymmdd'))
--and      (d.date_sid between 20200101 and 20200131 or dpy.date_sid and 20200101 and 20200131)
and      f.accounting_date_sid between 20190101 and 20201299
and      f.is_own_usage = 0
and      ((pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and co.company_code in ('1000', '3000')) or (pc.hierarchy_ext_refr = 'PC|PIS' and co.company_code in ('812820', '812892', '812968', '812969')))

and      pc.level07_code = '0000101101'
and      pr.level04_code = '010202002'



group by 
         f.accounting_date_sid, d.date_sid, dpy.date_sid;,
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
         
         pr.level01_code,  pr.level01_name,
         pr.level02_code,  pr.level02_name,
         pr.level03_code,  pr.level03_name,
         pr.level04_code,  pr.level04_name,
         1

;



-- ##### SALES ROLLUP #########################################################################################################################################################
)--, sales_rollup as (
select 
         year,
         month_id,
         company_code,
         iff(company_code is null, null, min(company_name)) as company_name,                                                          
         sum(sales_line_qty_ac)			as sales_line_qty_ac,
         sum(sales_line_qty_kg_ac)			as sales_line_qty_kg_ac,
         sum(sales_line_qty_l_ac)			as sales_line_qty_l_ac,
         sum(net_sales_line_amt_eur_ac)		as net_sales_line_amt_eur_ac,
         sum(net_margin_line_amt_eur_ac)		as net_margin_line_amt_eur_ac,
         sum(sales_line_qty_py)			as sales_line_qty_py,
         sum(sales_line_qty_kg_py)			as sales_line_qty_kg_py,
         sum(sales_line_qty_l_py)			as sales_line_qty_l_py,
         sum(net_sales_line_amt_eur_py)		as net_sales_line_amt_eur_py,
         sum(net_margin_line_amt_eur_py)		as net_margin_line_amt_eur_py,
         sum(sales_line_qty_bu)			as sales_line_qty_bu,
         sum(sales_line_qty_kg_bu)			as sales_line_qty_kg_bu,
         sum(sales_line_qty_l_bu)			as sales_line_qty_l_bu,
         sum(net_sales_line_amt_eur_bu)		as net_sales_line_amt_eur_bu,
         sum(net_margin_line_amt_eur_bu)		as net_margin_line_amt_eur_bu,
         sum(sales_line_qty_fc)			as sales_line_qty_fc,
         sum(sales_line_qty_kg_fc)			as sales_line_qty_kg_fc,
         sum(sales_line_qty_l_fc)			as sales_line_qty_l_fc,
         sum(net_sales_line_amt_eur_fc)		as net_sales_line_amt_eur_fc,
         sum(net_margin_line_amt_eur_fc)              as net_margin_line_amt_eur_fc

from     sales
group by
         year,
         rollup(
         month_id,
         company_code)

order by 1 nulls first, 2 nulls first, 3 nulls first
;


-- ##### ATTRIBUTE #########################################################################################################################################################
), bs_attribute as (
select   
--         *
         d.year,
         d.month_id,
         case when co.company_code = '821071' then '3000' else co.company_code end                               as company_code,
         case when co.company_code = '821071' then 'Petrol d.o.o., Zagreb' else co.name end                      as company_name,
--         d.last_day_of_month,
--         pca.eff_from_date_sid,
--         pca.eff_to_date_sid,
--         pc.profit_center_ext_refr,
--         pc.profit_center_code,
         case  when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and pc.level05_code in ('0P111')                  then pc.level05_code
               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('4803', '6801', '3203', '6901')   then pc.level03_code
               else 'N/A'
               end  as mp_code,
         
         case  when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and pc.level05_code in ('0P111')                  then pc.level05_name                     
               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('4803', '6801', '3203', '6901')   then pc.level03_name
               else 'N/A'
               end as mp_name,
         
         case  when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and pc.level05_code in ('0P111')                  then pc.level07_code
               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('4803')                           then pc.level05_code
               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('6801', '3203', '6901')           then pc.level04_code
               else 'N/A'
               end  as bs_code,
         
         case  when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and pc.level05_code in ('0P111')                  then pc.level07_name
               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('4803')                           then pc.level05_name
               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('6801', '3203', '6901')           then pc.level04_name
               else 'N/A'
               end  as bs_name, 
         max(case when pca.attribute_name = 'AKTIVNOST NA BS'                                                            and d.date_sid between pca.eff_from_date_sid and pca.eff_to_date_sid then pca.attribute_value_string end)                as aktivnost_na_bs,
         max(case when pca.attribute_name = 'BS GEOGRAFSKO'                                                              and d.date_sid between pca_akt.eff_from_date_sid and pca_akt.eff_to_date_sid then pca.attribute_value_string end)        as bs_geografsko,
         max(case when pca.attribute_name = 'LOKACIJA BS'                                                                and d.date_sid between pca_akt.eff_from_date_sid and pca_akt.eff_to_date_sid then pca.attribute_value_string end)        as lokacija_bs,   
         max(case when pca.attribute_name = 'PRODAJNA POVRŠINA'                                                          and d.date_sid between pca_akt.eff_from_date_sid and pca_akt.eff_to_date_sid then pca.attribute_value_numeric end)       as prodajna_povrsina,
         max(case when pca.attribute_name in ('BS po regijah', 'BS po regijah Petrol Beograd')                           and d.date_sid between pca_akt.eff_from_date_sid and pca_akt.eff_to_date_sid then pca.attribute_value_string end)        as bs_po_regijah,                  
         max(case when pca.attribute_name in ('INŠTRUKTORJI Slovenija', 'INŠTRUKTORJI Hrvaška', 'INŠTRUKTORJI BiH')      and d.date_sid between pca_akt.eff_from_date_sid and pca_akt.eff_to_date_sid then pca.attribute_value_string end)        as instruktorji,                  
         1

from     d_date d
         cross join v_profit_center_bi pc
         left join d_company co                      on pc.company_sid = co.company_sid
         left join d_profit_center_attribute pca     on pc.profit_center_sid = pca.profit_center_sid         
         left join d_profit_center_attribute pca_akt on pc.profit_center_sid = pca_akt.profit_center_sid    and pca_akt.attribute_name = 'AKTIVNOST NA BS' -- DELETE WHEN ATTRIBUTES GO SCD2
         
where    1 = 1
and      d.is_last_day_of_month = 1 
and      d.date_sid between 20170101 and to_number(to_char(dateadd(day, -1, current_date), 'yyyymmdd'))
and      co.company_code <> 'N/A'
and      bs_code <> 'N/A'
--and      pc.profit_center_code = '0000101101'
--and      pc.profit_center_code = '0000301617'
and      (
          (pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and pc.level05_code = '0P111') or 
          (pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('4803', '6801', '3203', '6901'))
         )
         
group by
         d.year,
         d.month_id,
         case when co.company_code = '821071' then '3000' else co.company_code end,
         case when co.company_code = '821071' then 'Petrol d.o.o., Zagreb' else co.name end,         
--         d.last_day_of_month,
--         pca.eff_from_date_sid,
--         pca.eff_to_date_sid,
--         pc.profit_center_ext_refr,
--         pc.profit_center_code,
         case  when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and pc.level05_code in ('0P111')                  then pc.level05_code
               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('4803', '6801', '3203', '6901')   then pc.level03_code
               else 'N/A'
               end,
         
         case  when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and pc.level05_code in ('0P111')                  then pc.level05_name                     
               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('4803', '6801', '3203', '6901')   then pc.level03_name
               else 'N/A'
               end,
         
         case  when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and pc.level05_code in ('0P111')                  then pc.level07_code
               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('4803')                           then pc.level05_code
               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('6801', '3203', '6901')           then pc.level04_code
               else 'N/A'
               end,
         
         case  when pc.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and pc.level05_code in ('0P111')                  then pc.level07_name
               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('4803')                           then pc.level05_name
               when pc.hierarchy_ext_refr = 'PC|PIS' and pc.level03_code in ('6801', '3203', '6901')           then pc.level04_name
               else 'N/A'
               end, 
--         pca.attribute_value_string,
         1        

qualify  count(aktivnost_na_bs) over (partition by bs_code) > 1

-- ##### ATTRIBUTE ROLLUP ###############################################################################################################################################################
), attribute_rollup as (

select
         year, 
         month_id,
         company_code,
         iff(company_code is null, null, min(company_name))    as company_name,
         iff(company_code is null, null, min(mp_code))         as mp_code,        
         iff(company_code is null, null, min(mp_name))         as mp_name,        
         count(aktivnost_na_bs)                                as aktivnost_na_bs,
         sum(prodajna_povrsina)                                as prodajna_povrsina,
         1
         
from     bs_attribute a
         right join 
                  on a.month_id = s.month_id 
                  and a.company_code = s.company_code

group by
         year,
         month_id,
         rollup (company_code)
;
union all

select   year,
         null                       as month_id,
         null                       as company_code,
         null                       as company_name,
         null                       as mp_code,        
         null                       as mp_name,
         avg(aktivnost_na_bs)       as aktivnost_na_bs,
         avg(prodajna_povrsina)     as prodajna_povrsina,
         1         
from     
         (
                  select   year, month_id, count(aktivnost_na_bs) as aktivnost_na_bs, sum(prodajna_povrsina) as prodajna_povrsina         
                  from     bs_attribute a
                  group by year, month_id
         ) temp
         
group by year

-- ##### CALCULATED KPI ###############################################################################################################################################################
), calculated_kpi as (






















-- #####################
select
         s.month_id,       
         a.aktivnost_na_bs,
         a.mp_code,
         a.bs_code,
         count(a.aktivnost_na_bs) over (partition by a.month_id, a.mp_code),
         *,
----         s.sales_line_qty_ac         / coalesce(count(a.aktivnost_na_bs) over (partition by a.month_id, a.mp_code), 1),
----         s.sales_line_qty_kg_ac      / coalesce(count(a.aktivnost_na_bs) over (partition by a.month_id, a.mp_code), 1),                          
----         s.sales_line_qty_l_ac       / coalesce(count(a.aktivnost_na_bs) over (partition by a.month_id, a.mp_code), 1),                           
----         s.net_sales_line_amt_eur_ac / coalesce(count(a.aktivnost_na_bs) over (partition by a.month_id, a.mp_code), 1),                      
----         s.net_margin_line_amt_eur_ac/ coalesce(count(a.aktivnost_na_bs) over (partition by a.month_id, a.mp_code), 1),                     
----         s.sales_line_qty_py         / coalesce(count(a.aktivnost_na_bs) over (partition by a.month_id, a.mp_code), 1),                     
----         s.sales_line_qty_kg_py      / coalesce(count(a.aktivnost_na_bs) over (partition by a.month_id, a.mp_code), 1),                          
----         s.sales_line_qty_l_py       / coalesce(count(a.aktivnost_na_bs) over (partition by a.month_id, a.mp_code), 1),                           
----         s.net_sales_line_amt_eur_py / coalesce(count(a.aktivnost_na_bs) over (partition by a.month_id, a.mp_code), 1),                      
----         s.net_margin_line_amt_eur_py/ coalesce(count(a.aktivnost_na_bs) over (partition by a.month_id, a.mp_code), 1),                     
----         s.sales_line_qty_bu         / coalesce(count(a.aktivnost_na_bs) over (partition by a.month_id, a.mp_code), 1),                             
----         s.sales_line_qty_kg_bu      / coalesce(count(a.aktivnost_na_bs) over (partition by a.month_id, a.mp_code), 1),                          
----         s.sales_line_qty_l_bu       / coalesce(count(a.aktivnost_na_bs) over (partition by a.month_id, a.mp_code), 1),                           
----         s.net_sales_line_amt_eur_bu / coalesce(count(a.aktivnost_na_bs) over (partition by a.month_id, a.mp_code), 1),                      
----         s.net_margin_line_amt_eur_bu/ coalesce(count(a.aktivnost_na_bs) over (partition by a.month_id, a.mp_code), 1),                     
----         s.sales_line_qty_fc         / coalesce(count(a.aktivnost_na_bs) over (partition by a.month_id, a.mp_code), 1),                             
----         s.sales_line_qty_kg_fc      / coalesce(count(a.aktivnost_na_bs) over (partition by a.month_id, a.mp_code), 1),                          
----         s.sales_line_qty_l_fc       / coalesce(count(a.aktivnost_na_bs) over (partition by a.month_id, a.mp_code), 1),                           
----         s.net_sales_line_amt_eur_fc / coalesce(count(a.aktivnost_na_bs) over (partition by a.month_id, a.mp_code), 1),                      
----         s.net_margin_line_amt_eur_fc/ coalesce(count(a.aktivnost_na_bs) over (partition by a.month_id, a.mp_code), 1),    
         1      

from     sales s
         left join bs_attribute a   
                  on s.month_id = a.month_id
                  and s.profit_center_code = a.bs_code
         
         
         
         
         
         
         