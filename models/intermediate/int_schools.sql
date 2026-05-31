-- Intermediate: both states stacked into one clean school directory.
-- Grain: one row per school across Bihar + Maharashtra.

select * from {{ ref('stg_udise_schools__bihar') }}
union all
select * from {{ ref('stg_udise_schools__maharashtra') }}
