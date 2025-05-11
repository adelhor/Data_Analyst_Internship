# SQL Queries for Delivery Performance Analysis

This repository contains a collection of SQL queries used to analyze delivery time predictions, segment performance, and order characteristics in a last-mile delivery logistics system.

## 📁 File Overview

### `SQL queries.sql`
This SQL file includes queries that support:

- Calculation of actual delivery durations using `route_segments` data
- Analysis of prediction error (difference between planned and actual delivery times)
- Grouping of orders by weight and evaluation of how weight affects delivery time
- Sector-based performance analysis (e.g., average delivery time per `sector_id`)
- Histogram preparation queries for charting delivery durations and prediction errors

## 🧾 Data Assumptions

These queries assume a database schema with the following tables:
- `orders`
- `route_segments` (with `segment_type` as `STOP` or `DRIVE`)
- `products`
- `orders_products`

> Note: Only `STOP` segments are linked to `order_id` and represent completed deliveries. `DRIVE` segments do not include `order_id` and are not used for final delivery time calculations.

## 🛠 Requirements

- MySQL database
- Tables and structure matching the assumptions described above
- Data preloaded into the system for accurate analysis

## 📊 Use Cases

These queries are useful for:
- Validating sector-level delivery performance
- Exploring relationships between order weight and delivery time
- Identifying potential improvements to delivery time prediction algorithms
- Supporting visualizations such as histograms and combo charts for reporting
