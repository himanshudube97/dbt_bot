-- Intermediate: adds the analytical classifications that the marts roll up.
-- Management buckets, education-level band, and gender-access flags.

with schools as (
    select * from {{ ref('int_schools') }}
)

select
    school_id,
    school_name,
    state,
    district,
    sub_district,
    village,
    pincode,
    location_type,
    school_category,
    management,
    school_type,
    latitude,
    longitude,

    -- Management ownership buckets
    case
        when management in (
            'Department of Education',
            'Local body',
            'Government Aided',
            'Tribal Welfare Department',
            'Social welfare Department',
            'Kendriya Vidyalaya',
            'Jawahar Navodaya Vidyalaya',
            'Railway School',
            'Sainik School',
            'Others Central Government School'
        ) then 'Government'
        when management = 'Private Unaided (Recognized)' then 'Private'
        when management ilike 'Madarsa%' then 'Madarsa'
        else 'Other'
    end                                                as management_group,

    -- Education level band (lowest grade band the school offers up to)
    case
        when school_category ilike '%Secondary%'
          or school_category ilike '%H.Sec%'
          or school_category ilike '%Jr. College%' then 'Secondary & above'
        when school_category ilike '%Upper%'       then 'Upper primary'
        else 'Primary only'
    end                                                as level_band,

    -- Convenience boolean flags for mart aggregations
    (school_category ilike '%Secondary%'
     or school_category ilike '%H.Sec%'
     or school_category ilike '%Jr. College%')        as is_secondary_plus,
    (school_category = 'Primary')                      as is_primary_only,
    (school_type = 'Girls Only')                       as is_girls_only,
    (school_type = 'Boys Only')                        as is_boys_only,
    (school_type = 'Co. Educational')                  as is_coed
from schools
