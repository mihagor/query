use database dwh_prod;

WITH MONTHLY AS(
                SELECT  
                               CO.COMPANY_CODE_PIS
                               ,CASE WHEN CO.COMPANY_CODE = '821071' THEN '3000' ELSE CO.COMPANY_CODE END AS COMPANY_CODE
                               ,CASE WHEN CO.COMPANY_CODE = '821071' THEN 'Petrol d.o.o., Zagreb' ELSE CO.NAME END AS COMPANY_NAME
                               ,CASE WHEN YEAR(CURRENT_DATE) = SUBSTR(datx.DATE_SID, 0, 4) THEN datx.DATE_SID  ELSE datx.DATE_SID + 10000 END  ACCOUNTING_DATE_SID
                               ,CASE WHEN YEAR(CURRENT_DATE) = SUBSTR(datx.DATE_SID, 0, 4) THEN datx.ext_refr  ELSE dateadd(month, 12, to_date(datx.date)) END  ACCOUNTING_DATE  
                               ,(CASE WHEN CD.EXT_REFR IN ('CUSTOMER_TYPE|4','N/A') THEN 1 ELSE 2 END) AS CUSTOMER_TYPE_CODE
                               ,(CASE WHEN CD.EXT_REFR IN ('CUSTOMER_TYPE|4','N/A') THEN 'B2C' ELSE 'B2B' END) AS CUSTOMER_TYPE
                               ,T.IS_OWN_USAGE
                               , CASE WHEN PM.PAYMENT_METHOD_SID = -1 THEN 'N/A'
                                      WHEN UPPER(PM.LEVEL02_CODE) = 'GOTOVINA' THEN 'Gotovina'                   
                                       WHEN UPPER(PM.LEVEL04_CODE) = 'BAN�NE KARTICE' THEN 'Ban�ne kartice'             
                                       WHEN UPPER(PM.LEVEL04_CODE) = 'M - PETROL PLA�ILNE KARTICE' THEN 'Petrol pla�ilne kartice'
                                       WHEN UPPER(PM.LEVEL04_CODE) = 'PETROLOVE POSLOVNE KARTICE' THEN 'Petrolove poslovne kartice' 
                                       WHEN UPPER(PM.LEVEL04_CODE) = 'TUJE KAMIONSKE KARTICE' THEN 'Tuje kamionske kartice'     
                                       ELSE 'Other' END AS PAYMENT_METHOD    
                    ,PR.PRODUCT_CODE 
                    ,PR.PRODUCT_NAME_SHORT
                    ,T44.LEVEL01_EXT_REFR PC_LEVEL01_EXT_REFR        
                    ,T44.LEVEL02_EXT_REFR PC_LEVEL02_EXT_REFR     
                    ,T44.LEVEL03_EXT_REFR PC_LEVEL03_EXT_REFR        
                    , T44.LEVEL04_EXT_REFR PC_LEVEL04_EXT_REFR
                               ,CASE WHEN T44.HIERARCHY_EXT_REFR = 'PC|STD_SAP_PIS' AND CO.COMPANY_CODE IN ('1000', '3000', '812820') THEN T44.LEVEL05_EXT_REFR
                          WHEN T44.HIERARCHY_EXT_REFR = 'PC|PIS' AND CO.COMPANY_CODE IN ('812892', '812968', '812969')  THEN 'N/A'
                          ELSE T44.LEVEL05_EXT_REFR END
                                               AS PC_LEVEL05_EXT_REFR                
                    ,CASE WHEN T44.HIERARCHY_EXT_REFR = 'PC|STD_SAP_PIS' AND CO.COMPANY_CODE IN ('1000', '3000') THEN T44.LEVEL06_EXT_REFR
                          WHEN T44.HIERARCHY_EXT_REFR = 'PC|PIS'         AND CO.COMPANY_CODE IN ('812820', '812892', '812968', '812969') THEN 'N/A'
                          ELSE T44.LEVEL06_EXT_REFR END               
                               AS PC_LEVEL06_EXT_REFR               
                    ,CASE WHEN T44.HIERARCHY_EXT_REFR = 'PC|STD_SAP_PIS' AND CO.COMPANY_CODE IN ('1000', '3000') THEN T44.LEVEL07_EXT_REFR
                          WHEN T44.HIERARCHY_EXT_REFR = 'PC|PIS' AND CO.COMPANY_CODE IN ('812820', '812892', '812968', '812969') THEN 'N/A'
                          ELSE T44.LEVEL07_EXT_REFR END
                        AS PC_LEVEL07_EXT_REFR 
                    ,T44.LEVEL01_CODE PC_L1       
                    ,T44.LEVEL01_NAME PC_L1_NAME 
                    ,T44.LEVEL02_CODE PC_L2      
                    , T44.LEVEL02_NAME PC_L2_NAME      
                    ,T44.LEVEL03_CODE PC_L3        
                    ,T44.LEVEL03_NAME PC_L3_NAME        
                    ,T44.LEVEL04_CODE PC_L4      
                    ,T44.LEVEL04_NAME PC_L4_NAME    
                               ,CASE WHEN T44.HIERARCHY_EXT_REFR = 'PC|STD_SAP_PIS' AND CO.COMPANY_CODE IN ('1000', '3000', '812820') THEN T44.LEVEL05_CODE
                          WHEN T44.HIERARCHY_EXT_REFR = 'PC|PIS'         AND CO.COMPANY_CODE IN ('812892', '812968', '812969') THEN 'N/A'
                          ELSE T44.LEVEL05_CODE END
                                   AS PC_L5               
                    ,CASE WHEN T44.HIERARCHY_EXT_REFR = 'PC|STD_SAP_PIS' AND CO.COMPANY_CODE IN ('1000', '3000', '812820') THEN T44.LEVEL05_NAME
                          WHEN T44.HIERARCHY_EXT_REFR = 'PC|PIS'         AND CO.COMPANY_CODE IN ('812892', '812968', '812969') THEN 'N/A'
                          ELSE T44.LEVEL05_NAME END
                        AS PC_L5_NAME                   
                    ,CASE WHEN T44.HIERARCHY_EXT_REFR = 'PC|STD_SAP_PIS' AND CO.COMPANY_CODE IN ('1000', '3000') THEN T44.LEVEL06_CODE
                          WHEN T44.HIERARCHY_EXT_REFR = 'PC|PIS' AND CO.COMPANY_CODE IN ('812820', '812892', '812968', '812969') THEN 'N/A'
                          ELSE T44.LEVEL06_CODE END
                        AS PC_L6                
                    ,CASE WHEN T44.HIERARCHY_EXT_REFR = 'PC|STD_SAP_PIS' AND CO.COMPANY_CODE IN ('1000', '3000') THEN T44.LEVEL06_NAME
                          WHEN T44.HIERARCHY_EXT_REFR = 'PC|PIS'         AND CO.COMPANY_CODE IN ('812820', '812892', '812968', '812969') THEN 'N/A'
                          ELSE T44.LEVEL06_NAME END
                        AS PC_L6_NAME               
                    ,CASE WHEN T44.HIERARCHY_EXT_REFR = 'PC|STD_SAP_PIS' AND CO.COMPANY_CODE IN ('1000', '3000') THEN T44.LEVEL07_CODE
                          WHEN T44.HIERARCHY_EXT_REFR = 'PC|PIS'         AND CO.COMPANY_CODE IN ('812820', '812892', '812968', '812969') THEN 'N/A'
                          ELSE T44.LEVEL07_CODE END
                        AS PC_L7      
                    ,CASE WHEN T44.HIERARCHY_EXT_REFR = 'PC|STD_SAP_PIS' AND CO.COMPANY_CODE IN ('1000', '3000') THEN T44.LEVEL07_NAME
                          WHEN T44.HIERARCHY_EXT_REFR = 'PC|PIS' AND CO.COMPANY_CODE IN ('812820', '812892', '812968', '812969') THEN 'N/A'
                          ELSE T44.LEVEL07_NAME END
                        AS PC_L7_NAME
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
                LEFT JOIN 
                               APLSDB.D_DATE DAT 
                                               ON DAT.DATE_SID=T.ACCOUNTING_DATE_SID
                LEFT JOIN APLSDB.D_DATE DATX 
                               ON DATX.MONTH_ID=DAT.MONTH_ID 
                               AND DATX.DAY_OF_MONTH = 1
                ----------------COMPANY----------------------------------------------------
                INNER JOIN 
                               APLSDB.D_COMPANY CO 
                                               ON CO.COMPANY_SID=T.COMPANY_SID  
                -----------------PROFITNI CENTRI---------------------------------------------
                --INNER JOIN  V_PROFIT_CENTER_BI T44              
                INNER JOIN  
                               APLSDB.F_PROFIT_CENTER_BI T44               
                                               ON T.SALES_POINT_SID  = T44.PROFIT_CENTER_SID     
                                               AND T44.HIERARCHY_EXT_REFR IN ('PC|STD_SAP_PIS', 'PC|PIS') 
                 --------------PRODUKTI----------------------------------------------------------
                INNER JOIN       
                               APLSDB.V_PRODUCT_BI PR
                                               ON T.PRODUCT_SID = PR.PRODUCT_SID
                                               AND PR.HIERARCHY_EXT_REFR = 'PR|SAP'                       
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
                
                WHERE DAT.YEAR IN (YEAR(CURRENT_DATE), YEAR(CURRENT_DATE) - 1)  
                               AND MONTH(CURRENT_DATE) <> MONTH(DATE(DATX.DATE))
                               AND CO.COMPANY_CODE in ('1000', '3000', '821071','812820', '812892', '812968', '812969')
                               AND ((T44.HIERARCHY_EXT_REFR = 'PC|STD_SAP_PIS' and T44.LEVEL05_CODE in ('0P111')) OR (T44.HIERARCHY_EXT_REFR = 'PC|PIS' and T44.LEVEL03_CODE in ('4803', '6801', '3203', '6901')))
                               AND PR.LEVEL01_CODE <> '06'
                               
                GROUP BY
                        CO.COMPANY_CODE_PIS
                        ,CO.COMPANY_CODE
                        ,CO.NAME 
                                               ,CASE WHEN YEAR(CURRENT_DATE) = SUBSTR(datx.DATE_SID, 0, 4) THEN datx.DATE_SID  ELSE datx.DATE_SID + 10000 END          
               ,CASE WHEN YEAR(CURRENT_DATE) = SUBSTR(datx.DATE_SID, 0, 4) THEN datx.ext_refr  ELSE dateadd(month, 12, to_date(datx.date)) END             
                       -- ,T44.PROFIT_CENTER_EXT_REFR 
                       -- ,T44.PROFIT_CENTER_NAME
                        ,(CASE WHEN CD.EXT_REFR IN ('CUSTOMER_TYPE|4','N/A') THEN 1 ELSE 2 END) 
                        ,(CASE WHEN CD.EXT_REFR IN ('CUSTOMER_TYPE|4','N/A') THEN 'B2C' ELSE 'B2B' END) 
                        ,T.IS_OWN_USAGE
                        ,PAYMENT_METHOD
                        ,PR.PRODUCT_CODE 
                        ,PR.PRODUCT_NAME_SHORT       
                        ,T44.LEVEL01_EXT_REFR         
                        ,T44.LEVEL02_EXT_REFR       
                        ,T44.LEVEL03_EXT_REFR         
                        , T44.LEVEL04_EXT_REFR 
                        ,PC_L1     
                        ,PC_L1_NAME
                        ,PC_L2     
                        ,PC_L2_NAME       
                        ,PC_L3         
                        ,PC_L3_NAME         
                        ,PC_L4       
                        ,PC_L4_NAME  
                        ,PC_L5      
                        ,PC_L5_NAME 
                        ,PC_L6       
                        ,PC_L6_NAME  
                        ,PC_L7      
                        ,PC_L7_NAME  
                        ,PC_LEVEL05_EXT_REFR
                        ,PC_LEVEL06_EXT_REFR
                        ,PC_LEVEL07_EXT_REFR   
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
,ATTRIBUTES AS
(
                SELECT  
        T44.PROFIT_CENTER_EXT_REFR,
        T44.PROFIT_CENTER_CODE,
        T44.PROFIT_CENTER_NAME,
        MAX(CASE WHEN UPPER(PCA.ATTRIBUTE_NAME) = 'BS GEOGRAFSKO'                                                        THEN PCA.ATTRIBUTE_VALUE_STRING ELSE NULL END) AS BS_GEOGRAFSKO,
        MAX(CASE WHEN UPPER(PCA.ATTRIBUTE_NAME) = 'LOKACIJA BS'                    THEN PCA.ATTRIBUTE_VALUE_STRING ELSE NULL END) AS LOKACIJA_BS,        
        MAX(CASE WHEN UPPER(PCA.ATTRIBUTE_NAME) = 'BS PO REGIJAH'                  THEN PCA.ATTRIBUTE_VALUE_STRING 
                 WHEN UPPER(PCA.ATTRIBUTE_NAME) = 'BS PO REGIJAH PETROL BEOGRAD'   THEN PCA.ATTRIBUTE_VALUE_STRING 
                 ELSE NULL END) 
            AS BS_PO_REGIJAH,
        MAX(CASE WHEN UPPER(PCA.ATTRIBUTE_NAME) = 'IN�TRUKTORJI SLOVENIJA'         THEN PCA.ATTRIBUTE_VALUE_STRING
                 WHEN UPPER(PCA.ATTRIBUTE_NAME) = 'IN�TRUKTORJI BIH'               THEN PCA.ATTRIBUTE_VALUE_STRING 
                 WHEN UPPER(PCA.ATTRIBUTE_NAME) = 'IN�TRUKTORJI HRVA�KA'           THEN PCA.ATTRIBUTE_VALUE_STRING 
                 ELSE NULL END)                                                                                           
            AS INSTRUKTORJI,             
        MAX(CASE WHEN UPPER(PCA.ATTRIBUTE_NAME) = 'PRODAJNA POVR�INA'              THEN PCA.ATTRIBUTE_VALUE_NUMERIC ELSE -1  END) AS PRODAJNA_POVRSINA,
        MAX(CASE WHEN UPPER(PCA.ATTRIBUTE_NAME) IN ('FRESH', 'FRESH - MINI', 'DOPEKA') THEN PCA.ATTRIBUTE_NAME     ELSE NULL END) AS FRESH,
        MAX(CASE WHEN UPPER(PCA.ATTRIBUTE_NAME) = 'AVTOPRALNICE NA BS'             THEN PCA.ATTRIBUTE_VALUE_STRING ELSE NULL END) AS AVTOPRALNICA
        
FROM    
                APLSDB.F_PROFIT_CENTER_BI T44
LEFT JOIN 
APLSDB.D_PROFIT_CENTER_ATTRIBUTE PCA 
                ON T44.PROFIT_CENTER_SID = PCA.PROFIT_CENTER_SID
WHERE   UPPER(ATTRIBUTE_NAME) IN ('BS GEOGRAFSKO', 'LOKACIJA BS', 'BS PO REGIJAH', 'BS PO REGIJAH PETROL BEOGRAD',
                           'IN�TRUKTORJI SLOVENIJA', 'IN�TRUKTORJI BIH', 'IN�TRUKTORJI HRVA�KA', 
                           'PRODAJNA POVR�INA', 'FRESH', 'FRESH - MINI', 'DOPEKA', 'AVTOPRALNICE NA BS')
AND PCA.VLD_TO_DT = TO_DATE('9999-12-31', 'YYYY-MM-DD')
GROUP BY
        T44.PROFIT_CENTER_EXT_REFR,
        T44.PROFIT_CENTER_CODE,
        T44.PROFIT_CENTER_NAME
)


SELECT  
                M.COMPANY_CODE_PIS
    ,M.COMPANY_CODE
    ,M.COMPANY_NAME
    ,M.ACCOUNTING_DATE_SID
    ,M.ACCOUNTING_DATE
    ,M.CUSTOMER_TYPE_CODE
    ,M.CUSTOMER_TYPE
    ,M.PAYMENT_METHOD
    ,M.IS_OWN_USAGE
    ,CASE WHEN M.PC_L7 = 'N/A' AND M.PC_L6 = 'N/A' AND M.PC_L5 = 'N/A'    THEN M.PC_LEVEL04_EXT_REFR
          WHEN M.PC_L7 = 'N/A' AND M.PC_L6 = 'N/A'                        THEN M.PC_LEVEL05_EXT_REFR 
          WHEN M.PC_L7 = 'N/A'                                            THEN M.PC_LEVEL06_EXT_REFR 
          ELSE M.PC_LEVEL07_EXT_REFR
          END AS PROFIT_CENTER_EXT_REFR
    ,CASE WHEN M.PC_L7 = 'N/A' AND M.PC_L6 = 'N/A' AND M.PC_L5 = 'N/A'    THEN M.PC_L4
          WHEN M.PC_L7 = 'N/A' AND M.PC_L6 = 'N/A'                        THEN M.PC_L5 
          WHEN M.PC_L7 = 'N/A'                                            THEN M.PC_L6 
          ELSE M.PC_L7
          END AS PROFIT_CENTER_CODE
    ,CASE WHEN M.PC_L7 = 'N/A' AND M.PC_L6 = 'N/A' AND M.PC_L5 = 'N/A'    THEN M.PC_L4_NAME
          WHEN M.PC_L7 = 'N/A' AND M.PC_L6 = 'N/A'                        THEN M.PC_L5_NAME 
          WHEN M.PC_L7 = 'N/A'                                            THEN M.PC_L6_NAME 
          ELSE M.PC_L7_NAME
          END AS PROFIT_CENTER_NAME
    ,IFNULL(A.BS_GEOGRAFSKO, 'N/A')         AS BS_GEOGRAFSKO    
    ,IFNULL(A.LOKACIJA_BS, 'N/A')           AS LOKACIJA_BS
    ,IFNULL(A.BS_PO_REGIJAH, 'N/A')         AS BS_PO_REGIJAH
    ,IFNULL(A.INSTRUKTORJI, 'N/A')          AS INSTRUKTORJI
    ,IFNULL(A.PRODAJNA_POVRSINA, -1)        AS PRODAJNA_POVRSINA
    ,IFNULL(A.FRESH, 'N/A')                 AS FRESH
    ,IFNULL(A.AVTOPRALNICA, 'N/A')          AS AVTOPRALNICA    
    ,M.PC_LEVEL01_EXT_REFR, M.PC_L1, M.PC_L1_NAME     
    ,M.PC_LEVEL02_EXT_REFR, M.PC_L2, M.PC_L2_NAME           
    ,M.PC_LEVEL03_EXT_REFR, M.PC_L3, M.PC_L3_NAME            
    ,M.PC_LEVEL04_EXT_REFR, M.PC_L4, M.PC_L4_NAME 
    ,M.PC_LEVEL05_EXT_REFR, M.PC_L5, M.PC_L5_NAME     
    ,M.PC_LEVEL06_EXT_REFR, M.PC_L6, M.PC_L6_NAME     
    ,M.PC_LEVEL07_EXT_REFR, M.PC_L7, M.PC_L7_NAME      
    ,M.PRODUCT_CODE, M.PRODUCT_NAME_SHORT  
    ,0 AS IS_AGGREGATED
    ,M.PR_L1, M.PR_L1_NAME
    ,M.PR_L2, M.PR_L2_NAME
    ,M.PR_L3, M.PR_L3_NAME
    ,M.PR_L4, M.PR_L4_NAME
    ,M.PR_L5, M.PR_L5_NAME
    ,M.PR_L6, M.PR_L6_NAME
    ,M.PR_L7, M.PR_L7_NAME
    ,M.PR_L8, M.PR_L8_NAME
    ,M.PR_L9, M.PR_L9_NAME
    ,M.PR_L10, M.PR_L10_NAME 
    ,M.SALES_LINE_QTY_AC                           
    ,M.SALES_LINE_QTY_KG_AC                        
    ,M.SALES_LINE_QTY_L_AC                         
    ,M.SALES_LINE_QTY_KWH_AC                       
    ,M.SALES_LINE_QTY_SM3_AC                       
    ,M.NET_SALES_LINE_AMT_AC                       
    ,M.NET_MARGIN_LINE_AMT_AC                      
    ,M.NET_SALES_LINE_AMT_EUR_AC
    ,M.NET_MARGIN_LINE_AMT_EUR_AC                                                      
    ,M.SALES_LINE_QTY_PY                          
    ,M.SALES_LINE_QTY_KG_PY                       
    ,M.SALES_LINE_QTY_L_PY                        
    ,M.SALES_LINE_QTY_KWH_PY                      
    ,M.SALES_LINE_QTY_SM3_PY                      
    ,M.NET_SALES_LINE_AMT_PY                      
    ,M.NET_MARGIN_LINE_AMT_PY                     
    ,M.NET_SALES_LINE_AMT_EUR_PY
    ,M.NET_MARGIN_LINE_AMT_EUR_PY
    ,M.SALES_LINE_QTY_BU         
    ,M.SALES_LINE_QTY_KG_BU      
    ,M.SALES_LINE_QTY_L_BU       
    ,M.SALES_LINE_QTY_KWH_BU     
    ,M.SALES_LINE_QTY_SM3_BU     
    ,M.NET_SALES_LINE_AMT_BU     
    ,M.MARGIN_LINE_AMT_BU        
    ,M.NET_SALES_LINE_AMT_EUR_BU 
    ,M.NET_MARGIN_LINE_AMT_EUR_BU
    ,M.PPN_SRC 
FROM    
                MONTHLY M
LEFT JOIN 
                ATTRIBUTES A  
                               ON A.PROFIT_CENTER_EXT_REFR = (CASE WHEN M.PC_L7 = 'N/A' AND M.PC_L6 = 'N/A' AND M.PC_L5 = 'N/A' THEN M.PC_LEVEL04_EXT_REFR
                                                       WHEN M.PC_L7 = 'N/A' AND M.PC_L6 = 'N/A' THEN M.PC_LEVEL05_EXT_REFR 
                                                       WHEN M.PC_L7 = 'N/A' THEN M.PC_LEVEL06_EXT_REFR 
                                                       ELSE M.PC_LEVEL07_EXT_REFR
                                                       END)                       








