-- selected columns for a specific profile
SELECT 
    am.pnum,
    aam.profile_number,
    ame.email,
    aam.first_name,
    aam.last_name,
    am.nickname,
    am.gender,
    am.dob,
    am.keywords,
    am.caption,
    aam.pref_turnsmeon_other,
    aam.pref_turnsmeon_abstract,
    aam.pref_lookingfor_other,
    aam.pref_lookingfor_abstract,
    aam.pref_opento_other,
    aam.pref_opento_abstract,
    am.ethnicity,
    am.weight,
    am.height,
    am.photos_public,
    am.photos_private,
    aam.phone,
    aam.work_phone,
    aam.mobile_phone,
    am.zip,
    am.latitude,
    am.longitude,
    am.city
FROM
    aminno_member as am
JOIN am_am_member as aam
    on aam.id = am.pnum
JOIN aminno_member_email as ame
    on ame.pnum = am.pnum

WHERE ame.pnum = 123456 \G
