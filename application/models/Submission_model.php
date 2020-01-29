<?php
 
class Submission_model extends CI_Model
{
    function __construct()
    {
        parent::__construct();
    }

    function get_submission_by_group($asg_id, $topic_id)
    {
        return $this->db->get_where('submission',array('asg_id' =>$asg_id, 'topic_id'=>$topic_id))->row_array();
    }
    
    function get_submission_by_student($asg_id, $user_id)
    {
        return $this->db->get_where('submission',array('asg_id' =>$asg_id, 'user_id'=>$user_id))->row_array();
    }
    
    function get_submission_by_asg($asg_id) 
    {
        return $this->db->get_where('submission',array('asg_id' =>$asg_id))->result_array();
    }
    
    function get_submission_history_by_group($asg_id, $topic_id) 
    {
        $this->db->from('submission_log');
        $this->db->where('asg_id', $asg_id);
        $this->db->where('topic_id', $topic_id);
        $this->db->where('action', 'ADD');
        $this->db->order_by("submission_date", "desc");
        $query = $this->db->get(); 
        return $query->result();
    }
    
    function get_submission_history_by_user($asg_id, $user_id) 
    {
        $this->db->from('submission_log');
        $this->db->where('asg_id', $asg_id);
        $this->db->where('user_id', $user_id);
        $this->db->where('action', 'ADD');
        $this->db->order_by("submission_date", "desc");
        $query = $this->db->get(); 
        return $query->result();
    }
    
    function submit_assignment($asg_id, $topic_id, $user_id, $filename)
    {
        $params = array('asg_id'=>$asg_id, 
                        'topic_id'=>$topic_id,
                        'user_id'=>$user_id,
                        'filename'=>$filename,
                        'submission_date'=>current_time()
                        );
        $this->db->insert('submission',$params);
        return $this->db->insert_id();
    }

    
    function delete_submission_by_group($asg_id, $topic_id)
    {
        $this->db->delete('submission',array('asg_id'=>$asg_id, 'topic_id'=>$topic_id));
    }
    
    function delete_submission_by_individual($asg_id, $user_id)
    {
        $this->db->delete('submission',array('asg_id'=>$asg_id, 'user_id'=>$user_id));
    }

    function get_group_submission($asg_id, $topic_id = null)
    {
        $query_str  = " select s.* ";
        $query_str .= " from sv_group_submission s ";
        $query_str .= " where s.asg_id=$asg_id ";
        if ($topic_id) {
            $query_str .= " and s.topic_id='$topic_id' " ;
        }
        $query_str .= " order by s.topic_id; ";
        $query = $this->db->query($query_str);
        return $query->result_array();
    }

    function get_peer_review_summary($asg_id, $username = null)
    {
        $query_str  = " select s.* ";
        $query_str .= " from sv_assignment_peer_summary s ";
        $query_str .= " where s.asg_id=$asg_id ";
        if ($username) {
            $query_str .= " and s.username='$username' " ;
        }
        $query_str .= " order by s.sid; ";
        $query = $this->db->query($query_str);
        return $query->result_array();
    }

    function get_final_score($asg_id, $username = null)
    {
        $query_str  = " select s.sid, s.username, s.last_name, s.first_name, s.unit_code, s.sem, s.asg_title, s.topic_id, s.topic, ifnull(s.group_score,0) as group_score, IFNULL(s.override_score, s.peer_average) as peer_score, IFNULL(s.group_score,0)+IFNULL(s.override_score, s.peer_average) as total_score ";
        $query_str .= " from sv_assignment_peer_summary s ";
        $query_str .= " where s.asg_id=$asg_id ";
        if ($username) {
            $query_str .= " and s.username='$username' " ;
        }
        $query_str .= " order by s.sid; ";
        $query = $this->db->query($query_str);
        return $query->result_array();
    }
}
