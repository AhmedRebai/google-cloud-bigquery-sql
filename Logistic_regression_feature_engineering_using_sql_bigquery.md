
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

