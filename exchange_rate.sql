use database dwh_prod;
use schema aplsdb;

with 
ac as (
        select  
                eff_to_dt,
                country_ext_refr,
                currency_from_ext_refr,
                exchange_rate_float
        from    d_exchange_rate ex
        where   ex.exchange_rate_type_ext_refr = 'D'
        and     ex.currency_to_ext_refr = 'EUR'
        and     eff_to_dt between '2020-01-01' and '2020-02-29'
), 

py as (
        select  
                dateadd(year, 1, eff_to_dt) as eff_to_dt,
                country_ext_refr,
                currency_from_ext_refr,
                exchange_rate_float
        from    d_exchange_rate ex
        where   ex.exchange_rate_type_ext_refr = 'D'
        and     ex.currency_to_ext_refr = 'EUR'
        and     eff_to_dt between '2019-01-01' and '2019-02-28'
)

select 
        'AC',
        ac.eff_to_dt,
        ac.country_ext_refr,
        ac.currency_from_ext_refr,
        ac.exchange_rate_float,
        'PY',
        py.eff_to_dt,        
        py.country_ext_refr,
        py.currency_from_ext_refr,
        py.exchange_rate_float,
        
        case 
        when ac.exchange_rate_float = py.exchange_rate_float then true
        else false
        end as ac_equals_py
                
from    ac
        full join py on ac.country_ext_refr        = py.country_ext_refr           and
                        ac.currency_from_ext_refr  = py.currency_from_ext_refr     and
                        ac.eff_to_dt               = py.eff_to_dt                  

order by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10




