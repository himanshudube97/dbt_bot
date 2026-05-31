-- Mart: the older-child access gap. How many secondary-and-above schools exist
-- per district relative to primary schools. A low ratio means children must
-- leave their area (or drop out) to continue past primary.
{{ config(materialized='table') }}

select
    state,
    district,
    count(*)                                                       as total_schools,
    count(*) filter (where is_primary_only)                        as primary_schools,
    count(*) filter (where is_secondary_plus)                      as secondary_plus_schools,
    round(
        100.0 * count(*) filter (where is_secondary_plus)
        / nullif(count(*) filter (where is_primary_only), 0)
    , 1)                                                           as secondary_per_100_primary
from {{ ref('int_schools_classified') }}
group by state, district
order by state, secondary_per_100_primary asc nulls last
