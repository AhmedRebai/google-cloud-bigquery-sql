
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

### To verify the random sampling method  (train test split) 
``` sql
select
dataframe, target, count(*)
from `mon-premier-projet-2022-ahmed.bank_marketing.marketing_tab`
group by dataframe, target
order by dataframe
```

### Perform a classification using the mathematical model logistic regression with sql
``` sql 
create or replace model `mon-premier-projet-2022-ahmed.bank_marketing.marketing_model`
options
(model_type='LOGISTIC_REG',
auto_class_weights=TRUE,
input_label_cols=['target']
) as 
select * except(dataframe)
from `mon-premier-projet-2022-ahmed.bank_marketing.marketing_tab`
where dataframe = 'training'
```

### How to get the Model training info
``` sql
select 
*
from 
ml.training_info(model `mon-premier-projet-2022-ahmed.bank_marketing.marketing_model`)
```

### How to get features infos like describe in pandas
``` sql
select 
* 
from 
ml.feature_info(model `mon-premier-projet-2022-ahmed.bank_marketing.marketing_model`)
```

### How to get the model weights
``` sql 
select 
*
from 
ml.weights(Model `mon-premier-projet-2022-ahmed.bank_marketing.marketing_model`)
```


### How to evaluate the logistic regression on the evaluation dataset
``` sql
select *
from ml.evaluate(model `mon-premier-projet-2022-ahmed.bank_marketing.marketing_model`,

(select * from `mon-premier-projet-2022-ahmed.bank_marketing.marketing_tab` where dataframe = 'evaluation')
)
```

### How to predict 
``` sql 
select *
from ml.predict(model `mon-premier-projet-2022-ahmed.bank_marketing.marketing_model`,

(select * from `mon-premier-projet-2022-ahmed.bank_marketing.marketing_tab` where dataframe = 'prediction')
)
```
