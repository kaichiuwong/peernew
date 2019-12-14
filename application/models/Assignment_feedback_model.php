<?php

class Assignment_feedback_model extends CI_Model
{
    function __construct()
    {
        parent::__construct();
    }

    function get_assignment_feedback($id)
    {
        return $this->db->get_where('assignment_feedback',array('id'=>$id))->row_array();
    }
    
    function get_assignment_feedback_by_asgid($asg_id)
    {
        $query = $this->db->query("select t.* from assignment_feedback t where t.asg_id=$asg_id ; ");
        return $query->result_array();
    }
    
    function get_assignment_feedback_by_reviewer($asg_id, $reviewer)
    {
        $query = $this->db->query("select t.* from assignment_feedback t where t.asg_id=$asg_id and t.reviewer='$reviewer' ; ");
        return $query->result_array();
    }

    function get_assignment_feedback_by_reviewee($asg_id, $reviewee)
    {
        $query = $this->db->query("select t.* from assignment_feedback t where t.asg_id=$asg_id and t.reviewer='$reviewee' ; ");
        return $query->result_array();
    }

    function get_assignment_feedback_by_question_id($asg_id, $question_id)
    {
        $query = $this->db->query("select t.* from assignment_feedback t where t.asg_id=$asg_id and t.question_id=$question_id ; ");
        return $query->result_array();
    }

    function get_all_assignment_feedbacks()
    {
        return $this->db->get('assignment_feedback')->result_array();
    }
        
    function add_assignment_feedback($params)
    {
        $params['create_time'] = current_time();
        $params['last_upd_time'] = current_time();
        $this->db->insert('assignment_feedback',$params);
        return $this->db->insert_id();
    }

    function update_assignment_feedback($id,$params)
    {
        $params['last_upd_time'] = current_time();
        $this->db->where('id',$id);
        return $this->db->update('assignment_feedback',$params);
    }

    function delete_assignment_feedback($id)
    {
        return $this->db->delete('assignment_feedback',array('id'=>$id));
    }

    function delete_assignment_feedback_all($asg_id, $type)
    {
        return $this->db->delete('assignment_feedback',array('asg_id'=>$asg_id, 'question_section'=>$type));
    }

}
