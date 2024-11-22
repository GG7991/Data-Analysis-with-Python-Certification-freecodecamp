CREATE TABLE demographic_data (
    age INT,
    workclass VARCHAR(50),
    fnlwgt INT,
    education VARCHAR(50),
    "education-num" INT,
    "marital-status" VARCHAR(50),
    occupation VARCHAR(50),
    relationship VARCHAR(50),
    race VARCHAR(50),
    sex VARCHAR(10),
    "capital-gain" INT,
    "capital-loss" INT,
    "hours-per-week" INT,
    "native-country" VARCHAR(50),
    salary VARCHAR(10)
);
TABLE demographic_data ;
--How many of each race are represented in this dataset? 
--This should be a Pandas series with race names as the index labels.
SELECT DISTINCT race, count(race) total_amount
FROM 
	demographic_data
GROUP BY
	race
LIMIT 5;

-- What is the average age of men?
SELECT 
	avg(age) average_age
FROM 
	demographic_data 
WHERE 
	sex='Male';

--What is the percentage of people who have a Bachelor's degree?
SELECT round(((SELECT count(*) 
			   FROM demographic_data 
			   WHERE education='Bachelors') * 100.0 / 
			   (SELECT count(*) FROM demographic_data)),1)
					AS percentage_bachelors;
--What percentage of people with advanced education (Bachelors, Masters, or Doctorate) make more than 50K?			
SELECT ((SELECT count(*) 
		 FROM demographic_data 
		 WHERE education IN ('Bachelors','Masters', 'Doctorate')
		 AND salary = '>50K') * 100.0) / 
		 (SELECT count(*) FROM demographic_data)
				AS higher_education_rich;	
---# What percentage of people without advanced education make more than 50K?
SELECT ((SELECT count(*) 
		 FROM demographic_data 
		 WHERE education NOT IN ('Bachelors','Masters', 'Doctorate')
		 AND salary = '>50K') * 100.0) / 
		 (SELECT count(*) FROM demographic_data)
				AS lower_education_rich;

--What is the minimum number of hours a person works per week (hours-per-week feature)?
SELECT 
	min("hours-per-week")
FROM 
	demographic_data dd ;

-- What percentage of the people who work the minimum number of hours per week have a salary of >50K?			
SELECT 
    (COUNT(*) * 100.0) / (SELECT COUNT(*) FROM demographic_data) AS lower_education_rich
FROM 
    demographic_data
WHERE 
    "hours-per-week" = (SELECT MIN("hours-per-week") FROM demographic_data) 
    AND salary = '>50K';
-- What country has the highest percentage of people that earn >50K?
SELECT 
    "native-country", 
    (COUNT(CASE WHEN salary = '>50K' THEN 1 END) * 100.0) / COUNT(*) AS highest_earning_country_percentag
FROM 
    demographic_data
GROUP BY 
    "native-country"
ORDER BY 
    highest_earning_country_percentag DESC
LIMIT 1; 


SELECT occupation, COUNT(*) AS num_individuals
FROM demographic_data dd 
WHERE salary = '>50K' AND "native-country" = 'India'
GROUP BY occupation
ORDER BY num_individuals DESC
LIMIT 1;
   
			
			