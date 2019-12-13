<?php
 
class Unit_model extends CI_Model
{
    function __construct()
    {
        parent::__construct();
    }

    function get_unit($id)
    {
        return $this->db->get_where('unit',array('id'=>$id))->row_array();
    }

    function get_all_units()
    {
        $this->db->order_by('unit_code', 'asc');
        return $this->db->get('unit')->result_array();
    }

    function add_unit($params)
    {
        $this->db->insert('unit',$params);
        return $this->db->insert_id();
    }

    function update_unit($id,$params)
    {
        $this->db->where('id',$id);
        return $this->db->update('unit',$params);
    }

    function delete_unit($id)
    {
        return $this->db->delete('unit',array('id'=>$id));
    }
    
    function get_list(){
        $query = $this->db->query("SELECT * FROM `unit` ORDER BY unit_code; ");
        return $query->result_array();
    }

    function get_list_by_staff($username = null) {
        if ($username) {
            $query = $this->db->query("SELECT * FROM `sv_unit_staff` where username='$username' ORDER BY unit_code; ");
        }
        else {
            $query = $this->db->query("SELECT * FROM `sv_unit_staff` ORDER BY unit_code; ");
        }
        return $query->result_array();
    }

    function get_list_by_student($username = null) {
        if ($username) {
            $query = $this->db->query("SELECT * FROM `sv_unit_student` where username='$username' ORDER BY username, unit_code; ");
        }
        else {
            $query = $this->db->query("SELECT * FROM `sv_unit_student` ORDER BY unit_code; ");
        }
        return $query->result_array();
    }

    function get_unit_info($id) {
        $result = array();
        if ($id) {
            $query = $this->db->query("SELECT * FROM `unit` where id=$id ; ");
            if($query->num_rows() > 0) {
                $result = $query->result();
            }
        }
        return $result;
    }
}
