-- display the counts of each type of fraud
-- 


-- select count(*) FROM
--     aminno_member;

SELECT 
    fraud_flag,
    count(*) as row_count
FROM
    aminno_member as am
GROUP by fraud_flag
ORDER by row_count desc;


-- +------------+-----------+
-- | fraud_flag | row_count |
-- +------------+-----------+
-- |          0 |  36380665 |
-- |         64 |      5697 |
-- |         68 |      4776 |
-- |          1 |      4427 |
-- |         70 |      1925 |
-- |         66 |       596 |
-- |         69 |       483 |
-- |         65 |       331 |
-- |         67 |        41 |
-- |          2 |        38 |
-- |          5 |        37 |
-- |         71 |        37 |
-- |          4 |        23 |
-- |        324 |        22 |
-- |          7 |        14 |
-- |        320 |         3 |
-- |          6 |         2 |
-- |        326 |         1 |
-- +------------+-----------+
-- 18 rows in set (0.00 sec)
-- total: 36399118
-- 18,453 rows have a non-zero/non-null fraud flag
-- Therefore about 0.05% of the profiles have been flagged as fraud

