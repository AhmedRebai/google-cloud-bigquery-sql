# Optimization of some sql queries

### 1 - Use ‘regexp_like’ to replace ‘LIKE’ clauses

* Instead of this 
``` sql 
SELECT *
FROM
table1
WHERE
lower(item_name) LIKE '%samsung%' OR
lower(item_name) LIKE '%xiaomi%' OR
lower(item_name) LIKE '%iphone%' OR
lower(item_name) LIKE '%huawei%'
--and so on

```

* Do this
``` sql 
SELECT *
FROM
table1
WHERE
REGEXP_LIKE(lower(item_name),
'samsung|xiaomi|iphone|huawei')

```
