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
        $params['create_time'] = current_time();
        $params['last_upd_time'] = current_time();
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

    function refresh_enrol_from_db()
    {
        $cnt = 0;
        $remote_db = $this->load->database('remote_school_db', TRUE);
        $remotesql = "
        SELECT DISTINCT su.student_id,s.first_name, s.last_name, s.account_name,LEFT(su.enrolled_unit_code,6) enrolled_unit_code,su.campus,u.semester,su.withdrawn
          FROM student_unit su,units u, student s
         WHERE su.student_id=s.student_id
           AND su.unit_id = u.unit_id
           AND su.withdrawn = 'NULL'
         ORDER BY su.student_id;
        ";
        $remote_query = $remote_db->query($remotesql);
        $remote_result = $remote_query->result_array();

        $truncatesql = "truncate unit_enrol; ";
        $this->db->query($truncatesql);

        $this->load->model('User');
        $this->load->model('Unit_model');
        foreach($remote_result as $enrol_record){
            $sid = $enrol_record['student_id'];
            $firstname = $enrol_record['first_name'];
            $lastname = $enrol_record['last_name'];
            $username = $enrol_record['account_name'];
            $unit_code = $enrol_record['enrolled_unit_code'];
            $campus = $enrol_record['campus'];
            $sem = date('Y').'0'.$enrol_record['semester'] ;
            $unit_id = $this->Unit_model->get_unit_id($unit_code, $sem);
            $email=$username . '@postoffice.utas.edu.au';
            if (!$this->User->getUserInfo($username)) {
                $userinfo = array(
                    'username' => $username,
                    'first_name' => $firstname,
                    'last_name' => $lastname,
                    'id' => $sid,
                    'email' => $email,
                    'plevel' => 10,
                    'password' => $sid.$username
                );
                $this->User->createUser($userinfo);
            }
            if ($unit_id > 0) 
            {
                $enrol_info = array(
                    'user_id' => $username,
                    'unit_id' => $unit_id
                );
                $this->add_unit_enrol($enrol_info);
                $cnt++;
            }
        }
    }
}
