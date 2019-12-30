<?php
class Unit_enrol_model extends CI_Model
{
    function __construct()
    {
        parent::__construct();
    }

    function get_unit_enrol($id)
    {
        return $this->db->get_where('unit_enrol',array('id'=>$id))->row_array();
    }

    function get_unit_enrol_by_asgid($asg_id)
    {
        $query_str  = " select s.*, ata.id as ata_id, ata.topic_id ";
        $query_str .= " from sv_assignment_student s ";
        $query_str .= " left join assignment_topic_allocation ata  ";
        $query_str .= " on s.username = ata.user_id and s.asg_id = ata.asg_id ";
        $query_str .= " where s.asg_id=$asg_id order by username; ";
        $query = $this->db->query($query_str);
        return $query->result_array();
    }

    function get_all_unit_enrols()
    {
        $query = $this->db->query("select * from sv_assignment_student order by id; ");
        return $query->result_array();
    }

    function add_unit_enrol($params)
    {
        $this->db->insert('unit_enrol',$params);
        return $this->db->insert_id();
    }

    function assignment_topic_allocation($ata_id, $asg_id, $user_id, $topic_id)
    {
        $query = "INSERT INTO assignment_topic_allocation (asg_id, user_id, topic_id, create_time,last_upd_time) ";
        $query .= "VALUES ($asg_id, '$user_id', $topic_id, now(), now()) ";
        if ($ata_id) {
            $query = "UPDATE assignment_topic_allocation set topic_id=$topic_id, last_upd_time=now() WHERE id=$ata_id; ";
        }
        return $this->db->query($query);
    }

    function delete_unit_enrol($id)
    {
        return $this->db->delete('unit_enrol',array('id'=>$id));
    }
}
