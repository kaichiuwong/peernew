<?php

function character_limiter($str, $n = 500, $end_char = '&#8230;'){
    if (strlen($str) < $n)
    {
        return $str;
    }

    $str = preg_replace("/\s+/", ' ', str_replace(array("\r\n", "\r", "\n"), ' ', $str));

    if (strlen($str) <= $n)
    {
        return $str;
    }

    $out = "";
    foreach (explode(' ', trim($str)) as $val)
    {
        $out .= $val.' ';

        if (strlen($out) >= $n)
        {
            $out = trim($out);
            return (strlen($out) == strlen($str)) ? $out : $out.$end_char;
        }
    }
}

function get_permission_level_desc($level) 
{
    $result = "Limited User";
    switch(true) {
        case $level >= 90:
            $result = "Administrator";
            break;
        case $level >= 50:
            $result = "Unit Coordinator";
            break;
        case $level >= 30:
            $result = "Lecturer";
            break;
        case $level >= 20:
            $result = "Tutor";
            break;
        case $level >= 10:
            $result = "Student";
            break;
        default: 
            $result = "Limited User";
            break;
    }
    return $result;
}


function current_time() {
    return mdate("%Y-%m-%d %H:%i:%s",now());
}

function encode_id($id)
{
    return urlencode(base64_encode(HASH_SALT.$id));
}

function decode_id($str)
{
    $decoded_id = base64_decode(urldecode($str));
    return str_replace(HASH_SALT,"",$decoded_id);
}