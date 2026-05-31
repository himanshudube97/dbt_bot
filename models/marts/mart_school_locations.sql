-- Mart: per-school geo points for the map layer. Clean coordinates only.
{{ config(materialized='table') }}

select
    school_id,
    school_name,
    state,
    district,
    location_type,
    school_category,
    management,
    management_group,
    level_band,
    latitude,
    longitude
from {{ ref('int_schools_classified') }}
where latitude is not null
  and longitude is not null
