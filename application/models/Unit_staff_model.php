<?php
 
class Unit_staff_model extends CI_Model
{
    function __construct()
    {
        parent::__construct();
    }

    function get_unit_staff($id)
    {
        return $this->db->get_where('unit_staff',array('id'=>$id))->row_array();
    }

    function get_all_unit_staffs_count()
    {
        $this->db->from('unit_staff');
        return $this->db->count_all_results();
    }

    function get_all_unit_staffs($params = array())
    {
        $this->db->order_by('id', 'desc');
        return $this->db->get('unit_staff')->result_array();
    }

    function add_unit_staff($user,$params)
    {
        $params['last_upd_by']=$user;
        $params['create_time']=current_time();
        $params['last_upd_time']=current_time();
        $this->db->insert('unit_staff',$params);
        return $this->db->insert_id();
    }

    function update_unit_staff($id,$user,$params)
    {
        $params['last_upd_by']=$user;
        $params['last_upd_time']=current_time();
        $this->db->where('id',$id);
        return $this->db->update('unit_staff',$params);
    }

    function delete_unit_staff($params)
    {
        return $this->db->delete('unit_staff',$params);
    }

    function delete_unit_staff_by_unit($unit_id)
    {
        $this->db->where('unit_id',$unit_id);
        return $this->db->delete('unit_staff');
    }

    function get_unit_staff_by_asg($asg_id)
    {
        $query_str  = " select s.* ";
        $query_str .= " from sv_assignment_staff s ";
        $query_str .= " where s.asg_id=$asg_id order by username; ";
        $query = $this->db->query($query_str);
        return $query->result_array();
    }

    function get_unit_staff_by_unit($unit_id)
    {
        $query_str  = " select s.*, u.last_name, u.first_name ";
        $query_str .= " from unit_staff s, user u ";
        $query_str .= " where s.unit_id=$unit_id AND s.username = u.username order by s.username; ";
        $query = $this->db->query($query_str);
        return $query->result_array();
    }

    function get_unit_staff_by_staff($unit_id, $username)
    {
        $query_str  = " select s.*, u.last_name, u.first_name ";
        $query_str .= " from unit_staff s, user u ";
        $query_str .= " where s.unit_id=$unit_id AND s.username = '$username' AND s.username = u.username order by s.username; ";
        $query = $this->db->query($query_str);
        return $query->result_array();
    }
}
