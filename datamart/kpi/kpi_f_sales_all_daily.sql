use database dwh_prod;
use schema aplsdb;

-- ##### SALES DATA ########################################################################################################################################################
with sales as (
select 
         d.month_id,
         f.country_ext_refr,
         f.company_code_pis,
         f.company_code,
         f.company_name,
         f.accounting_date_sid,
         f.accounting_date,
         f.payment_method,
         f.profit_center_ext_refr,
         f.pc_level01_ext_refr,
         f.pc_level02_ext_refr,
         f.pc_level03_ext_refr,         
         f.pc_level04_ext_refr,
         f.pc_level05_ext_refr,
         f.pc_level06_ext_refr,
         f.pc_level07_ext_refr,
         f.profit_center_code,
         f.profit_center_name,
         f.pc_l1,
         f.pc_l1_name,
         f.pc_l2,
         f.pc_l2_name,
         f.pc_l3,
         f.pc_l3_name,
         f.pc_l4,
         f.pc_l4_name,
         f.pc_l5,
         f.pc_l5_name,
         f.pc_l6,
         f.pc_l6_name,
         f.pc_l7,
         f.pc_l7_name,
         f.pr_l1,
         f.pr_l1_name,
         f.pr_l2,
         f.pr_l2_name,
         f.pr_l3,
         f.pr_l3_name,
         f.pr_l4,
         f.pr_l4_name,                                                              
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

from     dm_bs_sales_all f 
         inner join d_date d on f.accounting_date_sid = date_sid
where    1 = 1
and      d.date_sid between 20200101 and 20200131
and      f.is_aggregated = 0
and      f.is_own_usage = 0
and      f.pr_l4 = '010101001'

group by
         d.month_id,
         f.country_ext_refr,
         f.company_code_pis,
         f.company_code,
         f.company_name,
         f.accounting_date_sid,
         f.accounting_date,
         f.payment_method,
         f.profit_center_ext_refr,
         f.profit_center_code,
         f.profit_center_name,
         f.bs_geografsko,
         f.lokacija_bs,
         f.bs_po_regijah,
         f.instruktorji,
         f.prodajna_povrsina,
         f.pc_level01_ext_refr,
         f.pc_l1,
         f.pc_l1_name,
         f.pc_level02_ext_refr,
         f.pc_l2,
         f.pc_l2_name,
         f.pc_level03_ext_refr,
         f.pc_l3,
         f.pc_l3_name,
         f.pc_level04_ext_refr,
         f.pc_l4,
         f.pc_l4_name,
         f.pc_level05_ext_refr,
         f.pc_l5,
         f.pc_l5_name,
         f.pc_level06_ext_refr,
         f.pc_l6,
         f.pc_l6_name,
         f.pc_level07_ext_refr,
         f.pc_l7,
         f.pc_l7_name,
         f.pr_l1,
         f.pr_l1_name,
         f.pr_l2,
         f.pr_l2_name,
         f.pr_l3,
         f.pr_l3_name,
         f.pr_l4,
         f.pr_l4_name,
         1

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
         right join (select year, month_id,  from sales          
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
         
         
         
         
         
         
         