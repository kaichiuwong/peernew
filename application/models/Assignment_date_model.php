<?php

class Assignment_date_model extends CI_Model
{
    function __construct()
    {
        parent::__construct();
    }
    
    function get_assignment_date($id)
    {
        return $this->db->get_where('assignment_date',array('id'=>$id))->row_array();
    }

    function get_all_assignment_dates_count()
    {
        $this->db->from('assignment_date');
        return $this->db->count_all_results();
    }

    function get_all_assignment_dates()
    {
        $this->db->order_by('id', 'desc');
        return $this->db->get('assignment_date')->result_array();
    }

    function get_all_dates_by_asg_id($asg_id) 
    {
        $this->db->order_by('id', 'desc');
        $this->db->where('asg_id',$asg_id);
        return $this->db->get('assignment_date')->result_array();
    }

    function get_all_dates_by_asg_id_key($asg_id, $key) 
    {
        $this->db->order_by('id', 'desc');
        $this->db->where('asg_id',$asg_id);
        $this->db->where('key',$key);
        return $this->db->get('assignment_date')->result_array();
    }
    
    function add_assignment_date($params, $username)
    {
        $params['last_upd_by'] = $username;
        $params['create_time'] = current_time();
        $params['last_upd_time'] = current_time();
        $this->db->insert('assignment_date',$params);
        return $this->db->insert_id();
    }

    function update_assignment_date($id,$params,$username)
    {
        $params['last_upd_by'] = $username;
        $params['last_upd_time'] = current_time();
        $this->db->where('id',$id);
        return $this->db->update('assignment_date',$params);
    }

    function delete_assignment_date($id)
    {
        return $this->db->delete('assignment_date',array('id'=>$id));
    }
}
