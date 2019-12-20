<?php

class Assignment_model extends CI_Model
{
    function __construct()
    {
        parent::__construct();
    }

    function get_assignment($id)
    {
        return $this->db->get_where('sv_assignment_staff',array('id'=>$id))->row_array();
    }

    function get_all_assignments_count()
    {
        $this->db->from('sv_assignment_staff');
        return $this->db->count_all_results();
    }

    function get_all_assignments()
    {
        $this->db->order_by('id', 'desc');
        return $this->db->get('sv_assignment_staff')->result_array();
    }
    
    function get_all_assignments_student($username, $sem)
    {
        $this->db->order_by('id', 'desc');
        if(isset($username) && !empty($username))
        {
            $this->db->where('username',$username);
            $this->db->where('sem',$sem);
            return $this->db->get('sv_assignemnt_student')->result_array();
        }
        return array();
    }

    function add_assignment($params)
    {
        $params['create_time'] = current_time();
        $params['last_upd_time'] = current_time();
        $this->db->insert('assignment',$params);
        return $this->db->insert_id();
    }

    function update_assignment($id,$params)
    {
        $params['last_upd_time'] = current_time();
        $this->db->where('id',$id);
        return $this->db->update('assignment',$params);
    }
    
    function is_allow_view_assignment($username, $asg_id) 
    {
        $rtnResult = false;
        $query = $this->db->query("select fn_is_allow_view_assignment('$username', $asg_id) as result ; ");
        $row = $query->row_array();
        if (isset($row))
        {
            if (intval($row['result']) > 0) {
                $rtnResult = true;
            }
        }
        return $rtnResult;
    }

    function delete_assignment($id)
    {
        $this->db->delete('assignment_date',array('asg_id'=>$id));
        $this->db->delete('assignment_feedback',array('asg_id'=>$id));
        $this->db->delete('submission',array('asg_id'=>$id));
        $this->db->delete('assignment_mark_criteria',array('asg_id'=>$id));
        $this->db->delete('assignment_question',array('asg_id'=>$id));
        $this->db->delete('assignment_topic_allocation',array('asg_id'=>$id));
        $this->db->delete('assignment_topic',array('assign_id'=>$id));
        $this->db->delete('assignment',array('id'=>$id));
        return 0;
    }

    function public_switch($asg_id) {
        $query_str  = "UPDATE `assignment` " ;
        $query_str .= "   SET public = CASE WHEN public = 0 THEN 1 ";
        $query_str .= "                     WHEN public = 1 THEN 0 END " ;
        $query_str .= " WHERE public in (0,1) AND id='$asg_id' "; 
        $query = $this->db->query($query_str);
        return $this->db->affected_rows();
    }
}
