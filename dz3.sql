--1
SELECT uniqExact(v.idhash_view) AS view_s,
       uniqExact(o.idhash_order) AS order_s,
       countIf(o.da_dttm, o.da_dttm is not null) AS driver_found,
       countIf(o.rfc_dttm,o.rfc_dttm is not null) AS car_served,
       countIf(o.cc_dttm,o.cc_dttm is not null) AS client_in_car,
       countIf(o.finish_dttm,o.finish_dttm is not null) AS trip_over,
(view_s-order_s) AS dif_1,
(order_s-driver_found) AS dif_2,
(driver_found-car_served) AS dif_3,
(car_served-client_in_car) AS dif_4,
(client_in_car-trip_over) AS dif_5
FROM orders o RIGHT JOIN views v ON o.idhash_order = v.idhash_order;
-- На первых двух шагах потеря клиентов максимальная


--2
SELECT idhash_client AS client,
       topK(4)(tariff) AS top_tariff,
       uniqExact(tariff) AS number_of_tarifs
FROM views
GROUP BY client
ORDER BY client;


--3
--топ гексаконов, из которых уезжают
SELECT (geoToH3 (v.longitude, v.latitude, 7)) AS hexagon,
        uniqExact(idhash_order) as order_s
FROM orders o JOIN views v ON o.idhash_order = v.idhash_order
WHERE (formatDateTime(o.cc_dttm,'%T') >= '07:00:00'
           AND formatDateTime(o.cc_dttm,'%T') <= '10:00:00')
GROUP BY hexagon
ORDER BY order_s DESC
LIMIT 10

UNION ALL

--топ гексаконов, в которые приезжают
SELECT (geoToH3 (v.del_longitude,v.del_latitude, 7) ) AS hexagon,
       uniqExact (idhash_order) AS order_s
FROM orders o JOIN views v ON o.idhash_order = v.idhash_order
WHERE (formatDateTime(o.cc_dttm,'%T') >= '18:00:00'
           AND formatDateTime(cc_dttm,'%T') <= '20:00:00')
GROUP BY hexagon
ORDER BY order_s DESC
LIMIT 10;


--4
SELECT median(da_dttm - order_dttm) AS median,
       quantile(0.9)(da_dttm - order_dttm) AS quantile_90
FROM orders;
