WITH PLAN AS(
                SELECT  
                        CO.COUNTRY_EXT_REFR
                        ,CO.COMPANY_CODE_PIS
                        ,CASE WHEN CO.COMPANY_CODE = '821071' THEN '3000' ELSE CO.COMPANY_CODE END AS COMPANY_CODE
                        ,CASE WHEN CO.COMPANY_CODE = '821071' THEN 'Petrol d.o.o., Zagreb' ELSE CO.NAME END AS COMPANY_NAME
                        ,T.DATE_SID ACCOUNTING_DATE_SID
                        ,DAT.EXT_REFR AS ACCOUNTING_DATE
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
                        ,COALESCE(CAST(ROUND(SALES_LINE_QTY, 3) AS DECIMAL(30,3)),0) AS SALES_LINE_QTY_BU
                        ,COALESCE(CAST(ROUND(SALES_LINE_QTY_KG, 3) AS DECIMAL(30,3)),0) AS SALES_LINE_QTY_KG_BU
                        ,COALESCE(CAST(ROUND(SALES_LINE_QTY_LITER, 3) AS DECIMAL(30,3)),0) AS SALES_LINE_QTY_L_BU
                        ,COALESCE(CAST(ROUND(SALES_LINE_QTY_KWH, 3) AS DECIMAL(30,3)),0) AS SALES_LINE_QTY_KWH_BU
                        ,COALESCE(CAST(ROUND(SALES_LINE_QTY_SM3, 3) AS DECIMAL(30,3)),0) AS SALES_LINE_QTY_SM3_BU
                        ,COALESCE(CAST(ROUND(NET_SALES_LINE_AMT, 6) AS DECIMAL(30,6)),0) AS NET_SALES_LINE_AMT_BU  
                        ,COALESCE(CAST(ROUND(MARGIN_LINE_AMT, 6) AS DECIMAL(30,6)),0) AS MARGIN_LINE_AMT_BU
                        ,COALESCE(CAST(ROUND(NET_SALES_LINE_AMT*(CASE WHEN ER.EXCHANGE_RATE_FLOAT IS NULL THEN 1 ELSE ER.EXCHANGE_RATE_FLOAT END), 6) AS DECIMAL(30,6)),0) AS NET_SALES_LINE_AMT_EUR_BU
                        ,COALESCE(CAST(ROUND(MARGIN_LINE_AMT*(CASE WHEN ER.EXCHANGE_RATE_FLOAT IS NULL THEN 1 ELSE ER.EXCHANGE_RATE_FLOAT END), 6) AS DECIMAL(30,6)),0) AS NET_MARGIN_LINE_AMT_EUR_BU     
                        ,3 AS PPN_SRC
                FROM 
                               APLSDB.F_SALES_PLAN_DAILY T
                LEFT JOIN 
                               APLSDB.D_DATE DAT 
                                               ON DAT.DATE_SID=T.DATE_SID
                LEFT JOIN 
                               APLSDB.D_DATE DATX 
                               ON DATX.MONTH_ID=DAT.MONTH_ID 
                               AND DATX.DAY_OF_MONTH = 1
                ----------------COMPANY----------------------------------------------------
                INNER JOIN 
                               APLSDB.D_COMPANY CO 
                                               ON CO.COMPANY_SID=T.COMPANY_SID  --AND CO.VLD_TO_DT='9999-12-31 00:00:00'
                -----------------PROFITNI CENTRI---------------------------------------------
                INNER JOIN  
                               APLSDB.V_PROFIT_CENTER_BI T44               
                                               ON  T.PROFIT_CENTER_SID  = T44.PROFIT_CENTER_SID     
                                               AND T44.HIERARCHY_EXT_REFR in ('PC|STD_SAP_PIS', 'PC|PIS') 
                 --------------PRODUKTI----------------------------------------------------------
                INNER JOIN       
                               APLSDB.V_PRODUCT_BI PR                
                                               ON  T.PRODUCT_SID = PR.PRODUCT_SID 
                                               AND PR.HIERARCHY_EXT_REFR = 'PR|SAP' -- -- 'PR|PIS'                         
                --------------------PLAÈEVANJE----------------------------------------------------------------------
                LEFT JOIN
                               APLSDB.D_EXCHANGE_RATE ER 
                                               ON T.CURRENCY_SID = ER.CURRENCY_FROM_SID 
                                               AND ER.CURRENCY_TO_EXT_REFR ='EUR' 
                                               AND ER.EXCHANGE_RATE_TYPE_EXT_REFR = 'PLN D' 
                                               AND CAST(TO_VARCHAR(ER.EFF_TO_DT, 'YYYYMMDD')  AS INTEGER ) = T.DATE_SID 
                                               AND CO.COUNTRY_SID=ER.COUNTRY_SID --AND CO.COUNTRY_EXT_REFR=ER.COUNTRY_EXT_REFR
                --INNER JOIN D_PAYMENT_METHOD_HIERARCHY PM ON T.PAYMENT_METHOD_SID=PM.PAYMENT_METHOD_SID
                ----------------------------------------------------------------------------------
                WHERE DAT.YEAR IN (YEAR(CURRENT_DATE), YEAR(CURRENT_DATE) - 1) 
                               AND CO.COMPANY_CODE in ('1000', '3000', '821071','812820', '812892', '812968', '812969')
                               AND ((T44.HIERARCHY_EXT_REFR = 'PC|STD_SAP_PIS' and T44.LEVEL05_CODE in ('0P111')) OR (T44.HIERARCHY_EXT_REFR = 'PC|PIS' and T44.LEVEL03_CODE in ('4803', '6801', '3203', '6901')))
                               AND SCENARIO = 'P'
                               AND VERSION =1
                               AND STATUS ='C'
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
        MAX(CASE WHEN UPPER(PCA.ATTRIBUTE_NAME) = 'INŠTRUKTORJI SLOVENIJA'         THEN PCA.ATTRIBUTE_VALUE_STRING
                 WHEN UPPER(PCA.ATTRIBUTE_NAME) = 'INŠTRUKTORJI BIH'               THEN PCA.ATTRIBUTE_VALUE_STRING 
                 WHEN UPPER(PCA.ATTRIBUTE_NAME) = 'INŠTRUKTORJI HRVAŠKA'           THEN PCA.ATTRIBUTE_VALUE_STRING 
                 ELSE NULL END)                                                                                           
            AS INSTRUKTORJI,             
        MAX(CASE WHEN UPPER(PCA.ATTRIBUTE_NAME) = 'PRODAJNA POVRŠINA'              THEN PCA.ATTRIBUTE_VALUE_NUMERIC ELSE -1  END) AS PRODAJNA_POVRSINA,
        MAX(CASE WHEN UPPER(PCA.ATTRIBUTE_NAME) IN ('FRESH', 'FRESH - MINI', 'DOPEKA') THEN PCA.ATTRIBUTE_NAME     ELSE NULL END) AS FRESH,
        MAX(CASE WHEN UPPER(PCA.ATTRIBUTE_NAME) = 'AVTOPRALNICE NA BS'             THEN PCA.ATTRIBUTE_VALUE_STRING ELSE NULL END) AS AVTOPRALNICA
        
FROM    
                APLSDB.F_PROFIT_CENTER_BI T44
LEFT JOIN 
APLSDB.D_PROFIT_CENTER_ATTRIBUTE PCA 
                ON T44.PROFIT_CENTER_SID = PCA.PROFIT_CENTER_SID
WHERE   UPPER(ATTRIBUTE_NAME) IN ('BS GEOGRAFSKO', 'LOKACIJA BS', 'BS PO REGIJAH', 'BS PO REGIJAH PETROL BEOGRAD',
                           'INŠTRUKTORJI SLOVENIJA', 'INŠTRUKTORJI BIH', 'INŠTRUKTORJI HRVAŠKA', 
                           'PRODAJNA POVRŠINA', 'FRESH', 'FRESH - MINI', 'DOPEKA', 'AVTOPRALNICE NA BS')
AND PCA.VLD_TO_DT = TO_DATE('9999-12-31', 'YYYY-MM-DD')
GROUP BY
        T44.PROFIT_CENTER_EXT_REFR,
        T44.PROFIT_CENTER_CODE,
        T44.PROFIT_CENTER_NAME
)


SELECT  
        P.COUNTRY_EXT_REFR
        ,P.COMPANY_CODE_PIS
    ,P.COMPANY_CODE
    ,P.COMPANY_NAME
    ,P.ACCOUNTING_DATE_SID
    ,P.ACCOUNTING_DATE
    ,P.CUSTOMER_TYPE_CODE
    ,P.CUSTOMER_TYPE
    ,P.PAYMENT_METHOD
    ,P.IS_OWN_USAGE
    ,CASE WHEN P.PC_L7 = 'N/A' AND P.PC_L6 = 'N/A' AND P.PC_L5 = 'N/A'    THEN P.PC_LEVEL04_EXT_REFR
          WHEN P.PC_L7 = 'N/A' AND P.PC_L6 = 'N/A'                        THEN P.PC_LEVEL05_EXT_REFR 
          WHEN P.PC_L7 = 'N/A'                                            THEN P.PC_LEVEL06_EXT_REFR 
          ELSE P.PC_LEVEL07_EXT_REFR
          END AS PROFIT_CENTER_EXT_REFR
    ,CASE WHEN P.PC_L7 = 'N/A' AND P.PC_L6 = 'N/A' AND P.PC_L5 = 'N/A'    THEN P.PC_L4
          WHEN P.PC_L7 = 'N/A' AND P.PC_L6 = 'N/A'                        THEN P.PC_L5 
          WHEN P.PC_L7 = 'N/A'                                            THEN P.PC_L6 
          ELSE P.PC_L7
          END AS PROFIT_CENTER_CODE
    ,CASE WHEN P.PC_L7 = 'N/A' AND P.PC_L6 = 'N/A' AND P.PC_L5 = 'N/A'    THEN P.PC_L4_NAME
          WHEN P.PC_L7 = 'N/A' AND P.PC_L6 = 'N/A'                        THEN P.PC_L5_NAME 
          WHEN P.PC_L7 = 'N/A'                                            THEN P.PC_L6_NAME 
          ELSE P.PC_L7_NAME
          END AS PROFIT_CENTER_NAME
    ,IFNULL(A.BS_GEOGRAFSKO, 'N/A')         AS BS_GEOGRAFSKO    
    ,IFNULL(A.LOKACIJA_BS, 'N/A')           AS LOKACIJA_BS
    ,IFNULL(A.BS_PO_REGIJAH, 'N/A')         AS BS_PO_REGIJAH
    ,IFNULL(A.INSTRUKTORJI, 'N/A')          AS INSTRUKTORJI
    ,IFNULL(A.PRODAJNA_POVRSINA, -1)        AS PRODAJNA_POVRSINA
    ,IFNULL(A.FRESH, 'N/A')                 AS FRESH
    ,IFNULL(A.AVTOPRALNICA, 'N/A')          AS AVTOPRALNICA    
    ,P.PC_LEVEL01_EXT_REFR, P.PC_L1, P.PC_L1_NAME     
    ,P.PC_LEVEL02_EXT_REFR, P.PC_L2, P.PC_L2_NAME           
    ,P.PC_LEVEL03_EXT_REFR, P.PC_L3, P.PC_L3_NAME            
    ,P.PC_LEVEL04_EXT_REFR, P.PC_L4, P.PC_L4_NAME 
    ,P.PC_LEVEL05_EXT_REFR, P.PC_L5, P.PC_L5_NAME     
    ,P.PC_LEVEL06_EXT_REFR, P.PC_L6, P.PC_L6_NAME     
    ,P.PC_LEVEL07_EXT_REFR, P.PC_L7, P.PC_L7_NAME      
    ,P.PRODUCT_CODE, P.PRODUCT_NAME_SHORT     
    ,0 AS IS_AGGREGATED
    ,P.PR_L1, P.PR_L1_NAME
    ,P.PR_L2, P.PR_L2_NAME
    ,P.PR_L3, P.PR_L3_NAME
    ,P.PR_L4, P.PR_L4_NAME
    ,P.PR_L5, P.PR_L5_NAME
    ,P.PR_L6, P.PR_L6_NAME
    ,P.PR_L7, P.PR_L7_NAME
    ,P.PR_L8, P.PR_L8_NAME
    ,P.PR_L9, P.PR_L9_NAME
    ,P.PR_L10, P.PR_L10_NAME 
    ,P.SALES_LINE_QTY_AC                           
    ,P.SALES_LINE_QTY_KG_AC                        
    ,P.SALES_LINE_QTY_L_AC                         
    ,P.SALES_LINE_QTY_KWH_AC                       
    ,P.SALES_LINE_QTY_SM3_AC                       
    ,P.NET_SALES_LINE_AMT_AC                       
    ,P.NET_MARGIN_LINE_AMT_AC                      
    ,P.NET_SALES_LINE_AMT_EUR_AC
    ,P.NET_MARGIN_LINE_AMT_EUR_AC                                                      
    ,P.SALES_LINE_QTY_PY                          
    ,P.SALES_LINE_QTY_KG_PY                       
    ,P.SALES_LINE_QTY_L_PY                        
    ,P.SALES_LINE_QTY_KWH_PY                      
    ,P.SALES_LINE_QTY_SM3_PY                      
    ,P.NET_SALES_LINE_AMT_PY                      
    ,P.NET_MARGIN_LINE_AMT_PY                     
    ,P.NET_SALES_LINE_AMT_EUR_PY
    ,P.NET_MARGIN_LINE_AMT_EUR_PY
    ,P.SALES_LINE_QTY_BU         
    ,P.SALES_LINE_QTY_KG_BU      
    ,P.SALES_LINE_QTY_L_BU       
    ,P.SALES_LINE_QTY_KWH_BU     
    ,P.SALES_LINE_QTY_SM3_BU     
    ,P.NET_SALES_LINE_AMT_BU     
    ,P.MARGIN_LINE_AMT_BU        
    ,P.NET_SALES_LINE_AMT_EUR_BU 
    ,P.NET_MARGIN_LINE_AMT_EUR_BU
    ,P.PPN_SRC 
FROM    
                PLAN P
LEFT JOIN 
                ATTRIBUTES A  
                               ON A.PROFIT_CENTER_EXT_REFR = (CASE WHEN P.PC_L7 = 'N/A' AND P.PC_L6 = 'N/A' AND P.PC_L5 = 'N/A' THEN P.PC_LEVEL04_EXT_REFR
                                                       WHEN P.PC_L7 = 'N/A' AND P.PC_L6 = 'N/A' THEN P.PC_LEVEL05_EXT_REFR 
                                                       WHEN P.PC_L7 = 'N/A' THEN P.PC_LEVEL06_EXT_REFR 
                                                       ELSE P.PC_LEVEL07_EXT_REFR
                                                       END)       

