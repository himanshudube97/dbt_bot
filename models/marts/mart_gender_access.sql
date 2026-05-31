-- Mart: gender access. Co-ed vs girls-only vs boys-only schools per district.
-- Availability of girls-only schools can affect girls' enrolment in some areas.
{{ config(materialized='table') }}

select
    state,
    district,
    count(*)                                                       as total_schools,
    count(*) filter (where is_coed)                                as coed_schools,
    count(*) filter (where is_girls_only)                          as girls_only_schools,
    count(*) filter (where is_boys_only)                           as boys_only_schools,
    round(
        100.0 * count(*) filter (where is_girls_only)
        / nullif(count(*), 0)
    , 2)                                                           as pct_girls_only
from {{ ref('int_schools_classified') }}
group by state, district
order by state, pct_girls_only desc
