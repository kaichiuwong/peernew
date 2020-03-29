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

    function get_unit_id($unit_code, $sem)
    {
        $rtnResult = 0;
        $query = $this->db->query("select id from unit where LOWER(unit_code)=LOWER('$unit_code') and sem='$sem' ; ");
        $row = $query->row_array();
        if (isset($row))
        {
            $rtnResult = intval($row['id']);
        }
        return $rtnResult;
    }

    function get_all_units()
    {
        $query = $this->db->query("SELECT id, unit_code, fn_sem_short_desc(sem) as sem, sem as sem_key, unit_description, `enable` FROM `unit` WHERE enable=1 ORDER BY unit_code, sem; ");
        return $query->result_array();
    }

    function get_all_units_with_disabled($username = '')
    {
        $query_str =  " SELECT u.id, u.unit_code, fn_sem_short_desc(u.sem) as sem, u.sem as sem_key, u.unit_description, u.enable, count(ue.id) as std_cnt ";
        $query_str .= "   FROM unit u ";
        $query_str .= "   LEFT JOIN unit_enrol ue on u.id = ue.unit_id and ue.enable = 1 ";
        if (!empty($username)) {
            $query_str .= "   WHERE u.id in (SELECT unit_id FROM unit_staff WHERE username = '$username' ) ";
        }
        $query_str .= "  GROUP BY u.id, u.unit_code, u.sem, u.unit_description, u.enable" ;
        $query = $this->db->query($query_str);
        return $query->result_array();
    }

    function add_unit($params)
    {
        $params['create_time'] = current_time();
        $params['last_upd_time'] = current_time();
        $this->db->insert('unit',$params);
        return $this->db->insert_id();
    }

    function update_unit($id,$params)
    {
        $params['last_upd_time'] = current_time();
        $this->db->where('id',$id);
        return $this->db->update('unit',$params);
    }

    function enable_switch($unit_id) {
        $query_str  = "UPDATE `unit` " ;
        $query_str .= "   SET enable = CASE WHEN enable = 0 THEN 1 ";
        $query_str .= "                     WHEN enable = 1 THEN 0 END, last_upd_time = now() " ;
        $query_str .= " WHERE enable in (0,1) AND id='$unit_id' "; 
        $query = $this->db->query($query_str);
        return $this->db->affected_rows();
    }

    function delete_unit($id)
    {
        $this->db->delete('unit_group_allocation',array('unit_id'=>$id));
        $this->db->delete('unit_group',array('unit_id'=>$id));
        $this->db->delete('unit_enrol',array('unit_id'=>$id));
        $this->db->delete('unit_staff',array('unit_id'=>$id));
        $this->db->delete('unit',array('id'=>$id));
        return true;
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
            $query = $this->db->query("SELECT * FROM `sv_unit_student` where username='$username' ORDER BY unit_code; ");
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
