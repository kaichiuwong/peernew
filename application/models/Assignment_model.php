<?php

class Assignment_model extends CI_Model
{
    function __construct()
    {
        parent::__construct();
    }

    function get_assignment($id)
    {
        return $this->db->get_where('sv_assignment_staff',array('asg_id'=>$id))->row_array();
    }

    function get_all_assignments_count()
    {
        $this->db->from('sv_assignment_staff');
        return $this->db->count_all_results();
    }

    function get_all_assignments($username = null)
    {
        $query_str = "select distinct s.asg_id, s.title, s.type, s.public, s.feedback, s.topic_count, s.student_count,s.outcome, s.scenario, s.unit_id, s.unit_code, s.unit_description, s.sem, s.sem_key ";
        $query_str .= " from sv_assignment_staff s  ";
        if ($username) 
        {
            $query_str .= " where username = '$username' ";
        }
        $query_str .= " order by sem desc, s.asg_id; ";
        $query = $this->db->query($query_str );
        return $query->result_array();
    }

    function get_all_assignments_by_unit($unit_code, $sem = null)
    {
        $query_str = "select distinct s.asg_id, s.title, s.type, s.public, s.feedback, s.topic_count, s.student_count,s.outcome, s.scenario, s.unit_id, s.unit_code, s.unit_description, s.sem, s.sem_key ";
        $query_str .= " from sv_assignment_staff s  ";
        $query_str .= " where unit_code = '$unit_code' ";
        if ($sem) {
            $query_str .= " and sem_key = '$sem' ";
        }
        $query_str .= " order by sem desc, s.asg_id; ";
        $query = $this->db->query($query_str );
        return $query->result_array();
    }
    
    function get_all_assignments_student($username, $sem)
    {
        $this->db->order_by('asg_id', 'desc');
        $this->db->where('public',1);
        if(isset($username) && !empty($username))
        {
            $this->db->where('username',$username);
            $this->db->where('sem_key',$sem);
            return $this->db->get('sv_assignment_student')->result_array();
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

    function is_feedback_release($asg_id) 
    {
        $rtnResult = false;
        $query = $this->db->query("select feedback from assignment where id=$asg_id ; ");
        $row = $query->row_array();
        if (isset($row))
        {
            if (intval($row['feedback']) > 0) {
                $rtnResult = true;
            }
        }
        return $rtnResult;
    }

    function delete_assignment($id)
    {
        $this->db->delete('assignment_peer_mark',array('asg_id'=>$id));
        $this->db->delete('assignment_group_mark',array('asg_id'=>$id));
        $this->db->delete('assignment_date',array('asg_id'=>$id));
        $this->db->delete('assignment_feedback',array('asg_id'=>$id));
        $this->db->delete('submission',array('asg_id'=>$id));
        $this->db->delete('assignment_mark_criteria',array('asg_id'=>$id));
        $this->db->delete('assignment_question',array('asg_id'=>$id));
        $this->db->delete('assignment_topic_allocation',array('asg_id'=>$id));
        $this->db->delete('assignment_default_feedback',array('asg_id'=>$id));
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

    function batch_release_asg() 
    {
        $query_str  = " call sp_release_asg(); "; 
        $query = $this->db->query($query_str);
        return $this->db->affected_rows();
    }

    function batch_close_asg() 
    {
        $query_str  = " call sp_close_asg(); "; 
        $query = $this->db->query($query_str);
        return $this->db->affected_rows();
    }

    function feedback_switch($asg_id) {
        $query_str  = "UPDATE `assignment` " ;
        $query_str .= "   SET feedback = CASE WHEN feedback = 0 THEN 1 ";
        $query_str .= "                       WHEN feedback = 1 THEN 0 END " ;
        $query_str .= " WHERE feedback in (0,1) AND id='$asg_id' "; 
        $query = $this->db->query($query_str);
        return $this->db->affected_rows();
    }

    function student_summary($username) {
        $params = array("username"=> $username);    
        $query = $this->db->query("CALL `sp_get_question_feedback`(?) ; " , $params);
        $result = $query->result_array();
        mysqli_next_result( $this->db->conn_id );
        $query->free_result(); 
        return $result;
    }
}
