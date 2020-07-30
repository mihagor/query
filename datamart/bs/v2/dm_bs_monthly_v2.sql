USE DATABASE DWH_prod;
USE SCHEMA APLsdb;

---- novo 7.4.
with monthly as ( 
---- novo 7.4.

SELECT  
        CO.COMPANY_CODE_PIS
        
 --popravek 7.4.        
        ,case when CO.COMPANY_CODE = '821071' then '3000' else CO.COMPANY_CODE end as COMPANY_CODE
        ,case when CO.COMPANY_CODE = '821071' then 'Petrol d.o.o., Zagreb' else CO.NAME end as COMPANY_NAME
 --popravek 7.4.
 
        ,CASE WHEN YEAR(CURRENT_DATE) = SUBSTR(datx.DATE_SID, 0, 4) THEN datx.DATE_SID  ELSE datx.DATE_SID + 10000 END  ACCOUNTING_DATE_sid        
        
 --popravek 6.4.    
--        ,datx.ext_refr ACCOUNTING_DATE 
--        ,dateadd(month, 12, to_date(datx.date)) ACCOUNTING_DATE
        ,CASE WHEN YEAR(CURRENT_DATE) = SUBSTR(datx.DATE_SID, 0, 4) THEN datx.ext_refr  ELSE dateadd(month, 12, to_date(datx.date)) END  ACCOUNTING_DATE          
 --popravek 6.4.		

-- popravek 7.4.
--        	,T44.PROFIT_CENTER_EXT_REFR 
--              ,T44.PROFIT_CENTER_NAME
-- popravek 7.4.
        
        ,(CASE WHEN CD.EXT_REFR IN ('CUSTOMER_TYPE|4','N/A') THEN 1 ELSE 2 END) AS CUSTOMER_TYPE_CODE
        ,(CASE WHEN CD.EXT_REFR IN ('CUSTOMER_TYPE|4','N/A') THEN 'B2C' ELSE 'B2B' END) AS CUSTOMER_TYPE
        ,T.IS_OWN_USAGE
        , CASE WHEN PM.PAYMENT_METHOD_SID = -1 THEN 'N/A'
                WHEN UPPER(PM.LEVEL02_CODE) = 'GOTOVINA'                          THEN 'Gotovina'  	        	                         	        
--popravek 7.4. WHEN UPPER(PM.LEVEL04_CODE) = 'BAN?NE KARTICE'                    THEN 'Ban?ne kartice'             
                WHEN UPPER(PM.LEVEL04_CODE) = 'BAN�NE KARTICE'                    THEN 'Ban�ne kartice'    	        
                
---- novo 3.4.--------------------------                
                when pm.LEVEL04_CODE in ('M - PETROL PLA�ILNE KARTICE', 'M - Petrol pla�ilne kartice')       then 'Petrol pla�ilne kartice'                            
--                when pm.LEVEL04_CODE = 'M - PETROL PLAČILNE KARTICE'       then 'Petrol pla�?ilne kartice'
---- novo 3.4.--------------------------                

                WHEN UPPER(PM.LEVEL04_CODE) = 'PETROLOVE POSLOVNE KARTICE'        THEN 'Petrolove poslovne kartice' 
                WHEN UPPER(PM.LEVEL04_CODE) = 'TUJE KAMIONSKE KARTICE'            THEN 'Tuje kamionske kartice'     
                ELSE 'Other' END AS PAYMENT_METHOD    
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

        ,SUM(CASE WHEN YEAR(CURRENT_DATE) = SUBSTR(ACCOUNTING_DATE_SID, 0, 4) THEN CAST(ROUND(SALES_LINE_QTY, 3) AS DECIMAL(30,3)) ELSE 0 END) SALES_LINE_QTY_AC
        ,SUM(CASE WHEN YEAR(CURRENT_DATE) = SUBSTR(ACCOUNTING_DATE_SID, 0, 4) THEN CAST(ROUND(SALES_LINE_QTY_KG, 3) AS DECIMAL(30,3)) ELSE 0 END) SALES_LINE_QTY_KG_AC
        ,SUM(CASE WHEN YEAR(CURRENT_DATE) = SUBSTR(ACCOUNTING_DATE_SID, 0, 4) THEN CAST(ROUND(SALES_LINE_QTY_L, 3) AS DECIMAL(30,3)) ELSE 0 END) SALES_LINE_QTY_L_AC
        ,SUM(CASE WHEN YEAR(CURRENT_DATE) = SUBSTR(ACCOUNTING_DATE_SID, 0, 4) THEN CAST(ROUND(SALES_LINE_QTY_KWH, 3) AS DECIMAL(30,3)) ELSE 0 END) SALES_LINE_QTY_KWH_AC
        ,SUM(CASE WHEN YEAR(CURRENT_DATE) = SUBSTR(ACCOUNTING_DATE_SID, 0, 4) THEN CAST(ROUND(SALES_LINE_QTY_SM3, 3) AS DECIMAL(30,3)) ELSE 0 END) SALES_LINE_QTY_SM3_AC
        ,SUM(CASE WHEN YEAR(CURRENT_DATE) = SUBSTR(ACCOUNTING_DATE_SID, 0, 4) THEN CAST(ROUND(NET_SALES_LINE_AMT, 6) AS DECIMAL(30,6)) ELSE 0 END) NET_SALES_LINE_AMT_AC
        ,SUM(CASE WHEN YEAR(CURRENT_DATE) = SUBSTR(ACCOUNTING_DATE_SID, 0, 4) THEN CAST(ROUND(NET_MARGIN_LINE_AMT, 6) AS DECIMAL(30,6)) ELSE 0 END) NET_MARGIN_LINE_AMT_AC
        ,SUM(CASE WHEN YEAR(CURRENT_DATE) = SUBSTR(ACCOUNTING_DATE_SID, 0, 4) THEN CAST(ROUND(NET_SALES_LINE_AMT*ER.EXCHANGE_RATE_FLOAT, 6) AS DECIMAL(30,6)) ELSE 0 END) NET_SALES_LINE_AMT_EUR_AC
        ,SUM(CASE WHEN YEAR(CURRENT_DATE) = SUBSTR(ACCOUNTING_DATE_SID, 0, 4) THEN CAST(ROUND(NET_MARGIN_LINE_AMT*ER.EXCHANGE_RATE_FLOAT, 6) AS DECIMAL(30,6)) ELSE 0 END) NET_MARGIN_LINE_AMT_EUR_AC	
        
        ,SUM(CASE WHEN YEAR(CURRENT_DATE) <> SUBSTR(ACCOUNTING_DATE_SID, 0, 4) THEN CAST(ROUND(SALES_LINE_QTY, 3) AS DECIMAL(30,3)) ELSE 0 END) SALES_LINE_QTY_PY
        ,SUM(CASE WHEN YEAR(CURRENT_DATE) <> SUBSTR(ACCOUNTING_DATE_SID, 0, 4) THEN CAST(ROUND(SALES_LINE_QTY_KG, 3) AS DECIMAL(30,3)) ELSE 0 END) SALES_LINE_QTY_KG_PY
        ,SUM(CASE WHEN YEAR(CURRENT_DATE) <> SUBSTR(ACCOUNTING_DATE_SID, 0, 4) THEN CAST(ROUND(SALES_LINE_QTY_L, 3) AS DECIMAL(30,3)) ELSE 0 END) SALES_LINE_QTY_L_PY
        ,SUM(CASE WHEN YEAR(CURRENT_DATE) <> SUBSTR(ACCOUNTING_DATE_SID, 0, 4) THEN CAST(ROUND(SALES_LINE_QTY_KWH, 3) AS DECIMAL(30,3)) ELSE 0 END) SALES_LINE_QTY_KWH_PY
        ,SUM(CASE WHEN YEAR(CURRENT_DATE) <> SUBSTR(ACCOUNTING_DATE_SID, 0, 4) THEN CAST(ROUND(SALES_LINE_QTY_SM3, 3) AS DECIMAL(30,3)) ELSE 0 END) SALES_LINE_QTY_SM3_PY
        ,SUM(CASE WHEN YEAR(CURRENT_DATE) <> SUBSTR(ACCOUNTING_DATE_SID, 0, 4) THEN CAST(ROUND(NET_SALES_LINE_AMT, 6) AS DECIMAL(30,6)) ELSE 0 END) NET_SALES_LINE_AMT_PY
        ,SUM(CASE WHEN YEAR(CURRENT_DATE) <> SUBSTR(ACCOUNTING_DATE_SID, 0, 4) THEN CAST(ROUND(NET_MARGIN_LINE_AMT, 6) AS DECIMAL(30,6)) ELSE 0 END) NET_MARGIN_LINE_AMT_PY
        ,SUM(CASE WHEN YEAR(CURRENT_DATE) <> SUBSTR(ACCOUNTING_DATE_SID, 0, 4) THEN CAST(ROUND(NET_SALES_LINE_AMT*ER.EXCHANGE_RATE_FLOAT, 6) AS DECIMAL(30,6)) ELSE 0 END) NET_SALES_LINE_AMT_EUR_PY
        ,SUM(CASE WHEN YEAR(CURRENT_DATE) <> SUBSTR(ACCOUNTING_DATE_SID, 0, 4) THEN CAST(ROUND(NET_MARGIN_LINE_AMT*ER.EXCHANGE_RATE_FLOAT, 6) AS DECIMAL(30,6)) ELSE 0 END) NET_MARGIN_LINE_AMT_EUR_PY       	
        ,0 AS SALES_LINE_QTY_BU
        ,0 AS SALES_LINE_QTY_KG_BU
        ,0 AS SALES_LINE_QTY_L_BU
        ,0 AS SALES_LINE_QTY_KWH_BU
        ,0 AS SALES_LINE_QTY_SM3_BU
        ,0 AS NET_SALES_LINE_AMT_BU  
        ,0 AS MARGIN_LINE_AMT_BU
        ,0 AS NET_SALES_LINE_AMT_EUR_BU
        ,0 AS NET_MARGIN_LINE_AMT_EUR_BU
        ,2 AS PPN_SRC 
        
FROM 
        APLSDB.F_SALES_ALL_DAILY T
        
 --popravek 6.4.    
left join D_Date dat on dat.DATE_SID=t.ACCOUNTING_DATE_SID
left join D_Date datx on datx.month_id=dat.month_id and datx.day_of_month = 1
 --popravek 6.4.   
        
----------------COMPANY----------------------------------------------------
INNER JOIN 
        APLSDB.D_COMPANY CO 
                ON CO.COMPANY_SID=T.COMPANY_SID  --AND CO.VLD_TO_DT='9999-12-31 00:00:00'
-----------------PROFITNI CENTRI---------------------------------------------
--INNER JOIN  V_PROFIT_CENTER_BI T44               ON  T.SALES_POINT_SID  = T44.PROFIT_CENTER_SID     AND T44.HIERARCHY_EXT_REFR = 'PC|STD_SAP_PIS' 
INNER JOIN  
        APLSDB.F_PROFIT_CENTER_BI T44               
                ON T.SALES_POINT_SID  = T44.PROFIT_CENTER_SID     
--popravek 7.4.	AND T44.HIERARCHY_EXT_REFR = 'PC|STD_SAP_PIS'
                AND T44.HIERARCHY_EXT_REFR in ('PC|STD_SAP_PIS', 'PC|PIS')  
 --------------PRODUKTI----------------------------------------------------------
INNER JOIN       
        APLSDB.V_PRODUCT_BI PR
                ON T.PRODUCT_SID = PR.PRODUCT_SID
                AND PR.HIERARCHY_EXT_REFR = 'PR|SAP' --AND PROD.PRODUCT_CODE LIKE '%GR%'-- -- 'PR|PIS'                         
----------------------STRANKA---------------------------------------------------
LEFT JOIN 
        APLSDB.D_CUSTOMER CU                 
                ON CU.CUSTOMER_SID = T.CUSTOMER_SID
LEFT JOIN 
        APLSDB.D_CUSTOMER_DATASET CD
                ON CD.CUSTOMER_DATASET_SID=CU.DATASET_CUSTOMER_TYPE_SID 
                AND CD.VLD_TO_DT='9999-12-31 00:00:00'
--------------------PLA?EVANJE----------------------------------------------------------------------
INNER JOIN 
        APLSDB.D_EXCHANGE_RATE ER 
                ON T.CURRENCY_SID = ER.CURRENCY_FROM_SID 
                AND ER.CURRENCY_TO_EXT_REFR ='EUR' 
                AND ER.EXCHANGE_RATE_TYPE_EXT_REFR = 'D' 
        AND CAST(TO_VARCHAR(ER.EFF_TO_DT, 'YYYYMMDD')  AS INTEGER ) = T.ACCOUNTING_DATE_SID 
        AND CO.COUNTRY_SID=ER.COUNTRY_SID --AND CO.COUNTRY_EXT_REFR=ER.COUNTRY_EXT_REFR
INNER JOIN 
        APLSDB.D_PAYMENT_METHOD_HIERARCHY PM 
                ON T.PAYMENT_METHOD_SID=PM.PAYMENT_METHOD_SID
----------------------------------------------------------------------------------

-- popravek 7.4.  WHERE FLOOR(T.ACCOUNTING_DATE_SID / 10000) IN (YEAR(CURRENT_DATE), YEAR(CURRENT_DATE) - 1)
WHERE dat.year IN (YEAR(CURRENT_DATE), YEAR(CURRENT_DATE) - 1)  
        AND MONTH(CURRENT_DATE) <> MONTH(DATE(DATx.DATE))   --= 3  -- SUBSTR(T.ACCOUNTING_DATE_SID, 5, 2)
--popravek 7.4.	AND CO.COMPANY_CODE_PIS = '9110'
        AND CO.COMPANY_CODE in ('1000', '3000', '821071','812820', '812892', '812968', '812969')
--popravek 7.4.	AND T44.LEVEL05_CODE='0P111'
        AND ((T44.HIERARCHY_EXT_REFR = 'PC|STD_SAP_PIS' and T44.LEVEL05_CODE in ('0P111')) OR (T44.HIERARCHY_EXT_REFR = 'PC|PIS' and T44.LEVEL03_CODE in ('4803', '6801', '3203', '6901')))
        AND PR.LEVEL01_CODE <> '06'
        
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--        TESTING
--        and (ACCOUNTING_DATE_SID between 20200101 and 20200101 or ACCOUNTING_DATE_SID between 20190101 and 20190101) 
--        and co.company_code in ('3000', '821071')
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
             
        
GROUP BY
        CO.COMPANY_CODE_PIS
        ,CO.COMPANY_CODE
        ,CO.NAME 
        ,CASE WHEN YEAR(CURRENT_DATE) = SUBSTR(datx.DATE_SID, 0, 4) THEN datx.DATE_SID  ELSE datx.DATE_SID + 10000 END          
        ,CASE WHEN YEAR(CURRENT_DATE) = SUBSTR(datx.DATE_SID, 0, 4) THEN datx.ext_refr  ELSE dateadd(month, 12, to_date(datx.date)) END 

--popravek 7.4.          
--        ,T44.PROFIT_CENTER_EXT_REFR 
--        ,T44.PROFIT_CENTER_NAME
--popravek 7.4.        
        
        ,(CASE WHEN CD.EXT_REFR IN ('CUSTOMER_TYPE|4','N/A') THEN 1 ELSE 2 END) 
        ,(CASE WHEN CD.EXT_REFR IN ('CUSTOMER_TYPE|4','N/A') THEN 'B2C' ELSE 'B2B' END) 
        ,T.IS_OWN_USAGE
--popravek 7.4.         
        ,PAYMENT_METHOD
--popravek 7.4.         
        ,PR.PRODUCT_CODE 
        ,PR.PRODUCT_NAME_SHORT 

        ,T44.LEVEL01_EXT_REFR         
        ,T44.LEVEL02_EXT_REFR       
        ,T44.LEVEL03_EXT_REFR         
        ,T44.LEVEL04_EXT_REFR 
-- popravek 7.4.           
--        ,T44.LEVEL05_EXT_REFR         
--        ,T44.LEVEL06_EXT_REFR       
--        ,T44.LEVEL07_EXT_REFR          
--        ,T44.LEVEL08_EXT_REFR 
--        ,T44.LEVEL09_EXT_REFR         
--        ,T44.LEVEL10_EXT_REFR 
        ,PC_L1          -- ,T44.LEVEL01_CODE       
        ,PC_L1_NAME     -- ,T44.LEVEL01_NAME  
        ,PC_L2          -- ,T44.LEVEL02_CODE       
        ,PC_L2_NAME     -- , T44.LEVEL02_NAME       
        ,PC_L3          -- ,T44.LEVEL03_CODE         
        ,PC_L3_NAME     -- ,T44.LEVEL03_NAME         
        ,PC_L4          -- ,T44.LEVEL04_CODE       
        ,PC_L4_NAME     -- ,T44.LEVEL04_NAME  
        ,PC_L5          -- ,T44.LEVEL05_CODE      
        ,PC_L5_NAME     -- ,T44.LEVEL05_NAME 
        ,PC_L6          -- ,T44.LEVEL06_CODE       
        ,PC_L6_NAME     -- ,T44.LEVEL06_NAME  
        ,PC_L7          -- ,T44.LEVEL07_CODE       
        ,PC_L7_NAME     -- , T44.LEVEL07_NAME  
        ,PC_LEVEL05_EXT_REFR
        ,PC_LEVEL06_EXT_REFR
        ,PC_LEVEL07_EXT_REFR     
--        ,T44.LEVEL08_CODE         
--        ,T44.LEVEL08_NAME         
--        ,T44.LEVEL09_CODE       
--        ,T44.LEVEL09_NAME  
--        ,T44.LEVEL10_CODE      
--        ,T44.LEVEL10_NAME   
-- popravek 7.4.
                
        ,PR_L1
        ,PR_L1_NAME
        ,PR_L2
        ,PR_L2_NAME
        ,PR_L3
        ,PR_L3_NAME
        ,PR_L4
        ,PR_L4_NAME
        ,PR_L5
        ,PR_L5_NAME
        ,PR_L6
        ,PR_L6_NAME
        ,PR_L7
        ,PR_L7_NAME
        ,PR_L8
        ,PR_L8_NAME
        ,PR_L9
        ,PR_L9_NAME
        ,PR_L10
        ,PR_L10_NAME              

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
        max(case when pca.attribute_name = 'IN�TRUKTORJI Slovenija'         then pca.attribute_value_string
                 when pca.attribute_name = 'IN�TRUKTORJI BiH'               then pca.attribute_value_string 
                 when pca.attribute_name = 'IN�TRUKTORJI Hrva�ka'           then pca.attribute_value_string 
                 else null end)                                                                                            as instruktorji,             
        max(case when pca.attribute_name = 'PRODAJNA POVR�INA'              then pca.attribute_value_numeric else -1  end) as prodajna_povrsina,
        max(case when pca.attribute_name in ('FRESH', 'FRESH - MINI', 'DOPEKA') then pca.attribute_name     else null end) as fresh,
        max(case when pca.attribute_name = 'AVTOPRALNICE NA BS'             then pca.attribute_value_string else null end) as avtopralnica
        
from    f_profit_center_bi t44
        left join d_profit_center_attribute pca on t44.profit_center_sid = pca.profit_center_sid
where   attribute_name in ('BS GEOGRAFSKO', 'LOKACIJA BS', 'BS po regijah', 'BS po regijah Petrol Beograd',
                           'IN�TRUKTORJI Slovenija', 'IN�TRUKTORJI BiH', 'IN�TRUKTORJI Hrva�ka', 
                           'PRODAJNA POVR�INA', 'FRESH', 'FRESH - MINI', 'DOPEKA', 'AVTOPRALNICE NA BS')
and     pca.vld_to_dt = to_date('9999-12-31', 'YYYY-MM-DD')

group by
        t44.profit_center_ext_refr,
        t44.profit_center_code,
        t44.profit_center_name
)


select   m.COMPANY_CODE_PIS
        ,m.COMPANY_CODE
        ,m.COMPANY_NAME
        ,m.ACCOUNTING_DATE_SID
        ,m.ACCOUNTING_DATE
        ,m.CUSTOMER_TYPE_CODE
        ,m.CUSTOMER_TYPE
        ,m.PAYMENT_METHOD
        ,m.IS_OWN_USAGE
        ,case when m.PC_L7 = 'N/A' and m.PC_L6 = 'N/A' and m.PC_L5 = 'N/A'    then m.PC_LEVEL04_EXT_REFR
              when m.PC_L7 = 'N/A' and m.PC_L6 = 'N/A'                        then m.PC_LEVEL05_EXT_REFR 
              when m.PC_L7 = 'N/A'                                            then m.PC_LEVEL06_EXT_REFR 
              else m.PC_LEVEL07_EXT_REFR
              end as profit_center_ext_refr

        ,case when m.PC_L7 = 'N/A' and m.PC_L6 = 'N/A' and m.PC_L5 = 'N/A'    then m.PC_L4
              when m.PC_L7 = 'N/A' and m.PC_L6 = 'N/A'                        then m.PC_L5 
              when m.PC_L7 = 'N/A'                                            then m.PC_L6 
              else m.PC_L7
              end as profit_center_code
              
        ,case when m.PC_L7 = 'N/A' and m.PC_L6 = 'N/A' and m.PC_L5 = 'N/A'    then m.PC_L4_NAME
              when m.PC_L7 = 'N/A' and m.PC_L6 = 'N/A'                        then m.PC_L5_NAME 
              when m.PC_L7 = 'N/A'                                            then m.PC_L6_NAME 
              else m.PC_L7_NAME
              end as profit_center_name
        ,ifnull(a.bs_geografsko, 'N/A')         as bs_geografsko    
        ,ifnull(a.lokacija_bs, 'N/A')           as lokacija_bs
        ,ifnull(a.bs_po_regijah, 'N/A')         as bs_po_regijah
        ,ifnull(a.instruktorji, 'N/A')          as instruktorji
        ,ifnull(a.prodajna_povrsina, -1)        as prodajna_povrsina
        ,ifnull(a.fresh, 'N/A')                 as fresh
        ,ifnull(a.avtopralnica, 'N/A')          as avtopralnica    
        ,m.PC_LEVEL01_EXT_REFR, m.PC_L1, m.PC_L1_NAME     
        ,m.PC_LEVEL02_EXT_REFR, m.PC_L2, m.PC_L2_NAME           
        ,m.PC_LEVEL03_EXT_REFR, m.PC_L3, m.PC_L3_NAME            
        ,m.PC_LEVEL04_EXT_REFR, m.PC_L4, m.PC_L4_NAME 
        ,m.PC_LEVEL05_EXT_REFR, m.PC_L5, m.PC_L5_NAME     
        ,m.PC_LEVEL06_EXT_REFR, m.PC_L6, m.PC_L6_NAME     
        ,m.PC_LEVEL07_EXT_REFR, m.PC_L7, m.PC_L7_NAME      
        ,m.PRODUCT_CODE, m.PRODUCT_NAME_SHORT     
        ,m.PR_L1, m.PR_L1_NAME
        ,m.PR_L2, m.PR_L2_NAME
        ,m.PR_L3, m.PR_L3_NAME
        ,m.PR_L4, m.PR_L4_NAME
        ,m.PR_L5, m.PR_L5_NAME
        ,m.PR_L6, m.PR_L6_NAME
        ,m.PR_L7, m.PR_L7_NAME
        ,m.PR_L8, m.PR_L8_NAME
        ,m.PR_L9, m.PR_L9_NAME
        ,m.PR_L10, m.PR_L10_NAME 
        ,m.SALES_LINE_QTY_AC                           
        ,m.SALES_LINE_QTY_KG_AC                        
        ,m.SALES_LINE_QTY_L_AC                         
        ,m.SALES_LINE_QTY_KWH_AC                       
        ,m.SALES_LINE_QTY_SM3_AC                       
        ,m.NET_SALES_LINE_AMT_AC                       
        ,m.NET_MARGIN_LINE_AMT_AC                      
        ,m.NET_SALES_LINE_AMT_EUR_AC
        ,m.NET_MARGIN_LINE_AMT_EUR_AC                                                      
        ,m.SALES_LINE_QTY_PY                          
        ,m.SALES_LINE_QTY_KG_PY                       
        ,m.SALES_LINE_QTY_L_PY                        
        ,m.SALES_LINE_QTY_KWH_PY                      
        ,m.SALES_LINE_QTY_SM3_PY                      
        ,m.NET_SALES_LINE_AMT_PY                      
        ,m.NET_MARGIN_LINE_AMT_PY                     
        ,m.NET_SALES_LINE_AMT_EUR_PY
        ,m.NET_MARGIN_LINE_AMT_EUR_PY
        ,m.SALES_LINE_QTY_BU         
        ,m.SALES_LINE_QTY_KG_BU      
        ,m.SALES_LINE_QTY_L_BU       
        ,m.SALES_LINE_QTY_KWH_BU     
        ,m.SALES_LINE_QTY_SM3_BU     
        ,m.NET_SALES_LINE_AMT_BU     
        ,m.MARGIN_LINE_AMT_BU        
        ,m.NET_SALES_LINE_AMT_EUR_BU 
        ,m.NET_MARGIN_LINE_AMT_EUR_BU
        ,m.PPN_SRC                   
        
        
                
from    monthly m
left join attributes a  on a.profit_center_ext_refr = (case when m.PC_L7 = 'N/A' and m.PC_L6 = 'N/A' and m.PC_L5 = 'N/A'        then m.PC_LEVEL04_EXT_REFR
                                                       when m.PC_L7 = 'N/A' and m.PC_L6 = 'N/A'                                 then m.PC_LEVEL05_EXT_REFR 
                                                       when m.PC_L7 = 'N/A'                                                     then m.PC_LEVEL06_EXT_REFR 
                                                       else m.PC_LEVEL07_EXT_REFR
                                                       end)
                                                       
                                                       
                                                       

                                           