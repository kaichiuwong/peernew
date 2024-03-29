<?php

 
class Assignment_question_model extends CI_Model
{
    function __construct()
    {
        parent::__construct();
    }

    function get_assignment_question($id)
    {
        return $this->db->get_where('assignment_question',array('id'=>$id))->row_array();
    }

    function get_assignment_question_by_asgid($asg_id)
    {
        $query = $this->db->query("select t.* from assignment_question t where t.asg_id=$asg_id order by t.question_order asc; ");
        return $query->result_array();
    }

    function get_assignment_question_by_asgid_section($asg_id, $section)
    {
        $query = $this->db->query("select t.* from assignment_question t where t.asg_id=$asg_id and t.question_section='$section' order by t.question_order asc ; ");
        return $query->result_array();
    }

    function get_all_assignment_questions()
    {
        $this->db->order_by('topic', 'asc');
        return $this->db->get('assignment_question')->result_array();
    }

    function add_assignment_question($params)
    {
        $params['create_time'] = current_time();
        $params['last_upd_time'] = current_time();
        $this->db->insert('assignment_question',$params);
        return $this->db->insert_id();
    }

    function update_assignment_question($id,$params)
    {
        $params['last_upd_time'] = current_time();
        $this->db->where('id',$id);
        return $this->db->update('assignment_question',$params);
    }

    function delete_assignment_question($id)
    {
        return $this->db->delete('assignment_question',array('id'=>$id));
    }

    function delete_assignment_question_all($asg_id, $type)
    {
        return $this->db->delete('assignment_question',array('asg_id'=>$asg_id, 'question_section'=>$type));
    }
    
    function copy_questions($from_id, $to_id) 
    {
        $query =  " INSERT INTO assignment_question ";
        $query .= " SELECT null,$to_id, question_order, question,answer_type,question_section,NOW(),NOW() FROM assignment_question ";
        $query .= " WHERE asg_id=$from_id; ";
        return $this->db->query($query);
    }
}
