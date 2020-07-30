USE DATABASE DWH_prod;
USE SCHEMA APLsdb;

---- novo 7.4.
with plan as ( 
---- novo 7.4.

SELECT  
        CO.COMPANY_CODE_PIS
        
 --popravek 7.4.        
        ,case when CO.COMPANY_CODE = '821071' then '3000' else CO.COMPANY_CODE end as COMPANY_CODE
        ,case when CO.COMPANY_CODE = '821071' then 'Petrol d.o.o., Zagreb' else CO.NAME end as COMPANY_NAME
 --popravek 7.4.
 
        ,T.DATE_SID ACCOUNTING_DATE_SID
 --popravek 6.4.          
        ,dat.ext_refr ACCOUNTING_DATE
--        ,dat.date_sid ACCOUNTING_DATE_sid        
 --popravek 6.4.  
        ,T44.PROFIT_CENTER_EXT_REFR 
        ,T44.PROFIT_CENTER_NAME
        ,NULL AS CUSTOMER_TYPE_CODE
        ,NULL AS CUSTOMER_TYPE
        ,T.IS_OWN_USAGE
        ,NULL AS PAYMENT_METHOD       
        ,PR.PRODUCT_CODE 
        ,PR.PRODUCT_NAME_SHORT 

    ,T44.LEVEL01_EXT_REFR PC_LEVEL01_EXT_REFR        
    ,T44.LEVEL02_EXT_REFR PC_LEVEL02_EXT_REFR     
    ,T44.LEVEL03_EXT_REFR PC_LEVEL03_EXT_REFR        
    , T44.LEVEL04_EXT_REFR PC_LEVEL04_EXT_REFR
    

-- popravek 7.4.     
--    ,T44.LEVEL05_EXT_REFR PC_LEVEL05_EXT_REFR        
--    ,T44.LEVEL06_EXT_REFR PC_LEVEL06_EXT_REFR      
--    ,T44.LEVEL07_EXT_REFR PC_LEVEL07_EXT_REFR         
--    ,T44.LEVEL08_EXT_REFR PC_LEVEL08_EXT_REFR
--    ,T44.LEVEL09_EXT_REFR PC_LEVEL09_EXT_REFR        
--    ,T44.LEVEL10_EXT_REFR PC_LEVEL10_EXT_REFR
        ,case   when t44.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and co.company_code in ('1000', '3000', '812820')      then t44.level05_ext_refr
                when t44.hierarchy_ext_refr = 'PC|PIS'         and co.company_code in ('812892', '812968', '812969')  then 'N/A'
                else t44.level05_ext_refr
                end  as pc_level05_ext_refr
                
        ,case   when t44.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and co.company_code in ('1000', '3000')                         then t44.level06_ext_refr
                when t44.hierarchy_ext_refr = 'PC|PIS'         and co.company_code in ('812820', '812892', '812968', '812969') then 'N/A'
                else t44.level06_ext_refr                
                end  as pc_level06_ext_refr
                
        ,case   when t44.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and co.company_code in ('1000', '3000')                         then t44.level07_ext_refr
                when t44.hierarchy_ext_refr = 'PC|PIS'         and co.company_code in ('812820', '812892', '812968', '812969') then 'N/A'
                else t44.level07_ext_refr
                end  as pc_level07_ext_refr                

    ,T44.LEVEL01_CODE PC_L1 ,T44.LEVEL01_NAME PC_L1_NAME 
    ,T44.LEVEL02_CODE PC_L2 ,T44.LEVEL02_NAME PC_L2_NAME      
    ,T44.LEVEL03_CODE PC_L3 ,T44.LEVEL03_NAME PC_L3_NAME        
    ,T44.LEVEL04_CODE PC_L4 ,T44.LEVEL04_NAME PC_L4_NAME 
--    ,T44.LEVEL05_CODE PC_L5 ,T44.LEVEL05_NAME PC_L5_NAME
--    ,T44.LEVEL06_CODE PC_L6 ,T44.LEVEL06_NAME PC_L6_NAME 
--    ,T44.LEVEL07_CODE PC_L7 ,T44.LEVEL07_NAME PC_L7_NAME      
        ,case   when t44.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and co.company_code in ('1000', '3000', '812820')               then t44.level05_code
                when t44.hierarchy_ext_refr = 'PC|PIS'         and co.company_code in ('812892', '812968', '812969')           then 'N/A'
                else t44.level05_code
                end  as pc_l5
                
        ,case   when t44.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and co.company_code in ('1000', '3000', '812820')               then t44.level05_name
                when t44.hierarchy_ext_refr = 'PC|PIS'         and co.company_code in ('812892', '812968', '812969')           then 'N/A'
                else t44.level05_name
                end  as pc_l5_name 
                  
        ,case   when t44.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and co.company_code in ('1000', '3000')                         then t44.level06_code
                when t44.hierarchy_ext_refr = 'PC|PIS'         and co.company_code in ('812820', '812892', '812968', '812969') then 'N/A'
                else t44.level06_code
                end  as pc_l6
                
        ,case   when t44.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and co.company_code in ('1000', '3000')                         then t44.level06_name
                when t44.hierarchy_ext_refr = 'PC|PIS'         and co.company_code in ('812820', '812892', '812968', '812969') then 'N/A'
                else t44.level06_name
                end  as pc_l6_name
                
        ,case   when t44.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and co.company_code in ('1000', '3000')                         then t44.level07_code
                when t44.hierarchy_ext_refr = 'PC|PIS'         and co.company_code in ('812820', '812892', '812968', '812969') then 'N/A'
                else t44.level07_code
                end  as pc_l7
                
        ,case   when t44.hierarchy_ext_refr = 'PC|STD_SAP_PIS' and co.company_code in ('1000', '3000')                         then t44.level07_name
                when t44.hierarchy_ext_refr = 'PC|PIS'         and co.company_code in ('812820', '812892', '812968', '812969') then 'N/A'
                else t44.level07_name
                end  as pc_l7_name
                                               
--    ,T44.LEVEL08_CODE PC_L8        
--    ,T44.LEVEL08_NAME PC_L8_NAME        
--    ,T44.LEVEL09_CODE PC_L9      
--    ,T44.LEVEL09_NAME PC_L9_NAME 
--    ,T44.LEVEL10_CODE PC_L10     
--    ,T44.LEVEL10_NAME PC_L10_NAME 
-- popravek 7.4. 
              
        ,PR.LEVEL01_CODE PR_L1        
        ,PR.LEVEL01_NAME PR_L1_NAME       
        ,PR.LEVEL02_CODE PR_L2          
        ,PR.LEVEL02_NAME PR_L2_NAME             
        ,PR.LEVEL03_CODE PR_L3          
        ,PR.LEVEL03_NAME PR_L3_NAME             
        ,PR.LEVEL04_CODE PR_L4          
        ,PR.LEVEL04_NAME PR_L4_NAME     
        ,PR.LEVEL05_CODE PR_L5          
        ,PR.LEVEL05_NAME PR_L5_NAME
        ,PR.LEVEL06_CODE PR_L6        
        ,PR.LEVEL06_NAME PR_L6_NAME      
        ,PR.LEVEL07_CODE PR_L7          
        ,PR.LEVEL07_NAME PR_L7_NAME             
        ,PR.LEVEL08_CODE PR_L8          
        ,PR.LEVEL08_NAME PR_L8_NAME             
        ,PR.LEVEL09_CODE PR_L9          
        ,PR.LEVEL09_NAME PR_L9_NAME     
        ,PR.LEVEL10_CODE PR_L10         
        ,PR.LEVEL10_NAME PR_L10_NAME
        ,0 AS SALES_LINE_QTY_AC
        ,0 AS SALES_LINE_QTY_KG_AC
        ,0 AS SALES_LINE_QTY_L_AC
        ,0 AS SALES_LINE_QTY_KWH_AC
        ,0 AS SALES_LINE_QTY_SM3_AC
        ,0 AS NET_SALES_LINE_AMT_AC  
        ,0 AS NET_MARGIN_LINE_AMT_AC
        ,0 AS NET_SALES_LINE_AMT_EUR_AC
        ,0 AS NET_MARGIN_LINE_AMT_EUR_AC    
            
        ,0 AS SALES_LINE_QTY_PY
        ,0 AS SALES_LINE_QTY_KG_PY
        ,0 AS SALES_LINE_QTY_L_PY
        ,0 AS SALES_LINE_QTY_KWH_PY
        ,0 AS SALES_LINE_QTY_SM3_PY
        ,0 AS NET_SALES_LINE_AMT_PY  
        ,0 AS NET_MARGIN_LINE_AMT_PY
        ,0 AS NET_SALES_LINE_AMT_EUR_PY
        ,0 AS NET_MARGIN_LINE_AMT_EUR_PY  
        /* to be devided on BU and BU_py  */      
        ,CAST(ROUND(SALES_LINE_QTY, 3) AS DECIMAL(30,3)) AS SALES_LINE_QTY_BU
        ,CAST(ROUND(SALES_LINE_QTY_KG, 3) AS DECIMAL(30,3)) AS SALES_LINE_QTY_KG_BU
        ,CAST(ROUND(SALES_LINE_QTY_LITER, 3) AS DECIMAL(30,3)) AS SALES_LINE_QTY_L_BU
        ,CAST(ROUND(SALES_LINE_QTY_KWH, 3) AS DECIMAL(30,3)) AS SALES_LINE_QTY_KWH_BU
        ,CAST(ROUND(SALES_LINE_QTY_SM3, 3) AS DECIMAL(30,3)) AS SALES_LINE_QTY_SM3_BU
        ,CAST(ROUND(NET_SALES_LINE_AMT, 6) AS DECIMAL(30,6)) AS NET_SALES_LINE_AMT_BU  
        ,CAST(ROUND(MARGIN_LINE_AMT, 6) AS DECIMAL(30,6)) AS MARGIN_LINE_AMT_BU
        ,CAST(ROUND(NET_SALES_LINE_AMT*(case when ER.EXCHANGE_RATE_FLOAT is null then 1 else ER.EXCHANGE_RATE_FLOAT end), 6) AS DECIMAL(30,6)) AS NET_SALES_LINE_AMT_EUR_BU
        ,CAST(ROUND(MARGIN_LINE_AMT*(case when ER.EXCHANGE_RATE_FLOAT is null then 1 else ER.EXCHANGE_RATE_FLOAT end), 6) AS DECIMAL(30,6)) AS NET_MARGIN_LINE_AMT_EUR_BU    
        ,3 AS PPN_SRC
FROM 
	APLSDB.F_SALES_PLAN_DAILY T

 --popravek 6.4.    
-- popravek 7.4. left join D_Date dat on dat.DATE_SID=t.ACCOUNTING_DATE_SID
left join D_Date dat on dat.DATE_SID=t.DATE_SID
left join D_Date datx on datx.month_id=dat.month_id and datx.day_of_month = 1
 --popravek 6.4.    
 
----------------COMPANY----------------------------------------------------
INNER JOIN 
	APLSDB.D_COMPANY CO 
		ON CO.COMPANY_SID=T.COMPANY_SID  --AND CO.VLD_TO_DT='9999-12-31 00:00:00'
-----------------PROFITNI CENTRI---------------------------------------------
INNER JOIN  
	APLSDB.V_PROFIT_CENTER_BI T44               
		ON  T.PROFIT_CENTER_SID  = T44.PROFIT_CENTER_SID     
--popravek 7.4.	AND T44.HIERARCHY_EXT_REFR = 'PC|STD_SAP_PIS'
		AND T44.HIERARCHY_EXT_REFR in ('PC|STD_SAP_PIS', 'PC|PIS') 
 --------------PRODUKTI----------------------------------------------------------
INNER JOIN       
	APLSDB.V_PRODUCT_BI PR                
		ON  T.PRODUCT_SID = PR.PRODUCT_SID 
		AND PR.HIERARCHY_EXT_REFR = 'PR|SAP' -- -- 'PR|PIS'                         
--------------------PLA?EVANJE----------------------------------------------------------------------
LEFT JOIN
	APLSDB.D_EXCHANGE_RATE ER 
		ON T.CURRENCY_SID = ER.CURRENCY_FROM_SID 
		AND ER.CURRENCY_TO_EXT_REFR ='EUR' 
		AND ER.EXCHANGE_RATE_TYPE_EXT_REFR = 'PLN D'
		AND CAST(TO_VARCHAR(ER.EFF_TO_DT, 'YYYYMMDD')  AS INTEGER ) = T.DATE_SID 
		AND CO.COUNTRY_SID=ER.COUNTRY_SID --AND CO.COUNTRY_EXT_REFR=ER.COUNTRY_EXT_REFR
--INNER JOIN D_PAYMENT_METHOD_HIERARCHY PM ON T.PAYMENT_METHOD_SID=PM.PAYMENT_METHOD_SID
----------------------------------------------------------------------------------
--popravek 7.4. WHERE FLOOR(T.DATE_SID / 10000) IN (YEAR(CURRENT_DATE), YEAR(CURRENT_DATE) - 1) 
WHERE dat.year IN (YEAR(CURRENT_DATE), YEAR(CURRENT_DATE) - 1)  
--popravek 7.4.	AND CO.COMPANY_CODE_PIS = '9110'
        AND CO.COMPANY_CODE in ('1000', '3000', '821071','812820', '812892', '812968', '812969')
--popravek 7.4.	AND T44.LEVEL05_CODE='0P111'
        AND ((T44.HIERARCHY_EXT_REFR = 'PC|STD_SAP_PIS' and T44.LEVEL05_CODE in ('0P111')) OR (T44.HIERARCHY_EXT_REFR = 'PC|PIS' and T44.LEVEL03_CODE in ('4803', '6801', '3203', '6901')))
        
	AND SCENARIO = 'P'
	AND VERSION =1
	AND STATUS ='C'
)

---- novo 7.4.
, attributes as


(
select  
        t44.profit_center_ext_refr,
        t44.profit_center_code,
        t44.profit_center_name,
        max(case when pca.attribute_name = 'BS GEOGRAFSKO'                  then pca.attribute_value_string else null end) as bs_geografsko,
        max(case when pca.attribute_name = 'LOKACIJA BS'                    then pca.attribute_value_string else null end) as lokacija_bs,        
        max(case when pca.attribute_name = 'BS po regijah'                  then pca.attribute_value_string 
                 when pca.attribute_name = 'BS po regijah Petrol Beograd'   then pca.attribute_value_string 
                 else null end)                                                                                            as bs_po_regijah,
        max(case when pca.attribute_name = 'INŠTRUKTORJI Slovenija'         then pca.attribute_value_string
                 when pca.attribute_name = 'INŠTRUKTORJI BiH'               then pca.attribute_value_string 
                 when pca.attribute_name = 'INŠTRUKTORJI Hrvaška'           then pca.attribute_value_string 
                 else null end)                                                                                            as instruktorji,             
        max(case when pca.attribute_name = 'PRODAJNA POVRŠINA'              then pca.attribute_value_numeric else -1  end) as prodajna_povrsina,
        max(case when pca.attribute_name in ('FRESH', 'FRESH - MINI', 'DOPEKA') then pca.attribute_name     else null end) as fresh,
        max(case when pca.attribute_name = 'AVTOPRALNICE NA BS'             then pca.attribute_value_string else null end) as avtopralnica
        
from    f_profit_center_bi t44
        left join d_profit_center_attribute pca on t44.profit_center_sid = pca.profit_center_sid
where   attribute_name in ('BS GEOGRAFSKO', 'LOKACIJA BS', 'BS po regijah', 'BS po regijah Petrol Beograd',
                           'INŠTRUKTORJI Slovenija', 'INŠTRUKTORJI BiH', 'INŠTRUKTORJI Hrvaška', 
                           'PRODAJNA POVRŠINA', 'FRESH', 'FRESH - MINI', 'DOPEKA', 'AVTOPRALNICE NA BS')
and     pca.vld_to_dt = to_date('9999-12-31', 'YYYY-MM-DD')

group by
        t44.profit_center_ext_refr,
        t44.profit_center_code,
        t44.profit_center_name
)


select   p.COMPANY_CODE_PIS
        ,p.COMPANY_CODE
        ,p.COMPANY_NAME
        ,p.ACCOUNTING_DATE_SID
        ,p.ACCOUNTING_DATE
        ,p.CUSTOMER_TYPE_CODE
        ,p.CUSTOMER_TYPE
        ,p.PAYMENT_METHOD
        ,p.IS_OWN_USAGE
        ,case when p.PC_L7 = 'N/A' and p.PC_L6 = 'N/A' and p.PC_L5 = 'N/A'    then p.PC_LEVEL04_EXT_REFR
              when p.PC_L7 = 'N/A' and p.PC_L6 = 'N/A'                        then p.PC_LEVEL05_EXT_REFR 
              when p.PC_L7 = 'N/A'                                            then p.PC_LEVEL06_EXT_REFR 
              else p.PC_LEVEL07_EXT_REFR
              end as profit_center_ext_refr

        ,case when p.PC_L7 = 'N/A' and p.PC_L6 = 'N/A' and p.PC_L5 = 'N/A'    then p.PC_L4
              when p.PC_L7 = 'N/A' and p.PC_L6 = 'N/A'                        then p.PC_L5 
              when p.PC_L7 = 'N/A'                                            then p.PC_L6 
              else p.PC_L7
              end as profit_center_code
              
        ,case when p.PC_L7 = 'N/A' and p.PC_L6 = 'N/A' and p.PC_L5 = 'N/A'    then p.PC_L4_NAME
              when p.PC_L7 = 'N/A' and p.PC_L6 = 'N/A'                        then p.PC_L5_NAME 
              when p.PC_L7 = 'N/A'                                            then p.PC_L6_NAME 
              else p.PC_L7_NAME
              end as profit_center_name
        ,ifnull(a.bs_geografsko, 'N/A')         as bs_geografsko    
        ,ifnull(a.lokacija_bs, 'N/A')           as lokacija_bs
        ,ifnull(a.bs_po_regijah, 'N/A')         as bs_po_regijah
        ,ifnull(a.instruktorji, 'N/A')          as instruktorji
        ,ifnull(a.prodajna_povrsina, -1)        as prodajna_povrsina
        ,ifnull(a.fresh, 'N/A')                 as fresh
        ,ifnull(a.avtopralnica, 'N/A')          as avtopralnica    
        ,p.PC_LEVEL01_EXT_REFR, p.PC_L1, p.PC_L1_NAME     
        ,p.PC_LEVEL02_EXT_REFR, p.PC_L2, p.PC_L2_NAME           
        ,p.PC_LEVEL03_EXT_REFR, p.PC_L3, p.PC_L3_NAME            
        ,p.PC_LEVEL04_EXT_REFR, p.PC_L4, p.PC_L4_NAME 
        ,p.PC_LEVEL05_EXT_REFR, p.PC_L5, p.PC_L5_NAME     
        ,p.PC_LEVEL06_EXT_REFR, p.PC_L6, p.PC_L6_NAME     
        ,p.PC_LEVEL07_EXT_REFR, p.PC_L7, p.PC_L7_NAME      
        ,p.PRODUCT_CODE, p.PRODUCT_NAME_SHORT     
        ,p.PR_L1, p.PR_L1_NAME
        ,p.PR_L2, p.PR_L2_NAME
        ,p.PR_L3, p.PR_L3_NAME
        ,p.PR_L4, p.PR_L4_NAME
        ,p.PR_L5, p.PR_L5_NAME
        ,p.PR_L6, p.PR_L6_NAME
        ,p.PR_L7, p.PR_L7_NAME
        ,p.PR_L8, p.PR_L8_NAME
        ,p.PR_L9, p.PR_L9_NAME
        ,p.PR_L10, p.PR_L10_NAME 
        ,p.SALES_LINE_QTY_AC                           
        ,p.SALES_LINE_QTY_KG_AC                        
        ,p.SALES_LINE_QTY_L_AC                         
        ,p.SALES_LINE_QTY_KWH_AC                       
        ,p.SALES_LINE_QTY_SM3_AC                       
        ,p.NET_SALES_LINE_AMT_AC                       
        ,p.NET_MARGIN_LINE_AMT_AC                      
        ,p.NET_SALES_LINE_AMT_EUR_AC
        ,p.NET_MARGIN_LINE_AMT_EUR_AC                                                      
        ,p.SALES_LINE_QTY_PY                          
        ,p.SALES_LINE_QTY_KG_PY                       
        ,p.SALES_LINE_QTY_L_PY                        
        ,p.SALES_LINE_QTY_KWH_PY                      
        ,p.SALES_LINE_QTY_SM3_PY                      
        ,p.NET_SALES_LINE_AMT_PY                      
        ,p.NET_MARGIN_LINE_AMT_PY                     
        ,p.NET_SALES_LINE_AMT_EUR_PY
        ,p.NET_MARGIN_LINE_AMT_EUR_PY
        ,p.SALES_LINE_QTY_BU         
        ,p.SALES_LINE_QTY_KG_BU      
        ,p.SALES_LINE_QTY_L_BU       
        ,p.SALES_LINE_QTY_KWH_BU     
        ,p.SALES_LINE_QTY_SM3_BU     
        ,p.NET_SALES_LINE_AMT_BU     
        ,p.MARGIN_LINE_AMT_BU        
        ,p.NET_SALES_LINE_AMT_EUR_BU 
        ,p.NET_MARGIN_LINE_AMT_EUR_BU
        ,p.PPN_SRC 

                
from    plan p
left join attributes a  on a.profit_center_ext_refr = (case when p.PC_L7 = 'N/A' and p.PC_L6 = 'N/A' and p.PC_L5 = 'N/A'        then p.PC_LEVEL04_EXT_REFR
                                                       when p.PC_L7 = 'N/A' and p.PC_L6 = 'N/A'                                 then p.PC_LEVEL05_EXT_REFR 
                                                       when p.PC_L7 = 'N/A'                                                     then p.PC_LEVEL06_EXT_REFR 
                                                       else p.PC_LEVEL07_EXT_REFR
                                                       end)	