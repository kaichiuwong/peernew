<?php
 
class Assignment_topic_model extends CI_Model
{
    function __construct()
    {
        parent::__construct();
    }

    function get_assignment_topic($id)
    {
        $this->db->order_by('topic', 'asc');
        return $this->db->get_where('assignment_topic',array('id'=>$id))->row_array();
    }

    function get_assignment_topic_by_asgid($asg_id)
    {
        $query = $this->db->query("select t.*,s.cnt from assignment_topic t, sv_topic_stat s where t.id=s.id and t.assign_id=$asg_id order by t.topic; ");
        return $query->result_array();
    }
    
    function get_assignment_topic_by_student($asg_id, $username) 
    {
        return $this->db->get_where('assignment_topic_allocation',array('asg_id'=>$asg_id, 'user_id'=>$username))->row_array();
    }

    function get_all_assignment_topics()
    {
        $this->db->order_by('topic', 'asc');
        return $this->db->get('assignment_topic')->result_array();
    }
    
    function bulk_add_assignment_topic($asg_id, $num = 0, $max = 0, $prefix = '') 
    {
        for ($x = 1; $x <= $num; $x++) {
            $grp_name = 'Group ' . str_pad($x, 3, '0', STR_PAD_LEFT);
            if ($prefix) $grp_name = $prefix . '_' .  str_pad($x, 3, '0', STR_PAD_LEFT); 
            $params = array(
                'assign_id' => $asg_id,
                'topic' => $grp_name,
                'max' => $max,
                'topic_desc' => $grp_name
            );
            $this->add_assignment_topic($params);
        }
    }

    function add_assignment_topic($params)
    {
        $params['create_time'] = current_time();
        $params['last_upd_time'] = current_time();
        $this->db->insert('assignment_topic',$params);
        return $this->db->insert_id();
    }

    function update_assignment_topic($id,$params)
    {
        $params['last_upd_time'] = current_time();
        $this->db->where('id',$id);
        return $this->db->update('assignment_topic',$params);
    }

    function delete_assignment_topic($id)
    {
        return $this->db->delete('assignment_topic',array('id'=>$id));
    }
    
    function get_assignment_member($id) 
    {
        $query = $this->db->query("select * from sv_assignment_topic_member where topic_id='$id' order by user_id; ");
        return $query->result_array();
    }
    
    function join_topic($asg_id, $username, $topic_id) 
    {
        $join_before = $this->get_assignment_topic_by_student($asg_id, $username);
        if(isset($join_before['topic_id'])) { $this->leave_topic($asg_id, $username, $topic_id) ; }
        
        $params = array( 
            "asg_id" => $asg_id,
            "user_id" => $username,
            "topic_id" => $topic_id,
            "create_time" => current_time(),
            "last_upd_time" => current_time()
            );
        $this->db->insert('assignment_topic_allocation',$params);
        return $this->db->insert_id();
    }
    
    function leave_topic($asg_id, $username, $topic_id) 
    {
        return $this->db->delete('assignment_topic_allocation',array( 
                                    "asg_id" => $asg_id,
                                    "user_id" => $username,
                                    "topic_id" => $topic_id
                                )
               );
    }
}
