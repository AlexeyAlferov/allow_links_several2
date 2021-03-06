-- ******************** SqlDBM: Microsoft SQL Server ********************
-- ************************* Generated by SqlDBM ************************


-- ************************************** profits
CREATE OR REPLACE VIEW profits as
  select m.product_id, sum(ifnull(s.quantity, 0)) as quantity,
      sum(ifnull(quantity * (s.price - m.wholesale_price), 0)) as profit
    from wholesale_materialized_view as m left outer join sales as s on s.product_id = m.product_id
    group by m.product_id;
