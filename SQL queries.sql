SELECT
    p.product_id AS productId,
    SUM(p.weight * op.quantity) AS totalWeight
FROM orders o
JOIN orders_products op ON o.order_id = op.order_id
JOIN products p ON op.product_id = p.product_id
JOIN route_segments rs ON rs.order_id = o.order_id
WHERE o.customer_id = 32
  AND rs.segment_type = 'STOP'
  AND DATE(rs.segment_end_time) = '2024-02-13'
GROUP BY p.product_id
ORDER BY totalWeight ASC;

select segment_start_time, segment_end_time
from route_segments
where segment_start_time > segment_end_time;

SELECT
    CEIL(TIMESTAMPDIFF(SECOND, segment_start_time, segment_end_time) / 60) AS delivery_minutes,
    COUNT(*) AS deliveries_count
FROM route_segments
WHERE segment_type = 'STOP'
  AND TIMESTAMPDIFF(SECOND, segment_start_time, segment_end_time) >= 0
GROUP BY delivery_minutes
ORDER BY delivery_minutes;

SELECT
    o.order_id,
    o.planned_delivery_duration / 60 AS planned_minutes,
    CEIL(TIMESTAMPDIFF(SECOND, rs.segment_start_time, rs.segment_end_time) / 60) AS actual_minutes,
    (o.planned_delivery_duration / 60) - CEIL(TIMESTAMPDIFF(SECOND, rs.segment_start_time, rs.segment_end_time) / 60) AS prediction_error_minutes
FROM orders o
JOIN route_segments rs ON o.order_id = rs.order_id
WHERE rs.segment_type = 'STOP';

SELECT
    o.sector_id,
    COUNT(*) AS deliveries,
    ROUND(AVG(TIMESTAMPDIFF(SECOND, rs.segment_start_time, rs.segment_end_time)) / 60, 2) AS avg_delivery_minutes
FROM orders o
JOIN route_segments rs ON o.order_id = rs.order_id
WHERE rs.segment_type = 'STOP'
GROUP BY o.sector_id
ORDER BY avg_delivery_minutes DESC;

select count(*), sector_id from orders group by sector_id;

SELECT
    CASE
        WHEN total_weight < 2 THEN '<2kg'
        WHEN total_weight BETWEEN 2 AND 5 THEN '2–5kg'
        WHEN total_weight BETWEEN 5 AND 10 THEN '5–10kg'
        ELSE '>10kg'
    END AS weight_range,
    ROUND(AVG(delivery_minutes), 2) AS avg_delivery_time_min,
    COUNT(*) AS num_deliveries
FROM (
    SELECT
        o.order_id,
        SUM(p.weight * op.quantity) / 1000 AS total_weight,  -- kg
        TIMESTAMPDIFF(SECOND, rs.segment_start_time, rs.segment_end_time) / 60 AS delivery_minutes
    FROM orders o
    JOIN orders_products op ON o.order_id = op.order_id
    JOIN products p ON op.product_id = p.product_id
    JOIN route_segments rs ON rs.order_id = o.order_id
    WHERE rs.segment_type = 'STOP'
    GROUP BY o.order_id, rs.segment_id
) AS weighted_deliveries
GROUP BY weight_range
ORDER BY avg_delivery_time_min DESC;