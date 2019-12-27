<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Marking extends MY_PasController {
    function __construct()
    {
        parent::__construct();
        $this->load->model('Assignment_mark_model');
    } 

    function group($asg_id = null)
    {
        if ($this->check_permission(20) ) {
            if ($asg_id) {
                $this->load->model('Assignment_model');
                $data['asg_id'] = $asg_id;
                $data['assignment'] = $this->Assignment_model->get_assignment($asg_id);
                $new_session_data = array('asg_id' => $asg_id, 'asg_header' => $data['assignment']['unit_code'] . ' - ' . $data['assignment']['title']);
                $this->session->set_userdata($new_session_data);

                $this->load->model('Assignment_topic_model');
                $data['assignment_topics'] = $this->Assignment_topic_model->get_assignment_topic_by_asgid($asg_id);
                $data['_view'] = 'pages/assignment_marking/group_submission';
            }
            else {
                $this->load->model('Assignment_model');
                $data['assignments'] = $this->Assignment_model->get_all_assignments();
                $data['unit'] = null;
                $data['_view'] = 'pages/assignment_marking/group';
            }
            $this->load_header($data);
            $this->load->view('templates/main',$data);
            $this->load_footer($data);
        }
    } 

    function individual()
    {
        if ($this->check_permission(20) ) {

        }
    }

}
