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

                $this->load->model('Submission_model');
                $data['assignment_topics'] = $this->Submission_model->get_group_submission($asg_id);
                $this->load->model('Assignment_date_model');
                $data['asg_deadline'] = $this->Assignment_date_model->get_date_by_asg_id_key($asg_id, 'SUBMISSION_DEADLINE');
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

    function save_group_submission()
    {
        header('Content-Type: application/json');
        $done = false;
        $http_code = 500;
        $score_id = null;
        if ($this->check_permission(20, false) ) {
            if (isset($_POST['asg_id']) && isset($_POST['topic_id']) ) {
                $this->load->model('Assignment_mark_model');
                $params = array(
                    'asg_id' => $this->input->post('asg_id'),
                    'group_id' => $this->input->post('topic_id'),
                    'score' => $this->input->post('score'),
                    'remark' => $this->input->post('remark')
                );
                if (isset($_POST['score_id'])) {
                    if ( !empty($_POST['score_id']) ) {
                        $score_id = $this->input->post('score_id');
                    }
                }
                $current_user = $this->get_login_user();
                if (!$score_id) 
                {
                    $score_id = $this->Assignment_mark_model->create_group_mark($current_user, $params);
                }
                else 
                {
                    $this->Assignment_mark_model->update_group_mark($score_id, $current_user, $params);
                }
                $done = true;
                $http_code = 200;
            }
        }

        return $this->output
            ->set_content_type('application/json')
            ->set_status_header($http_code)
            ->set_output( json_encode( array('score_id' => $score_id, 'status' => $done) ) );
    }

}
