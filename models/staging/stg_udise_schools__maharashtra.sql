-- Staging: Maharashtra UDISE schools. 1 row per school. Cleans the raw varchar
-- extract into a typed, readable contract. Cleaning only; no business logic.

with source as (
    select * from {{ source('udise', 'udise_schools_maharashtra') }}
)

select
    schcd                                              as school_id,
    nullif(trim(schname), '')                          as school_name,
    'Maharashtra'                                       as state,
    initcap(trim(dtname))                              as district,
    nullif(initcap(trim(sdtname)), '')                 as sub_district,
    initcap(trim(vilname))                             as village,
    nullif(trim(pincode), '')                          as pincode,
    case rururb
        when '1' then 'Rural'
        when '2' then 'Urban'
    end                                                as location_type,
    nullif(trim(school_cat), '')                       as school_category,
    nullif(trim(management), '')                       as management,
    nullif(trim(school_typ), '')                       as school_type,
    nullif(lat, '')::numeric                           as latitude,
    nullif(lon, '')::numeric                           as longitude
from source
where schcd is not null
  and nullif(lat, '')::numeric between 6 and 38
  and nullif(lon, '')::numeric between 68 and 98
