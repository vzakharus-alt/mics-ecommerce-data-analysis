# 📊 MICS 2025-2026: Соціально-Економічний Аналіз та Дашборд Добробуту в Україні

## 📌 Про Проєкт
Комплексне аналітичне дослідження на основі Багатоіндикаторного кластерного моніторингу (MICS) за 2025–2026 роки. Проєкт спрямований на оцінку впливу військового вторгнення на внутрішню міграцію, рівень доходів населення та загальний індекс добробуту домогосподарств України.

## 🛠 Технологічний стек
* **Бази даних:** SQL (Google BigQuery, PostgreSQL)
* **Обробка та EDA:** MS Excel, Google Sheets, Pandas (Python)
* **Візуалізація:** Tableau, Excel Dashboarding

## 🗂 Структура Проєкту в Репозиторії
* `Prizvysche_MICS_Project1.xlsx` — фінальний файл із розрахунками, SQL-запитами та інтерактивним дашбордом.
* `queries.sql` — чисті SQL-скрипти для BigQuery.
* `README.md` — аналітичний звіт та висновки.

## 📈 Головні SQL-Запити (BigQuery)

### 1. Регіональний аналіз падіння доходів населення
```sql
SELECT 
    HH7 AS oblast,
    COUNT(CASE_ID) AS total_respondents,
    SUM(CASE WHEN PE20 = 2 THEN 1 ELSE 0 END) AS respondents_with_loss,
    ROUND((SUM(CASE WHEN PE20 = 2 THEN 1 ELSE 0 END) / COUNT(CASE_ID)) * 100, 2) AS income_drop_percentage
FROM `mics_2026.women_dataset`
GROUP BY oblast
ORDER BY income_drop_percentage DESC;
```

### 2. Вплив освітнього цензу матері на індекс маси тіла дитини (ZBMI)
```sql
SELECT 
    w.ED4 AS mother_education_level,
    COUNT(c.child_id) AS total_children,
    AVG(c.ZBMI) AS average_child_bmi_zscore
FROM `mics_2026.child_dataset` AS c
JOIN `mics_2026.women_dataset` AS w 
  ON c.HH1 = w.HH1 AND c.HH2 = w.HH2 AND c.LN = w.LN
WHERE c.ZBMI IS NOT NULL
GROUP BY mother_education_level
ORDER BY average_child_bmi_zscore DESC;
```

## 📝 Ключові Висновки Аналізу (Conclusions)
1. **Масштаби ВПО:** Військове вторгнення спричинило переміщення понад 25% опитаних домогосподарств, що підтверджує високий рівень внутрішньої міграції.
2. **Економічний удар:** У 55.4% респондентів суттєво зменшився рівень щомісячного доходу. Головний драйвер збитків — втрата робочих місць та закриття локальних бізнесів.
3. **Гіпотеза міграції:** Гіпотеза про те, що внутрішньо переміщені особи (ВПО) зазнають більших фінансових втрат, підтвердилася. Рівень падіння доходів серед ВПО на 34.2% вищий порівняно зі стабільним населенням.
4. **Рекомендація бізнесу та NGO:** Необхідно переорієнтувати програми грошової допомоги на гранти для відкриття мікробізнесів та субсидування робочих місць у приймаючих регіонах для довгострокової економічної стабілізації.
