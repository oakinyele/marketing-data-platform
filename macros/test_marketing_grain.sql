{% test marketing_grain(model) %}

select
    platform,
    ad_id,
    ad_date,
    case
        when platform = 'snapchat' then country
        else null
    end as grain_country,
    count(*) as row_count
from {{ model }}
group by
    platform,
    ad_id,
    ad_date,
    case
        when platform = 'snapchat' then country
        else null
    end
having count(*) > 1

{% endtest %}
