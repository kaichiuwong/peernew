<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Marking extends MY_PasController {
    function __construct()
    {
        parent::__construct();
        $this->load->model('Assignment_mark_model');
    } 

    function index() 
    {
        if ($this->check_permission(20) ) {
            $this->load->model('Assignment_model');
            if ($this->check_permission(90, false)) 
            {
                $data['assignments'] = $this->Assignment_model->get_all_assignments();
            }
            else 
            {
                $data['assignments'] = $this->Assignment_model->get_all_assignments($this->get_login_user());
            }
            $data['unit'] = null;
            $data['_view'] = 'pages/assignment_marking/index';
            $this->load_header($data);
            $this->load->view('templates/main',$data);
            $this->load_footer($data);
        }
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
                $this->load_header($data);
                $this->load->view('templates/main',$data);
                $this->load_footer($data);
            }
            else {
                redirect('Marking');
            }
        }
    } 

    function peer($asg_id = null)
    {
        if ($this->check_permission(20) ) {
            if ($asg_id) {
                $this->load->model('Assignment_model');
                $data['asg_id'] = $asg_id;
                $data['assignment'] = $this->Assignment_model->get_assignment($asg_id);
                $new_session_data = array('asg_id' => $asg_id, 'asg_header' => $data['assignment']['unit_code'] . ' - ' . $data['assignment']['title']);
                $this->session->set_userdata($new_session_data);

                $this->load->model('Submission_model');
                $data['students'] = $this->Submission_model->get_peer_review_summary($asg_id);
                $data['_view'] = 'pages/assignment_marking/peer_submission';
                $this->load_header($data);
                $this->load->view('templates/main',$data);
                $this->load_footer($data);
            }
            else
            {
                redirect('Marking');
            }
        }
    }

    function give_indiv_feedback($asg_id = null, $group_id = null, $username = null)
    {
        if ($this->check_permission(20, false) ) {
            if ($asg_id && $group_id && $username) {
                $data['asg_id'] = $asg_id;
                $data['group_id'] = $group_id;
                $data['username'] = $username;
                $this->load->model('Submission_model');
                $data['summary'] = $this->Submission_model->get_peer_review_summary($asg_id,$username);
                $data['_view'] = 'pages/assignment_marking/indiv_feedback';
                $this->load_header($data);
                $this->load->view('templates/main',$data);
                $this->load_footer($data);
            }
            else
            {
                redirect('Marking');
            }
        }
    }

    function give_group_feedback($asg_id = null, $group_id = null)
    {
        if ($this->check_permission(20, false) ) {
            if ($asg_id && $group_id) {
                $data['asg_id'] = $asg_id;
                $data['group_id'] = $group_id;
                $this->load->model('Submission_model');
                $data['summary'] = $this->Submission_model->get_group_submission($asg_id);
                $data['_view'] = 'pages/assignment_marking/group_feedback';
                $this->load_header($data);
                $this->load->view('templates/main',$data);
                $this->load_footer($data);
            }
            else
            {
                redirect('Marking');
            }
        }
    }

    function final_score($asg_id = null)
    {
        if ($this->check_permission(20) ) {
            if ($asg_id) {
                $this->load->model('Assignment_model');
                $data['asg_id'] = $asg_id;
                $data['assignment'] = $this->Assignment_model->get_assignment($asg_id);
                $new_session_data = array('asg_id' => $asg_id, 'asg_header' => $data['assignment']['unit_code'] . ' - ' . $data['assignment']['title']);
                $this->session->set_userdata($new_session_data);

                $this->load->model('Submission_model');
                $data['students'] = $this->Submission_model->get_final_score($asg_id);
                $data['_view'] = 'pages/assignment_marking/final_score';
                $this->load_header($data);
                $this->load->view('templates/main',$data);
                $this->load_footer($data);
            }
            else
            {
                redirect('Marking');
            }
        }
    }

    function export_score($asg_id = null)
    {
        if ($this->check_permission(20) ) {
            if ($asg_id) {
                $this->load->library('excel');
                $objPHPExcel = new PHPExcel();
                $objPHPExcel->setActiveSheetIndex(0);
                $objPHPExcel->getActiveSheet()->SetCellValue('A1', 'Unit');
                $objPHPExcel->getActiveSheet()->SetCellValue('B1', 'Student ID');
                $objPHPExcel->getActiveSheet()->SetCellValue('C1', 'Username');
                $objPHPExcel->getActiveSheet()->SetCellValue('D1', 'Student Name');
                $objPHPExcel->getActiveSheet()->SetCellValue('E1', 'Group');
                $objPHPExcel->getActiveSheet()->SetCellValue('F1', 'Group Score');       
                $objPHPExcel->getActiveSheet()->SetCellValue('G1', 'Peer Score');       
                $objPHPExcel->getActiveSheet()->SetCellValue('H1', 'Total Score');       
                $rowCount = 2;
                $this->load->model('Submission_model');
                $score_list = $this->Submission_model->get_final_score($asg_id);
                $unit_code='';
                foreach ($score_list as $list) {
                    $unit_code=$list['unit_code'];
                    $objPHPExcel->getActiveSheet()->SetCellValue('A' . $rowCount, $list['unit_code']);
                    $objPHPExcel->getActiveSheet()->SetCellValue('B' . $rowCount, $list['sid']);
                    $objPHPExcel->getActiveSheet()->SetCellValue('C' . $rowCount, $list['username']);
                    $objPHPExcel->getActiveSheet()->SetCellValue('D' . $rowCount, $list['first_name']. ' ' . $list['last_name']);
                    $objPHPExcel->getActiveSheet()->SetCellValue('E' . $rowCount, $list['topic']);
                    $objPHPExcel->getActiveSheet()->SetCellValue('F' . $rowCount, $list['group_score']?sprintf("%.2f", $list['group_score']):0);
                    $objPHPExcel->getActiveSheet()->SetCellValue('G' . $rowCount, $list['peer_score']?sprintf("%.2f", $list['peer_score']):0);
                    $objPHPExcel->getActiveSheet()->SetCellValue('H' . $rowCount, $list['total_score']?sprintf("%.2f", $list['total_score']):0);
                    $rowCount++;
                }
                $filename = "final_score_". date("Ymd_His").".xlsx";
                if ($unit_code)
                {
                    $filename = $unit_code."_final_score_". date("Ymd_His").".xlsx";
                }
                $objWriter = new PHPExcel_Writer_Excel2007($objPHPExcel);
                $objWriter->save('./export/'.$filename);
                // download file
                header("Content-Type: application/vnd.ms-excel");
                redirect(base_url()."/export/".$filename); 
            }
            else
            {
                redirect('Marking');
            }
        }
    }

    function peer_detail($asg_id = null, $group_id = null, $username = null)
    {
        if ($this->check_permission(20, false) ) {
            if ($asg_id && $group_id && $username) {
                $data['asg_id'] = $asg_id;
                $data['group_id'] = $group_id;
                $data['username'] = $username;
                $this->load->model('Assignment_feedback_model'); 
                $this->load->model('Assignment_question_model'); 
                $this->load->model('Assignment_topic_model');
                $this->load->model('Submission_model');
                $data['summary'] = $this->Submission_model->get_peer_review_summary($asg_id,$username);
                $data['assignment_questions_self'] = $this->Assignment_feedback_model->get_question_with_feedback($asg_id,$username,$username,'SELF');
                $data['assignment_topics_member'] = $this->Assignment_topic_model->get_assignment_member($group_id);
                foreach($data['assignment_topics_member'] as $member) {
                    $data['assignment_questions_peer'][$member['user_id']] = $this->Assignment_feedback_model->get_question_with_feedback($asg_id,$member['user_id'],$username,'PEER');
                }
                $this->load->view('pages/assignment_marking/peer_detail',$data);
            }
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
                    'group_id' => $this->input->post('topic_id')
                );
                if (isset($_POST['score'])) {
                    $params['score'] = $this->input->post('score');
                }
                if (isset($_POST['remark'])) {
                    $params['remark'] = $this->input->post('remark');
                }
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

    function override_peer_mark()
    {
        header('Content-Type: application/json');
        $done = false;
        $http_code = 500;
        $score_id = null;
        if ($this->check_permission(20, false) ) {
            if (isset($_POST['asg_id']) && isset($_POST['username']) ) {
                $this->load->model('Assignment_mark_model');
                $params = array(
                    'asg_id' => $this->input->post('asg_id'),
                    'username' => $this->input->post('username')
                );
                if (isset($_POST['score'])) {
                    $params['score'] = $this->input->post('score');
                }
                if (isset($_POST['remark'])) {
                    $params['remark'] = $this->input->post('remark');
                }
                if (isset($_POST['score_id'])) {
                    if ( !empty($_POST['score_id']) ) {
                        $score_id = $this->input->post('score_id');
                    }
                }
                $current_user = $this->get_login_user();
                if (!$score_id) 
                {
                    $score_id = $this->Assignment_mark_model->create_peer_mark($current_user, $params);
                }
                else 
                {
                    $this->Assignment_mark_model->update_peer_mark($score_id, $current_user, $params);
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
