<?php

class Assignment_mark_model extends CI_Model
{
    function __construct()
    {
        parent::__construct();
    }

    function create_group_mark($user, $params) 
    {
        $params['last_upd_by'] = $user;
        $params['create_time'] = current_time();
        $params['last_upd_time'] = current_time();
        $this->db->insert('assignment_group_mark',$params);
        return $this->db->insert_id();
    }

    function update_group_mark($id,$user, $params)
    {
        $params['last_upd_by'] = $user;
        $params['last_upd_time'] = current_time();
        $this->db->where('id',$id);
        return $this->db->update('assignment_group_mark',$params);
    }

    function create_peer_mark($user, $params) 
    {
        $params['last_upd_by'] = $user;
        $params['create_time'] = current_time();
        $params['last_upd_time'] = current_time();
        $this->db->insert('assignment_peer_mark',$params);
        return $this->db->insert_id();
    }

    function update_peer_mark($id,$user, $params)
    {
        $params['last_upd_by'] = $user;
        $params['last_upd_time'] = current_time();
        $this->db->where('id',$id);
        return $this->db->update('assignment_peer_mark',$params);
    }
    
}
