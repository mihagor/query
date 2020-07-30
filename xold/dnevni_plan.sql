select  * 

from    dwh_prod.aplsdb.f_sales_plan_daily f
        inner join dwh_prod.aplsdb.v_profit_center_bi pc        on f.profit_center_sid=pc.profit_center_sid     and pc.hierarchy_ext_refr ='PC|STD_SAP_PIS'
        inner join dwh_prod.aplsdb.v_product_bi pr              on f.product_sid=pr.product_sid                 and pr.hierarchy_ext_refr ='PR|SAP'
        inner join dwh_prod.aplsdb.d_company co                 on co.company_sid = f.company_sid

where   date_sid between 20200101 and 20200131 
and     scenario ='P'
and     version =1
and     is_own_usage = 0
and     pc.level05_code='0P117'
and     pr.level03_code='010101'
and     co.company_code='1000'
