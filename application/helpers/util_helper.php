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
    $key = hash(ID_HASH_METHOD, ID_SECERT_KEY);
    $iv = substr(hash(ID_HASH_METHOD, ID_SECERT_IV), 0, 16);
    return urlencode(base64_encode(openssl_encrypt($id, ID_ENCRYPT_METHOD, $key, 0, $iv)));
}

function decode_id($str)
{
    $key = hash(ID_HASH_METHOD, ID_SECERT_KEY);
    $iv = substr(hash(ID_HASH_METHOD, ID_SECERT_IV), 0, 16);
    return  openssl_decrypt(base64_decode($str), ID_ENCRYPT_METHOD, $key, 0, $iv);
}
