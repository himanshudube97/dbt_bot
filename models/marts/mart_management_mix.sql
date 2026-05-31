-- Mart: public vs private vs madarsa ownership mix per district.
{{ config(materialized='table') }}

select
    state,
    district,
    count(*)                                                       as total_schools,
    count(*) filter (where management_group = 'Government')        as govt_schools,
    count(*) filter (where management_group = 'Private')           as private_schools,
    count(*) filter (where management_group = 'Madarsa')           as madarsa_schools,
    count(*) filter (where management_group = 'Other')            as other_schools,
    round(
        100.0 * count(*) filter (where management_group = 'Government')
        / nullif(count(*), 0)
    , 1)                                                           as pct_government
from {{ ref('int_schools_classified') }}
group by state, district
order by state, total_schools desc
