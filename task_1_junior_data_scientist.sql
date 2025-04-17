--Задание 1

--1. Актуальное состояние товаров на 2020-06-01

WITH latest_items AS (
    SELECT item_id,
           name,
           price,
           update_date,
           ROW_NUMBER() OVER (PARTITION BY item_id ORDER BY update_date DESC) AS rn
      FROM items
     WHERE update_date <= '2020-06-01'
)

SELECT item_id,
       name,
       price,
       update_date
  FROM latest_items
 WHERE rn = 1;

--2. Товары, купленные по цене больше или равно чем 3

SELECT DISTINCT 
       i.item_id,
       i.name,
       i.price,
       o.order_date
  FROM items AS i
  JOIN orders AS o ON i.item_id = o.item_id
 WHERE i.price >= 3;

--3. Сумма покупок клиента 1

SELECT SUM(i.price) AS total_sum
  FROM items AS i
  JOIN orders AS o ON i.item_id = o.item_id
 WHERE o.user_id = 1;

--4. Сумма всех покупок до 2020-05-01 включительно

SELECT SUM(i.price) AS total_sum
  FROM items AS i
  JOIN orders AS o ON i.item_id = o.item_id
 WHERE o.order_date <= '2020-05-01';

--5. Сумма всех заказов и средняя цена заказа поквартально

SELECT DATE_TRUNC('quarter', o.order_date) AS quarter,
       SUM(i.price) AS total_sum,
       AVG(i.price) AS avg_price
  FROM items AS i
  JOIN orders AS o ON i.item_id = o.item_id
 GROUP BY DATE_TRUNC('quarter', o.order_date)
 ORDER BY quarter;

--6. Оптимизация запросов для больших объемов данных

--1) Индексация: Создание индексов на часто используемых столбцах,
--таких как item_id, order_date, user_id, update_date, по которым нужно будет фильтровать и сортировать данные.

--2) Партиционирование: Разделение таблиц на партиции по дате или другим ключевым полям для ускорения запросов.

--3) Материализованные представления: Создание материализованных представлений для сложных запросов, 
--которые нечасто меняются.