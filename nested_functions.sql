--array 
SELECT [1,2,3,];

SELECT ['python', 'SQL', 'r'];
WITH skills AS (
    SELECT 'python' AS skill
    UNION ALL
    SELECT 'sql'
    UNION ALL
    SELECT 'r'
)
SELECT skill
FROM SKILLS;

SELECT ['python', 'SQL', 'r'];
WITH skills AS (
    SELECT 'python' AS skill
    UNION ALL
    SELECT 'sql'
    UNION ALL
    SELECT 'r'
)
SELECT ARRAY_AGG (skill) AS skills_array
FROM SKILLS;

SELECT ['python', 'SQL', 'r'];
WITH skills AS (
    SELECT 'python' AS skill
    UNION ALL
    SELECT 'sql'
    UNION ALL
    SELECT 'r'
), skills_array AS (
SELECT ARRAY_AGG (skill ORDER BY skill) AS skills
FROM SKILLS
)
SELECT
    skills [1] AS first_skill,
    skills [2] AS second_skill,
    skills [3] AS third_skill,
FROM skills_array;

--STRUCT
SELECT {skill: 'python', type: 'ML'} AS skill_struct;

WITH skill_struct AS (
    SELECT
        STRUCT_PACK(
            skill := 'python',
            type := 'programmimg'
        ) AS s
)
SELECT
    s.skill,
    s.type
FROM
    skill_struct;

--JSON

WITH raw_skill_json AS (
    SELECT
        '{"skill":"python", "type":"programmimg"}'::JSON AS skill_json
)
SELECT
    skill_json
FROM
    raw_skill_json;