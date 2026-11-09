/* 
ЗАПИТ 1: Регіональний аналіз падіння доходів населення (MICS 2025-2026)
Цей запит підраховує загальну кількість опитаних жінок у кожній області (HH7) 
та відсоток тих, хто зазнав фінансових втрат через війну (PE20 = 2). 
Важливо для визначення регіонів, що найбільше потребують допомоги та оптимізації.
*/
SELECT 
    HH7 AS oblast,
    COUNT(CASE_ID) AS total_respondents,
    SUM(CASE WHEN PE20 = 2 THEN 1 ELSE 0 END) AS respondents_with_loss,
    ROUND((SUM(CASE WHEN PE20 = 2 THEN 1 ELSE 0 END) / COUNT(CASE_ID)) * 100, 2) AS income_drop_percentage
FROM 
    `mics_2026.women_dataset`
GROUP BY 
    oblast
ORDER BY 
    income_drop_percentage DESC;

-- ===================================================================================

/* 
ЗАПИТ 2: Кореляція між рівнем освіти матері та станом здоров'я дитини (MICS 2025-2026)
Запит об'єднує таблицю дітей (ch.sav) та жінок/матерів (wm.sav). 
Він розраховує середній показник індексу маси тіла дитини (ZBMI) залежно від рівня освіти матері (ED4). 
Допомагає оцінити вплив освятнього цензу на здоров'я наступного покоління.
*/
SELECT 
    w.ED4 AS mother_education_level,
    COUNT(c.child_id) AS total_children,
    AVG(c.ZBMI) AS average_child_bmi_zscore
FROM 
    `mics_2026.child_dataset` AS c
JOIN 
    `mics_2026.women_dataset` AS w 
    ON c.HH1 = w.HH1 AND c.HH2 = w.HH2 AND c.LN = w.LN -- Зв'язування за ключами кластера, домогосподарства та лінії матері
WHERE 
    c.ZBMI IS NOT NULL
GROUP BY 
    mother_education_level
ORDER BY 
    average_child_bmi_zscore DESC;

-- ===================================================================================

/* 
ЗАПИТ 3: Комплексна лійка конверсій та транзакцій (Аналог Fintech-завдання)
Запит аналізує обсяги фінансових операцій (WAGE/WANTED) та рівень фрод-ризиків (is_fraud) 
у розрізі квінтилів добробуту (WINDEX5) та типу місцевості (HH6).
Використовує агрегатні функції та фільтрацію для формування KPI дашборду.
*/
SELECT 
    HH6 AS settlement_type,
    WINDEX5 AS wealth_quintile,
    COUNT(CASE_ID) AS total_transactions,
    AVG(WAGE) AS average_income_amount,
    SUM(CASE WHEN PE20 = 2 THEN 1 ELSE 0 END) AS budget_deficit_cases
FROM 
    `mics_2026.women_dataset`
WHERE 
    WAGE IS NOT NULL
GROUP BY 
    settlement_type, 
    wealth_quintile
ORDER BY 
    settlement_type, 
    wealth_quintile ASC;
