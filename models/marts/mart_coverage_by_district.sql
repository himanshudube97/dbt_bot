-- Mart: school coverage and rural/urban split per district.
{{ config(materialized='table') }}

select
    state,
    district,
    count(*)                                                       as total_schools,
    count(*) filter (where location_type = 'Rural')               as rural_schools,
    count(*) filter (where location_type = 'Urban')               as urban_schools,
    round(
        100.0 * count(*) filter (where location_type = 'Rural')
        / nullif(count(*), 0)
    , 1)                                                           as pct_rural
from {{ ref('int_schools_classified') }}
group by state, district
order by state, total_schools desc
