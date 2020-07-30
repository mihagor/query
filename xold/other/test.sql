use database dwh_prod;
use schema aplsdb;

select  c.customer_sid,
        sum(i.net_sales_line_amt),
        cc.research,
        
                
from f_issuance i
        inner join d_customer c on c.customer_sid = i.customer_sid
        inner join d_custormer_core cc  cc.customer_code = c.customer_code
group by c.customer_sid;


from
(
        (
        select  distinct customer_sid,
        last_name,
        first_name
        from d_customer_contact__20190529
        where last_name = 'GORNIK'
        ) cc


)












