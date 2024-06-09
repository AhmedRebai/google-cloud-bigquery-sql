-- Task 1. Create BigQuery dataset and tables using DDL statements


-- create schema if not exists animals_dataset options(location="us");

-- create table animals_dataset.owners (OwnerID int64 not null, name string);

-- create table animals_dataset.pets(
--   PetID int64 not null,
--   OwnerID int64 not null, 
--   Type string,
--   Name string,
--   Weight float64
-- );

-- load data into animals_dataset.owners 
-- from files (
--   skip_leading_rows = 1,
--   format = 'CSV',
--   field_delimiter = ',',
--   uris = ['gs://tcd_repo/data/environmental/animals/owners.csv']
-- );

load data into animals_dataset.pets 
from files (
  skip_leading_rows = 1,
  format = 'CSV',
  field_delimiter = ",",
  uris = ['gs://tcd_repo/data/environmental/animals/pets.csv']
);

-- Task 2. Update BigQuery table data using DML statements

INSERT INTO 
  animals_dataset.owners (OwnerID, Name) 
VALUES 
  (9, 'Mary'); 

INSERT INTO 
  animals_dataset.pets (PetID, OwnerID, Type, Name, Weight) 
VALUES 
    (28, 9, 'Dog', "George", 50); 


INSERT INTO 
  animals_dataset.pets (PetID, OwnerID, Type, Name, Weight) 
VALUES 
  (29, 9, 'Dog', "Washington", 60);

SELECT o.Name, p.Type, p.Name 
FROM 
  animals_dataset.owners o 
JOIN 
  animals_dataset.pets p 
ON 
  o.OwnerID = p.OwnerID
WHERE 
  o.Name = 'Mary'; 

UPDATE 
  animals_dataset.pets
SET 
  Type = 'Canine'
WHERE 
  Type = 'Dog'; 

DELETE FROM
  animals_dataset.pets
WHERE 
  Type = 'Frog';

-- Task 3. Join data and write CTEs using SQL SELECT statements





