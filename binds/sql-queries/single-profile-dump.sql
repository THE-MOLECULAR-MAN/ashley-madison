SELECT md.dob,
    md.profile_caption, md.profile_weight, md.profile_height,
    am.nickname, am.zip, am.city, am.bc_mail_last_time, am.bc_chat_last_time,
    am.reply_mail_last_time, am.keywords, am.security_answer, 
    am.opento, am.opento_other, am.opento_abstract, 
    am.turnsmeon,
    am.turnsmeon_other,
    am.turnsmeon_abstract,
    am.lookingfor,
    am.lookingfor_other,
    am.lookingfor_abstract,
    am.updatedon,
    aam.createdon,
    aam.updatedon,
    aam.phone,
    aam.pref_opento,
    aam.pref_opento_other,
    aam.pref_opento_abstract,
    aam.pref_turnsmeon,
    aam.pref_turnsmeon_other,
    aam.pref_turnsmeon_abstract,
    aam.pref_lookingfor,
    aam.pref_lookingfor_other,
    aam.pref_lookingfor_abstract,
    aam.security_answer,
    ml.username,
    ml.password
FROM
    aminno_member_email as ame
JOIN member_details as md
    on md.pnum = ame.pnum
JOIN aminno_member as am
    on am.pnum = ame.pnum
JOIN am_am_member as aam
    on aam.id = ame.pnum
JOIN member_login as ml
    on ml.pnum = ame.pnum
WHERE 
    EMAIL = 'replaceme@contoso.com';
