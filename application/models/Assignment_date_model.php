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
        $this->db->order_by('id', 'asc');
        return $this->db->get('assignment_date')->result_array();
    }

    function get_all_dates_by_asg_id($asg_id) 
    {
        $this->db->order_by('date_value asc, id asc');
        $this->db->where('asg_id',$asg_id);
        return $this->db->get('assignment_date')->result_array();
    }

    function get_date_by_asg_id_key($asg_id, $key) 
    {
        return $this->db->get_where('assignment_date',array('asg_id'=>$asg_id, 'key'=>$key))->row_array();
    }
    
    function add_assignment_date($params, $username)
    {
        $params['last_upd_by'] = $username;
        $params['create_time'] = current_time();
        $params['last_upd_time'] = current_time();
        $this->db->insert('assignment_date',$params);
        return $this->db->insert_id();
    }

    function add_default($asg_id,$username) 
    {
        $default_date_entry = array(
            'ASG_OPEN' => 'Assignment open to public date', 
            'ASG_CLOSE' => 'Assignment close from public date', 
            'GRP_OPEN' => 'Group Selection open date', 
            'GRP_CLOSE' => 'Group Selection close date', 
            'SUBMISSION_OPEN' => 'Assignment Submission Open Date', 
            'SUBMISSION_DEADLINE' => 'Assignment Submission Deadline', 
            'SUBMISSION_CLOSE' => 'Assignment Submission Close Date', 
            'SELF_REVIEW_OPEN' => 'Self review open date', 
            'SELF_REVIEW_CLOSE' => 'Self review close date', 
            'PEER_REVIEW_OPEN' => 'Peer review open date', 
            'PEER_REVIEW_CLOSE' => 'Peer review close date'
        );

        foreach ($default_date_entry as $key => $value) {
            $params = array (
                "asg_id" => $asg_id,
                "key" => $key,
                "description" => $value, 
                "date_value" => null
            );
            $this->add_assignment_date($params, $username);
        }

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
