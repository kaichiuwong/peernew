<?php 
if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class User extends CI_Model {

    function getUserlist(){
        $query = $this->db->query("SELECT * FROM `user` ORDER BY username; ");
        return $query->result_array();
    }
  
    function getUserInfo($username) {
        $query = $this->db->query("SELECT * FROM `user` WHERE lower(`username`)=lower('$username') ;");  
        if($query->num_rows() > 0) {
            return $query->result();
        }
        else  {
            return null;
        }
    }

    function get_user_list_by_permission($level)
    {
        $query = $this->db->query("SELECT * FROM `user` where permission_level = ".$level." ORDER BY username; ");
        return $query->result_array();
    }
    
    function getUserInfoByEmail($email) {
        $query = $this->db->query("SELECT * FROM `user` WHERE lower(`email`)=lower('$email') ;");  
        if($query->num_rows() > 0) {
            return $query->result();
        }
        else  {
            return null;
        }
    }
    
    function getUserInfoByResetCode($reset_code) {
        $query = $this->db->query("SELECT * FROM `user` WHERE lower(`reset_token`)=lower('$reset_code') ;");  
        if($query->num_rows() > 0) {
            return $query->result();
        }
        else  {
            return null;
        }
    }
    
    function updateFailCnt($username, $fail_cnt) {
        $fail_cnt = $fail_cnt + 1 ;
        $locked = 0;
        if ($fail_cnt >= USER_ALLOW_FAIL_LOGIN) {
            $locked = 1;
        }
        $query = $this->db->query("UPDATE `user` SET locked=$locked,login_fail_cnt=$fail_cnt WHERE lower(`username`)=lower('$username') ;"); 
        return $this->db->affected_rows();
    }
    
    function updateSuccessLogin($username) {
        $query = $this->db->query("UPDATE `user` SET login_fail_cnt=0, last_login_time=now() WHERE lower(`username`)=lower('$username') ;"); 
        return $this->db->affected_rows();
    }
    
    function updateUserInfo($username, $newinfo=array()) {
        if (!empty($newinfo)) {
            $data = array(
                'last_name' => $newinfo['last_name'],
                'first_name' => $newinfo['first_name'],
                'id' => $newinfo['id'],
                'email' => $newinfo['email']
            );
            if (isset($newinfo['plevel'])) {
                $data['permission_level'] = $newinfo['plevel'];
            }
            $data['last_upd_time'] = current_time();

            $this->db->where('username', $username);
            $this->db->update('user', $data);
            
            if (!empty($newinfo['password'])) {
                resetpassword($newinfo['password'],null,$username);
            }
            return 1;
        }
        else {
            return 0;
        }
    }
    
    function createUser($newinfo=array()) {
        if (!empty($newinfo)) {
            $newsalt = '$1$'.bin2hex(openssl_random_pseudo_bytes(16));
            $data = array(
                'username' => $newinfo['username'],
                'last_name' => $newinfo['last_name'],
                'first_name' => $newinfo['first_name'],
                'id' => $newinfo['id'],
                'email' => $newinfo['email'],
                'permission_level' => $newinfo['plevel'],
                'salt' => $newsalt,
                'password' => crypt($newinfo['password'],$newsalt),
                'last_upd_time' => current_time(),
                'create_time' => current_time()
            );
            $this->db->insert('user', $data);
            return 1;
        }
        else {
            return 0;
        }
    }

    function generateResetCode($email) {
        $resetcode=bin2hex(openssl_random_pseudo_bytes(4));
        $query = $this->db->query("UPDATE `user` SET reset_token='$resetcode', reset_time=now() where email='$email'; "); 
        if ($this->db->affected_rows() == 1) {
            return $resetcode;
        }
        else {
            return "";
        }
    }
    
    function resetpassword($newpassword, $reset_code='', $username='') {
        $newsalt = '$1$'.bin2hex(openssl_random_pseudo_bytes(16));
        $passworddigest = crypt($newpassword,$newsalt);
        if (empty($reset_code)) {
            $query = $this->db->query("UPDATE `user` set password='$passworddigest', salt='$newsalt', reset_token=null, reset_time=null, last_upd_time = now() where lower(`username`)=lower('$username') ; "); 
        }
        else {
            $query = $this->db->query("UPDATE `user` set password='$passworddigest', salt='$newsalt', reset_token=null, reset_time=null, last_upd_time = now() where reset_token='$reset_code' ; "); 
        }
        return $this->db->affected_rows();
    }
    
    function lockuser($username) {
        $query_str  = "UPDATE `user` " ;
        $query_str .= "   SET locked = CASE WHEN locked = 0 THEN 1 ";
        $query_str .= "                     WHEN locked = 1 THEN 0 END " ;
        $query_str .= " WHERE locked in (0,1) AND username='$username' "; 
        $query = $this->db->query($query_str);
        return $this->db->affected_rows();
    }

}
