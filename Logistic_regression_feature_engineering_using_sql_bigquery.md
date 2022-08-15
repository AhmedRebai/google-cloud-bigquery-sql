
### To see all the table 

``` sql
SELECT * FROM `mon-premier-projet-2022-ahmed.bank_marketing.marketing`
```

### To see if the data is imbalanced or not 
``` sql
select y as target, count(*) as number_class_y
from `mon-premier-projet-2022-ahmed.bank_marketing.marketing`
group by y
```

### The equivalent of the python function train test split but with sql 
``` sql 
create or replace table `bank_marketing.marketing_tab` as
select age, job, marital, education, 'default' as derog, balance, housing, loan, contact, day,month, campaign, pdays, previous, poutcome, target,
case 
  when split_field < 0.8 then 'training'
  when split_field = 0.8 then  'evaluation'
  when  split_field > 0.8 then 'prediction'
end as dataframe
from ( 
select 
age, job, marital, education, 'default', balance,
 housing, loan, contact, day,month, campaign, pdays,
  previous, poutcome, y as target, 
round(abs(rand()),1) as split_field
from `mon-premier-projet-2022-ahmed.bank_marketing.marketing` )
```

