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

### 2 - Use ‘regexp_extract’ to replace ‘Case-when Like’
* Instead of this 
``` sql 
SELECT
CASE
WHEN concat(' ',item_name,' ') LIKE '%acer%' then 'Acer'
WHEN concat(' ',item_name,' ') LIKE '%advance%' then 'Advance'
WHEN concat(' ',item_name,' ') LIKE '%alfalink%' then 'Alfalink'
...
AS brand
FROM item_list

```

* Do this
``` sql 
SELECT
regexp_extract(item_name,'(asus|lenovo|hp|acer|dell|zyrex|...)')
AS brand
FROM item_list

```

### 3 - Convert long list of IN clause into a temporary table
* Instead of this 
``` sql 
SELECT *
FROM Table1 as t1
WHERE
itemid in (3363134, 5189076, ..., 4062349)
```

* Do this
``` sql 
SELECT *
FROM Table1 as t1
JOIN (
SELECT
itemid
FROM (
SELECT
split('3363134, 5189076, ...,', ', ')
as bar
)
CROSS JOIN
UNNEST(bar) AS t(itemid)
) AS Table2 as t2
ON
t1.itemid = t2.itemid

```

### 4 - Always order your JOINs from largest tables to smallest tables

* Instead of this 
``` sql 
SELECT
*
FROM
small_table
JOIN
large_table
ON small_table.id = large_table.id
```

* Do this
``` sql 
SELECT
*
FROM
large_table
JOIN
small_table
ON small_table.id = large_table.id
```


