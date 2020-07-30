use database dwh_test;
use schema aplsdb;

--Sql1
SELECT 1
,pr.PRODUCT_CODE, profit_center_code

--,pr.product_code_sap,pr.product_code_sap,pr3.product_code_sap,pr4.product_code_sap,pr5.product_code_sap,pr6.product_code_sap
,sum(nvl(PURCHASE_PRICE_LINE_AMT,0)+nvl(STATE_FEE_line_AMT,0)+nvl(EXCISE_FEE_line_AMT,0)+nvl(MEMBERSHIP_FEE_line_AMT,0)  + nvl(PURCHASE_PRICE_AMAP_LINE_AMT,0) + nvl(MARGIN_LINE_AMT,0)+nvl(GROUP_MARGIN_LINE_AMT,0) + nvl(MARGIN_AMAP_LINE_AMT,0)  - nvl(MARGIN_DISCOUNT_LINE_AMT,0))  NET_SALES_LINE_AMT
,sum(nvl(MARGIN_LINE_AMT,0)+ nvl(GROUP_MARGIN_LINE_AMT,0) + nvl(MARGIN_AMAP_LINE_AMT,0)  - nvl(MARGIN_DISCOUNT_LINE_AMT,0) ) NET_MARGIN_LINE_AMT
,sum(A.SALES_LINE_QTY)
,sum(A.PURCHASE_PRICE_AMAP_LINE_AMT)
,sum(nvl(A.NET_SALES_SAP_LINE_AMT, 0) + nvl(MARGIN_DISCOUNT_LINE_AMT, 0))  -- za primrjavo s copa only  + MARGIN_DISCOUNT_LINE_AMT

FROM F_ISSUANCE A   
inner join D_PRODUCT pr                         on A.PRODUCT_SID = pr.PRODUCT_SID
inner join  d_PROFIT_CENTER pc                  ON  a.SALES_POINT_SID  = pc.PROFIT_CENTER_SID     and pc.profit_center_code like  '%202'
WHERE   A.ACCOUNTING_DATE_SID BETWEEN  20190101 AND 20190131
       and PRODUCT_CODE  = '1240|ST'
group by pr.PRODUCT_CODE, profit_center_code
;


